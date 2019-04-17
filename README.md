# frp_installer

## What is this
This is a simple script to install [frp](https://github.com/fatedier/frp/) client. Now it's only support amd64 Linux and has only been tested on ubuntu 18.10 x64 system.

## Usage:

### Install:

```
wget --no-check-certificate -qO /tmp/frp_installer.sh https://raw.githubusercontent.com/zebork/frp_installer/master/frp_installer.sh
sudo bash /tmp/frp_installer.sh install
```

### Uninstall:

```
wget --no-check-certificate -qO /tmp/frp_installer.sh https://raw.githubusercontent.com/zebork/frp_installer/master/frp_installer.sh
sudo bash /tmp/frp_installer.sh uninstall
```

## Tips:
The config file is "/etc/frp/frpc.ini"

The startup script is "/etc/init.d/frp"

You can start it manually.
```
/etc/init.d/frp start
```


