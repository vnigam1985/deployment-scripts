#!/usr/bin/python
# This script updates the DNS record of the subdomain.domain you wanted to
# edit, act like a simple DDNS update.
# Only support A record and IPv4 address
from __future__ import print_function
import requests as rq
import json
import sys
import subprocess
import socket
import fcntl
import struct

API_URL = "https://www.cloudflare.com/api_json.html"
arg_length = len(sys.argv)

# Get global value
if arg_length >= 5:
    APPKEY = sys.argv[1]
    EMAIL = sys.argv[2]
    DOMAIN = sys.argv[3]
    SUBDOMAIN = sys.argv[4]
    if arg_length == 6:
      dev = sys.argv[5]
else:
    print("%s appkey email domain_name subdomain_name [device]" % sys.argv[0],
        file=sys.stderr)
    sys.exit(1)


def retrieve_id():
    """ Get the record id in CloudFlare system """
    rqdata = {'a' : "rec_load_all", 'tkn' : APPKEY, 'email' : EMAIL, 'z' : DOMAIN}
    
    ret = rq.post(API_URL, data=rqdata)
    
    ret_json = json.loads(ret.text)
    
    if ret_json['result'] != 'success':
        print("Retrieve failed for domain %s" % DOMAIN, file=sys.stderr)
        sys.exit(1)
    
    objs = ret_json['response']['recs']['objs']
    for subdomain in objs:
        if subdomain['display_name'] == SUBDOMAIN:
            return subdomain['rec_id']

    return None

def getip():
    """ Get the local ipv4 and return it. """
    args = ['curl', '-L', '-4', '-s', 'http://ip.luxing.im']
    p = subprocess.Popen(args, stdout=subprocess.PIPE)
    return p.communicate()[0].strip()


def ddns(subdomain_id, wan_ip):
    """ Update the record """
    rqdata = {'a': 'rec_edit', 'z' : DOMAIN, 'type' : 'A', 'id' : subdomain_id,
            'name' : SUBDOMAIN, 'content' : wan_ip, 'ttl' : 1, "service_mode" :
            0, 'tkn' : APPKEY, 'email' : EMAIL}
    ret = rq.post(API_URL, data=rqdata)
    ret_json = json.loads(ret.text)

    if ret_json['result'] != 'success':
        print("Update fail.", file=sys.stderr)
        print(ret_json['msg'], file=sys.stderr)
    else:
        print("success")


def get_my_internal_ip(dev):
    """
    Grab from https://github.com/lilydjwg/winterpy/blob/master/pylib/netutils.py
    """
    ifname = ifname.encode("ascii")
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    ip = socket.inet_ntoa(fcntl.ioctl(s.fileno(), 0x8915, struct.pack('256s',
        ifname[:15]))[20:24])
    return ip

if __name__ == '__main__':
    subdomain_id = retrieve_id()
    if subdomain_id is None:
        print("Sub domain not found.", file=sys.stderr)
        sys.exit(2)

    if arg_length == 6:
        current_wan_ip = get_my_internal_ip(dev)
    else:
        current_wan_ip = getip()

    ddns(subdomain_id, current_wan_ip)
