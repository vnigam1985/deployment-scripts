#!/usr/bin/python
"""
Please install cloudflare via pip, e.g. `pip install cloudflare`

This script handles the creation and update on a given domain, subdomain and an
IP which either be the public IP by default, or an internal IP if given device
name.

It only handles the IP and everything else is default or remain the same.

Note you need to have a ~/.cloudflare.cfg file with the following info:
[CloudFlare]
email = mail@example.com
token = your_token
certtoken = v1.0-....
extras = [leave blank here]

Usage:
    ./ddns.py domain subdomain [device]
"""
from __future__ import print_function
import sys
import requests as rq
import CloudFlare
import socket
import struct
import fcntl

# Get global value
arg_length = len(sys.argv)

if arg_length >= 3:
    DOMAIN = sys.argv[1]
    SUBDOMAIN = sys.argv[2]
    DEV = None
    if arg_length == 4:
        DEV = sys.argv[3]
else:
    print("Usage: %s appkey email domain_name subdomain_name [device]" \
            % sys.argv[0], file=sys.stderr)
    sys.exit(1)

cf = CloudFlare.CloudFlare()

def getip():
    """ Get the WAN ip (ipv4) and return it. """
    resp = rq.get('http://ipv4.luxing.im')
    return resp.text.strip().encode('ascii')


def get_zone_id():
    """
    Get the zone id.
    """
    zones = cf.zones.get()
    for zone in zones:
        if zone['name'] == DOMAIN:
            zone_id = zone['id']

    return zone_id


def update_dns(record, ip):
    """
    Update the given DNS record.

    Returns nothing
    """
    zone_id = record['zone_id']
    domain_id = record['id']
    record['content'] = ip
    ret = cf.zones.dns_records.put(zone_id, domain_id, data=record)


def create_dns(ip):
    """
    Create the DNS record for the subdomain if one does not exist.

    Returns Nothing
    """
    zone_id = get_zone_id()
    ret = cf.zones.dns_records.post(zone_id, data={'type' : 'A',
        'name' : SUBDOMAIN, 'content' : ip})


def check_subdomain_exists():
    """
    Check whether the subdomain already exists.

    Return the record json or False
    """
    zone_id = get_zone_id()
    page = 1
    records = cf.zones.dns_records.get(zone_id, params = {'per_page' : 100,
        'page' : page})
    while len(records) > 0:
        for record in records:
            if record['name'].lower() == '%s.%s' % (SUBDOMAIN.lower(), DOMAIN.lower()):
                return record
        page += 1
        records = cf.zones.dns_records.get(zone_id, params = {'per_page' : 100,
            'page' : page})

    return False


def get_my_internal_ip(dev):
    """
    Grab from https://github.com/lilydjwg/winterpy/blob/master/pylib/netutils.py
    """
    ifname = dev.encode("ascii")
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ip = socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s',
        ifname[:15]))[20:24])
    return ip

if __name__ == '__main__':
    if DEV:
        ip = get_my_internal_ip(DEV)
    else:
        ip = getip()

    record = check_subdomain_exists()
    if record:
        update_dns(record, ip)
    else:
        create_dns(ip)
