### Demo
Here is a demonstration of the script working from a SSH session on Windows:
![](https://github.com/lfcarrega/libvirt-attach-usb/blob/main/demo.gif)

### Description
Bash script to help you attach or detach USB devices from a running libvirt virtual machine.

### Dependencies
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
mkdir -p $HOME/.local/bin && wget https://raw.githubusercontent.com/lfcarrega/libvirt-attach-usb/main/libvirt-attach-usb.bash -O $HOME/.local/bin/libvirt-attach-usb && chmod +x $HOME/.local/bin/libvirt-attach-usb
```

### Usage

Available options:

-h, --help              Print this help and exit.
-l, --list "DOMAIN"     List USB devices attached to DOMAIN.
-d, --detach "DOMAIN"   List and let you pick the one to be detached.

```sh
libvirt-attach-usb [-h/-l/d] ["DOMAIN"] ["USB_ID1,USB_ID2"]
```

DOMAIN and USB_ID are optional.
NOTE: Use Tab or Shift+Tab to select multiple USB devices.

Print the usage information:
```sh
libvirt-attach-usb -h
```

Attach/detach USB device from domain:
```sh
libvirt-attach-usb ["DOMAIN"] ["USB_ID1,USB_ID2"]
``` 

List attached USB devices:
```sh
libvirt-attach-usb -l ["DOMAIN"]
```

Detach USB from domain:
```sh
libvirt-attach-usb -d ["DOMAIN"] ["USB_ID1,USB_ID2"]
```
