# simplestatus

Designed as an example for use with the **autologin** script, this adds a simple program that runs automatically once the **autologin** user logs in, that regularly displays some system statistics. 

## How?

2 ways:

* Run **install.sh** to do it all for you (as root from any user, to make sure it has the permissions) - it will copy the scripts and append some lines to ~/.profile to run them.
* Copy all of the files in **files** to **/home/autologin** - and add **./start.sh** to the end of **/home/autologin/.profile**

## Can I stop it?

Yes. Press Ctrl+C.

## Can I remove it?

Yes. Edit ~/.profile and remove the lines added at the end (clearly marked).
