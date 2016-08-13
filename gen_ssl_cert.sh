#!/bin/bash
HOSTNAME=$(hostname -f)
VALID=3650
openssl req -x509 -nodes -newkey rsa:4096 -keyout $HOSTNAME.key.pem -out $HOSTNAME.cert.pem -days $VALID
