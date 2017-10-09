Prerequisites
==

Compile and install ssr-libev.

Installation notes
==

Install ssr.json to /etc

Install ss-\* to /usr/local/bin

Install ss-redir.service to /etc/systemd/system and reload your systemd daemon

Download your cidr skip list to /etc/cidrskip.txt, you can obtain one from
[here](https://www.countryipblocks.net/country_selection.php).


This helper program only supports ssr-libev, but you can easily change the code
to fit the standard ss as well.

Usage
==

Only support systemd enabled systems. It can only be run under root. Only
support eth0 card, unless you change the code.

sudo by default only find binary from /usr/bin:/usr/sbin:/sbin, you can
manually add /usr/local/bin to the `secure_path`.

ss-change -h for help
