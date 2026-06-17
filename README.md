### Demo
Here is a demonstration of the script working from a SSH session:
![](https://github.com/lfcarrega/libvirt-attach-usb/blob/main/demo.gif)

### Description
Bash script to help you attach or detach USB devices, ISO's and ~maybe~ block devices from a running libvirt (virsh) virtual machine.

### Dependencies
* virsh
* lsusb
* fzf
* sudo
* xmllint

### Installation

```sh
mkdir -p $HOME/.local/bin && wget https://raw.githubusercontent.com/lfcarrega/libvirt-attach-usb/main/libvirt-attach-usb -O $HOME/.local/bin/libvirt-attach-usb && chmod +x $HOME/.local/bin/libvirt-attach-usb
```

### Usage

```sh
Usage: libvirt-helper [option]

Options:
  -h, --help                                               Print this help message.
  -l, --list-usb [DOMAIN]                                  List attached USB devices.
  -d, --detach-usb [DOMAIN] [USB_ID1,USB_ID2...]           Detach USB device.
  -a, --attach-usb [DOMAIN] [USB_ID1,USB_ID2...]           Attach USB device.
  -r, --remove-usb [DOMAIN]				                   Remove unavailable USB devices from the domain XML.
  -u, --list-iso [DOMAIN] [TARGET_DEVICE]                  List attached iso.
  -i, --insert-iso /path/to/iso [DOMAIN] [TARGET_DEVICE]   Attach iso file.
  -e, --eject-iso DOMAIN] [TARGET_DEVICE]                  Detach iso file.
```
