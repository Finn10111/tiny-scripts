#!/bin/bash
if [[ -f $1 ]]
then
    openssl x509 -noout -fingerprint -sha256 < $1 | tr -d : | sed 's/SHA256 Fingerprint=//'
else
    echo "usage: $0 certificate-file"
fi
