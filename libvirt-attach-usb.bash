#!/usr/bin/env bash

set -Eeo pipefail

# Print usage information.
usage() {
	printf 'Usage: %s [-h] ["DOMAIN"] ["USB_ID"]\n' "$(basename "${BASH_SOURCE[0]}")"
	printf '\n'
	printf 'Script to help you attach or detach USB devices from a running libvirt virtual machine.\n'
	printf 'They are optional but please respect the order of the parameters "DOMAIN" and "USB_ID".\n'
	printf 'Make sure virsh, lsusb, fzf, cut, awk, grep, printf, tr, sed, cat and sudo are in your PATH.\n'
	printf '\n'
	printf 'Available options:\n'
	printf '\n'
	printf -- '-h, --help\t\tPrint this help and exit.\n'
	printf -- '-l, --list "DOMAIN"\tList USB devices attached to DOMAIN.\n'
	printf -- '-d, --detach "DOMAIN"\tList and let you pick the one to be detached.\n'
	exit
}

# Check if the required commands are available.
command_check() {
	COMMAND_LIST=(fzf virsh sudo grep cut awk grep printf lsusb tr sed cat)
	for COMMAND in "${COMMAND_LIST[@]}"; do
			if ! type -t "$COMMAND" >/dev/null; then
				printf "Command %s not found.\n" "$COMMAND" >&2
				exit 1
			fi
	done
}

# Authenticate before piping to fzf.
sudo_init() {
	sudo -v
}

# Check if the domain is running or if the domain name matches what virsh knows.
domain_check() {
	if ! sudo virsh list --state-running --name | grep -q "$DOMAIN"; then
		printf "The domain name is incorrect or the machine isn't running.\n" >&2
		exit 1
	fi
}

# Get domain name from command line input or from a fzf list.
domain_get() {
	if [ -z "$1" ]; then
		sudo_init
		DOMAIN=$(sudo virsh list --state-running --name | tr '\n' ' ' | sed 's/ //g' | fzf)
	else
		DOMAIN="$1"
	fi
	domain_check
}

# Check if the USB ID matches what lsusb knows.
usb_check() {
	if ! lsusb | grep -q "$USB_ID"; then
		printf "USB device ID is incorrect or not plugged.\n" >&2
		exit 1
	fi
}

# Get USB ID from command line input or from a fzf list.
usb_get() {
	if [[ -z "${1}" && -v DOMAIN ]]; then
		USB=$(lsusb | fzf)
		USB_ID=$(printf "%s" "$USB" | awk '{print $6}')
		VENDOR_ID=$(printf "%s" "$USB_ID" | cut -d ":" -f1)
		PRODUCT_ID=$(printf "%s" "$USB_ID" | cut -d ":" -f2)
	else	
		USB_ID="$1"
		VENDOR_ID=$(printf "%s" "$USB_ID" | cut -d ":" -f1)
		PRODUCT_ID=$(printf "%s" "$USB_ID" | cut -d ":" -f2)
	fi
	usb_check
}

# Lists USB devices plugged into the specified domain.
# This function was created by ChatGPT.
list_usb_devices() {
	domain_get "$1"
	domain_check

	local VENDOR_PRODUCT_LIST=()

	# Parse vendorid:productid pairs from dumpxml output
	while IFS= read -r line; do
		if [[ $line =~ "vendor id='"(.*)"'/" ]]; then
			VENDOR="${BASH_REMATCH[1]}"
		elif [[ $line =~ "product id='"(.*)"'/" ]]; then
			PRODUCT="${BASH_REMATCH[1]}"
			VENDOR_PRODUCT_LIST+=("$VENDOR:$PRODUCT")
		fi
	done < <(sudo virsh dumpxml "$DOMAIN" | grep -E "<vendor id='|<product id='")

	# Retrieve information for each vendorid:productid pair
	for VENDOR_PRODUCT in "${VENDOR_PRODUCT_LIST[@]}"; do
		VENDOR=$(printf "%s" "$VENDOR_PRODUCT" | cut -d':' -f1)
		PRODUCT=$(printf "%s" "$VENDOR_PRODUCT" | cut -d':' -f2)
		USB_INFO=$(lsusb -d "$VENDOR:$PRODUCT" 2>/dev/null)
		if [[ -n $USB_INFO ]]; then
			printf "%s\n" "$USB_INFO"
		else
			printf "Couldn't retrieve information for Vendor:Product = %s\n" "$VENDOR_PRODUCT" >&2
		fi
	done

	exit 0
}

# Attach USB device to a running libvirt machine.
attach_usb_device() {
	if [[ -n "$DOMAIN" && "$USB_ID" ]]; then
		XML_FILE=$(mktemp)
		XML_CONTENT=$(cat <<-EOF
		<hostdev mode='subsystem' type='usb' managed='yes'>
			<source>
				<vendor id='0x${VENDOR_ID}'/>
				<product id='0x${PRODUCT_ID}'/>
			</source>
		</hostdev>
		EOF
				)
		printf "%s" "$XML_CONTENT" >"$XML_FILE"
		VIRSH_ATTACH_OUTPUT=$(sudo virsh attach-device "$DOMAIN" --file "$XML_FILE" --current 2>/dev/null || sudo virsh detach-device "$DOMAIN" --file "$XML_FILE" --current 2>/dev/null)
		case "$VIRSH_ATTACH_OUTPUT" in
			*"attached"*)
				printf "Device %s attached succesfully to the domain %s.\n" "$USB_ID" "$DOMAIN"
				;;
			*"detached"*)
				printf "Device %s detached succesfully from the domain %s.\n" "$USB_ID" "$DOMAIN"
				;;
		esac
		rm "$(mktemp)" 2>/dev/null
	fi
}

detach_usb_device() {
	domain_get "$1"
	domain_check
	USB_LIST=$(list_usb_devices "$DOMAIN")
	USB=$(printf "%s" "$USB_LIST" | fzf)
	USB_ID=$(printf "%s" "$USB" | awk '{print $6}')
	VENDOR_ID=$(printf "%s" "$USB_ID" | cut -d ":" -f1)
	PRODUCT_ID=$(printf "%s" "$USB_ID" | cut -d ":" -f2)
	attach_usb_device
	exit 0
}

# Call function to check the needed commands.
command_check

# Parameter handling.
while [ $# -gt 0 ]; do
	case "${1-}" in
		-h | --help) usage ;;
		-l | --list) list_usb_devices "$2" ;;
		-d | --detach) detach_usb_device "$2" ;;
		-?*) printf "Unknown option: %s\n" "$1" >&2; exit 1 ;;
		*) break ;;
	esac
	shift
done

# Get domain name from the first parameter.
domain_get "$1"

# Get USB ID from the second parameter.
usb_get "$2"

# Attach USB device to the running libvirt domain.
attach_usb_device

