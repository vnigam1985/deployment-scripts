#!/usr/bin/python
# Author:   Luxing Huang (luxing@huang.cool)
# Purpose:  Merging a specific Chef environment into another, or into a
#           template.
# Note:     This can also be applied to Role files and Data Bag files, as long
#           as they are valid JSON files.
#
#           This script always creates a 3rd json file because we wouldn't want
#           to overwrite the 2nd file for backup purpose.
from __future__ import print_function
import json
import os
import sys
import argparse

DEFAULT_KEYWORD = "template_default"

arg = argparse.ArgumentParser(description="I merge environments/roles into each other, or to the template")
arg.add_argument("-y", "--yes", help="Assume yes to overwrite 3rd argument if that file already exists.", dest="ifyes", action="store_true", required=False)
arg.add_argument("env1", type=str, help="first environment file, e.g. env1.json")
arg.add_argument("env2", type=str, help="second environment or template, e.g. env2.json")
arg.add_argument("merged", type=str, help="The target template file name, e.g. template.json")
arg.set_defaults(ifyes=False)
args = arg.parse_args()

env1_name = ""
env2_name = ""

def merge(j_env1, j_env2):
  """ Merge 2 jsons into 1 and return the combined json """
  # Creating a locally empty json template for argv[3]
  j_template = {}

  for key in j_env1.keys():
    # if env2 has no such key:
    if not j_env2.has_key(key):
      # add the new entry to template
      j_template[key] = j_env1[key]
      # On to the next key
      continue

    if j_env1[key] == j_env2[key]:
      # Then we update the key in our template json.
      j_template.update({key: j_env2[key]})
      # on to the next key
      continue
    else:
      # env1 = template, env2 = string
      if isinstance(j_env1[key], dict) and isinstance(j_env2[key], unicode):
        print("Please do manual integration at key %s because env1 is a dict but env2 is a string" % key)
        sys.exit(2)

      # If env1 = str, env2 = str
      if isinstance(j_env1[key], unicode) and isinstance(j_env2[key], unicode):
        # obtain the name of env2
        if env2_name == "":
          # if the env2 name is missing, we assume env2 is actually a template.
          # so we set it as the default value.
          j_template[key] = {DEFAULT_KEYWORD : j_env2[key], env1_name : j_env1[key]}
        else:
          # Env2 is actually an environment
          j_template[key] = {DEFAULT_KEYWORD : "", env1_name : j_env1[key],
              env2_name : j_env2[key]}
        # On to the next key
        continue

      # If env2 is a template and env1 is merging into it
      if isinstance(j_env1[key], unicode) and isinstance(j_env2[key], dict):
        # make sure it is a templated dict
        if j_env2[key].has_key(DEFAULT_KEYWORD):
          # copy env2 to the new template json
          j_template[key] = j_env2[key]
          # add or update env1 entry to it
          j_template[key].update({env1_name : j_env1[key]})
          # On to the next key
          continue
        else:
          print("env2 file does not have a %s key on parent key %s, abort." %
              (DEFAULT_KEYWORD, key), file=sys.stderr)
          sys.exit(1)

      if isinstance(j_env1[key], dict) and isinstance(j_env2[key], dict):
        # if env1 is a dict, stop
        if j_env1[key].has_key(DEFAULT_KEYWORD) or j_env2[key].has_key(DEFAULT_KEYWORD):
          print("either environments must not be dict templates on %s." % key, file=sys.stderr)
          sys.exit(2)
        # Recursive call to build json's sub tree.
        j_template[key] = merge(j_env1[key], j_env2[key])
        continue

  return j_template

if __name__ == "__main__":
  # read env1 and env2 values and dict-ize
  env1_fp = open(args.env1, 'r')
  try:
    env1_json = json.load(env1_fp)
  except:
    print("Cannot parse json, check if it's valid?", file=sys.stderr)
    sys.exit(2)
  env1_fp.close()

  env2_fp = open(args.env2, 'r')
  try:
    env2_json = json.load(env2_fp)
  except:
    print("Cannot parse json, check if it's valid?", file=sys.stderr)
    sys.exit(2)
  env2_fp.close()

  # set global name for env1/2
  try:
    name = env1_json['name']
  except KeyError:
    print("Name key not found in 1st environment. Giving up")
    sys.exit(1)

  if not isinstance(name, unicode):
    print("file 1 must be an environment, not a template!", file=sys.stderr)
    sys.exit(1)
  else:
    env1_name = name

  try:
    name = env2_json['name']
  except KeyError:
    print("Required name key not found in 2nd environment/template. Giving up")
    sys.exit(1)

  if isinstance(name, unicode):
    # It's an environment
    env2_name = name
  else:
    # It's a template
    pass

  merge_json = merge(env1_json, env2_json)

  if args.ifyes is False:
    if os.path.exists(args.merged):
      answer = raw_input("Do you really want to overwrite %s? type YES to proceed: " % args.merged).strip()
      if answer != "YES":
        print("Abort.", file=sys.stderr)
        sys.exit(2)
      merge_fp = open(args.merged, 'w')

  json.dump(merge_json, merge_fp, sort_keys=True, indent=2)
  merge_fp.close()
