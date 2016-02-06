#!/usr/bin/python
"""
An environment file generator.

It uses a special keyword template_default to extract values.
DO NOT use that keyword for keys!

Usage: ./gen.py template.json test001

Author: Luxing Huang (luxing@huang.cool)
"""
from __future__ import print_function

import os
import sys
import json
import pprint

DEFAULT_KEYWORD = 'template_default'

if len(sys.argv) != 3:
  print("Usage: ./gen.py template.json test001")
  sys.exit(1)

env = sys.argv[2]

templatefp = open(sys.argv[1], 'r')
template_json = json.load(templatefp)
templatefp.close()

def mod(jo):
  if not isinstance(jo, dict):
    return jo

  if DEFAULT_KEYWORD in jo.keys():
    if env in jo.keys():
      return jo[env]
    else:
      return jo[DEFAULT_KEYWORD]
  else:
    for k in jo.keys():
      jo[k] = mod(jo[k])

  return jo

env_json = mod(template_json)

envfp = open(env + '.json', 'w')
json.dump(env_json, envfp, sort_keys=True, indent=2)
envfp.close()
