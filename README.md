### Description
Script to help you attach or detach USB devices from a running libvirt virtual machine.

The script depends on:
* virsh
* lsusb
* fzf
* cut
* awk
* grep
* printf
* tr
* sed
* cat
* sudo

### Usage

```sh
libvirt-attach-usb.bash [-h] ["DOMAIN"] ["USB_ID1,USB_ID2"]
```

DOMAIN and USB_ID are optional. If empty, the script will use fzf to help you select the desired domain and USB device.

Print the usage information:
```sh
libvirt-attach-usb.bash -h
```
Or
```sh
libvirt-attach-usb.bash --help
```

List attached USB devices:
```sh
libvirt-attach-usb.bash -l
```
Or
```sh
libvirt-attach-usb.bash --list
```

Attach/detach USB device from domain:
```sh
libvirt-attach-usb.bash DOMAIN_NAME USB_ID
``` 

The '-d/--detach' option should list the attached USB devices.
