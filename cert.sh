#!/bin/bash

#Required
domain=$1
commonname=$domain

#Change to your company details
country=XX
state=SomeState
locality=SomeCity
organization='Company Co'
organizationalunit='Company Co'
email=admin@example.com

#Optional
#password=dummypassword

if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Usage $0 [domain name for CN name]"

    exit 99
fi

echo "Generating a root private key and creating a self-signed CA"

openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -days 1024 -out rootCA.pem -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "Generating key request for $domain"

echo "Generate a private key for the certitificate"

openssl genrsa -out $domain.key 2048
chmod 400  $domain.key

echo "Create the request"

openssl req -new -key $domain.key -out $domain.csr -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "Create endpoint certificate"

openssl x509 -req -in $domain.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out $domain.crt -days 500

cp ./rootCA.pem ./$domain.crt ./$domain.key /etc/postfix

postconf -e smtpd_tls_key_file=/etc/postfix/$domain.key
postconf -e smtpd_tls_cert_file=/etc/postfix/$domain.crt
postconf -e smtpd_tls_CAfile=/etc/postfix/rootCA.pem
[root@ppu17-5 wpt]#  sed -i 's/\r//g' cert.sh
[root@ppu17-5 wpt]# cat cert.sh
#!/bin/bash

#Required
domain=$1
commonname=$domain

#Change to your company details
country=XX
state=SomeState
locality=SomeCity
organization='Company Co'
organizationalunit='Company Co'
email=admin@example.com

#Optional
#password=dummypassword

if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Usage $0 [domain name for CN name]"

    exit 99
fi

echo "Generating a root private key and creating a self-signed CA"

openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -days 1024 -out rootCA.pem -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "Generating key request for $domain"

echo "Generate a private key for the certitificate"

openssl genrsa -out $domain.key 2048
chmod 400  $domain.key

echo "Create the request"

openssl req -new -key $domain.key -out $domain.csr -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "Create endpoint certificate"

openssl x509 -req -in $domain.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out $domain.crt -days 500

cp ./rootCA.pem ./$domain.crt ./$domain.key /etc/postfix

postconf -e smtpd_tls_key_file=/etc/postfix/$domain.key
postconf -e smtpd_tls_cert_file=/etc/postfix/$domain.crt
postconf -e smtpd_tls_CAfile=/etc/postfix/rootCA.pem
