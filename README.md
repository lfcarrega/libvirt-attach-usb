### Demo
Here is a demonstration of the script working from a SSH session on Windows - outdated, but you'll get it:
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

Available options:

-l | --list [domain]\
-d | --detach-usb [domain] [usb_id1.usb_id2]\
-a | --attach-usb [domain] [usb_id1,usb_id2]\
-r | --remove-usb [domain]\
-u | --list-iso (NOT IMPLEMENTED YET)\
-i | --insert-iso /path/to/iso [domain] [cdrom_target]\
-e | --eject-iso (NOT IMPLEMENTED YET)
