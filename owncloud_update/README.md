ownCloud Updater
==

This ownCloud updater suits to my own configuration.

My set up is like this:
Under htdocs/
```
oc-7.x.x <- older version of ownCloud
oc-8.x.x <- actual latest files
oc-latest <- a soft link to oc-8.x.x
```

So Apache or Nginx will only look for the oc-latest folder to serve the web
content to my visitors.

Note
--
This script should be located at the same level of the oc-last file. e.g. under
/var/www:
```
oc-8.1.3
oc-latest
updater.sh
```
The script also changes some of the branding, e.g. title, baseurl etc. You have
to adjust them to suit your own needs.
