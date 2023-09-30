### Demo
Here is a demonstration of the script working from a SSH session on Windows:
![](https://github.com/lfcarrega/libvirt-attach-usb/blob/main/demo.gif)

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

### Installation

```sh
wget https://raw.githubusercontent.com/lfcarrega/libvirt-attach-usb/main/libvirt-attach-usb.bash -O $HOME/.local/bin/libvirt-attach-usb
```

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
