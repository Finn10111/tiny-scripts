#!/bin/sh

# Just an example, I use this to copy a certificate to my firewall so it can be used by it (IPFire).
# Place this file in /etc/letsencrypt/renewal-hooks/post and modify it to your needs.
# Working key-based SSH root access is necessary.

scp /etc/letsencrypt/live/home.finnchristiansen.de-0001/privkey.pem root@ipfire:/etc/httpd/server.key
scp /etc/letsencrypt/live/home.finnchristiansen.de-0001/privkey.pem root@ipfire:/etc/httpd/server-ecdsa.key
scp /etc/letsencrypt/live/home.finnchristiansen.de-0001/cert.pem root@ipfire:/etc/httpd/server-ecdsa.crt
scp /etc/letsencrypt/live/home.finnchristiansen.de-0001/cert.pem root@ipfire:/etc/httpd/server.crt
ssh root@ipfire /etc/init.d/apache restart
