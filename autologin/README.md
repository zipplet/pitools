# autologin

**This only works for modern versions of Raspbian based on Debian Jessie that use systemd!**

Make your Pi login automatically at startup easily. 

## Status

**Stable; ready for use.**

## How?

Run install.sh as root. An account called autologin will be created if it does not exist, and your Pi will be set to login to it automatically at bootup. You can then edit ~/.profile to add commands to run after automatic login, such as starting a program to display graphics or text.

## Can I undo this easily?

Yes. Just run uninstall.sh as root. You can even re-run install.sh again to re-enable it. Switch as many times as you want!
