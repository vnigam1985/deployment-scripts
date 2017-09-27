Prerequisites
==

Compile and install ssr-libev.

Installation notes
==

Install ssr.json to /etc

Install ss-\* to /usr/local/bin

Install ss-redir.service to /etc/systemd/system and reload your systemd daemon

Download your cidr skip list to /etc/cidrskip.txt, you can obtain one from:
https://www.ip2location.com/free/visitor-blocker

This helper program only supports ssr-libev

Usage
==

Only support systemd enabled systems. It can only be run under root.

sudo by default only find binary from /usr/bin:/usr/sbin:/sbin, you can
manually add /usr/local/bin to the `secure_path`.

ss-change -h for help
