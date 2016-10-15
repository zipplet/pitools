# simplestatus

Designed as an example for use with the **autologin** tool, this adds a simple program that runs automatically once the **autologin** user logs in, that regularly displays some system statistics. 

## Dependencies

* Requires the **autologin** tool to be installed.

## Status

**Stable; ready for use.**

## How?

* Run **install.sh** to do it all for you (as root from any user, to make sure it has the permissions) - it will copy the scripts and append some lines to ~/.profile to run them.

## Can I stop it?

Yes. Press Ctrl+C.

## Can I remove it?

Yes. Edit ~/.profile and remove the lines added at the end (clearly marked). Also delete /pitools/simplestatus
