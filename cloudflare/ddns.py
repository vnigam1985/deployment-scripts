#!/usr/bin/python
# This script updates the DNS record of the subdomain.domain you wanted to
# edit, act like a simple DDNS update.
# Only support A record and IPv4 address
from __future__ import print_function
import requests as rq
import json
import sys
import subprocess

API_URL = "https://www.cloudflare.com/api_json.html"

# Get global value
if len(sys.argv) == 5:
    APPKEY = sys.argv[1]
    EMAIL = sys.argv[2]
    DOMAIN = sys.argv[3]
    SUBDOMAIN = sys.argv[4]
else:
    print("Please provide appkey, email, domain name and subdomain name")
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


if __name__ == '__main__':
    subdomain_id = retrieve_id()
    if subdomain_id is None:
        print("Sub domain not found.", file=sys.stderr)
        sys.exit(2)
        
    current_wan_ip = getip()
    ddns(subdomain_id, current_wan_ip)
