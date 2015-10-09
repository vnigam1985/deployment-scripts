#!/bin/sh
curl https://www.cloudflare.com/api_json.html -d "a=rec_edit" -d "id=" -d "email=" -d "tkn=" -d "type=A" -d "z=" -d "name=" -d "content=`hostname -I | sed -e "s/ 192.168.122.1//g" | sed -e "s/ //g"`" -d "ttl=1" -d "service_mode=0"
echo
