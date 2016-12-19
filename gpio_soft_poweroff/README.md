# gpio_soft_poweroff

Based on https://www.element14.com/community/docs/DOC-78055/l/adding-a-shutdown-button-to-the-raspberry-pi-b
Credits go to **Inderpreet Singh**, thank you.

* Initiates a controlled shutdown of your Raspberry Pi if GPIO pin 21 is connected to ground via a button.
* On a modern Pi with a 40 pin GPIO connector, connect a button and 10K resistor between pins 39 and 40.
* Logs shutdowns to /var/log/manual_shutdown.log
* **Make sure you connect the button between the correct GPIO pins!**
* Based on https://www.element14.com/community/docs/DOC-78055/l/adding-a-shutdown-button-to-the-raspberry-pi-b

## Status

**Stable; ready for use.**

## How do I use this?

* Connect a button and 10K resistor between GPIO pin 21 and ground (the GPIO connector pins 39 and 40 are convenient!)
* Run install.sh as root, then reboot your Pi.
* Once your Pi is running, press the button and your Pi should shutdown.
* **It will not power off completely due to hardware limitations.** however it is extremely useful to shutdown the Pi without needing to SSH to it.

## How do I remove it?

* Currently there is no automatic script (coming soon)
* Run these commands:
```
sudo killall -9 shutdown_button.py
sudo rm /usr/sbin/shutdown_button.py
sudo rm /pitools/gpio_soft_poweroff
```
* Edit /etc/rc.local and remove the the line that says **/usr/sbin/shutdown_button.py**
