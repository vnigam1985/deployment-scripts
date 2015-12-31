#!/bin/sh
# Support CentOS/RHEL 7 only.
# Usage: setup.sh /path/to/server.key /path/to/server.crt /path/to/ca.crt username password
# default VPN group is: vpn
# default internal ip: 192.168.238.*
if [ -z $5 ]; then
    echo "Usage: setup.sh /path/to/server.key /path/to/server.crt\
 /path/to/ca.crt username password"
    exit 1
fi

if [ `whoami` != 'root' ]; then
    echo "Needs to be root"
    exit 2
fi

yum install ocserv firewalld -y

if [ `which firewalld` != '/usr/sbin/firewalld' ]; then
    echo "Only support firewalld for now"
    exit 3
fi

# certificate related
mkdir -p /etc/ocserv/ssl

cp $1 /etc/ocserv/ssl/server.key
cp $2 /etc/ocserv/ssl/server.crt
cp $3 /etc/ocserv/ssl/ca.crt

openssl dhparam -out /etc/ocserv/ssl/dhparam.pem 2048

# ocserv configuration
cat > /etc/ocserv/ocserv.conf <<EOF
auth = "plain[passwd=/etc/ocserv/ocpasswd]"
tcp-port = 443
udp-port = 443
run-as-user = ocserv
run-as-group = ocserv
socket-file = ocserv.sock
chroot-dir = /var/lib/ocserv
isolate-workers = true
max-clients = 64
max-same-clients = 5
keepalive = 32400
dpd = 1800
mobile-dpd = 1800
try-mtu-discovery = true
server-cert = /etc/ocserv/ssl/server.crt
server-key = /etc/ocserv/ssl/server.key
dh-params = /etc/ocserv/ssl/dhparam.pem
ca-cert = /etc/ocserv/ssl/ca.crt
cert-user-oid = 0.9.2342.19200300.100.1.1
tls-priorities = "NORMAL:%SERVER_PRECEDENCE:%COMPAT:-VERS-SSL3.0"
auth-timeout = 40
min-reauth-time = 300
max-ban-score = 50
ban-reset-time = 300
cookie-timeout = 32400
deny-roaming = false
rekey-time = 172800
rekey-method = ssl 
use-occtl = true
pid-file = /var/run/ocserv.pid
device = vpns
predictable-ips = true
default-domain = your-domain.com
ipv4-network = 192.168.238.0
ipv4-netmask = 255.255.255.0
dns = 8.8.8.8
dns = 8.8.4.4
ping-leases = false 
no-route = 192.168.0.0/255.255.0.0
no-route = 172.16.0.0/255.240.0.0
no-route = 169.254.0.0/255.255.0.0
no-route = 10.0.0.0/255.0.0.0
no-route = 127.0.0.0/255.0.0.0
cisco-client-compat = true
EOF

# User generation
ocpasswd -g vpn $4 <<EOF
$5
$5
EOF

# Setup firewalld
cat > /etc/firewalld/services/ocserv.xml <<EOF
<?xml version="1.0" encoding="utf-8" ?>
<service>
    <short>ocserver</short>
    <description>Cisco AnyConnect</description>
    <port protocol="tcp" port='443' />
    <port protocol="udp" port='443' />
</service>
EOF

firewall-cmd --permanent --add-service=ocserv
firewall-cmd --permanent --add-masquerade
firewall-cmd --reload

# start ocserv and firewalld
systemctl enable firewalld ocserv
systemctl start firewalld ocserv
