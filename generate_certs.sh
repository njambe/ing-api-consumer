#!/usr/bin/env bash

for dir in tls_mutual3 http_sign3
do
  if [ ! -d $dir ]
  then
    echo "====== Creating directory $dir"
    mkdir $dir
  fi
  
  pushd $dir > /dev/null
	
  if [ ! -f server.key ]
  then
    echo "====== Generating private key [${dir}/server.key]"
    openssl genrsa -out server.key 2048
  fi
    
  if [ ! -f server.csr ]
  then
    echo "====== Generating Certificate Signing Request [${dir}/server.csr]"
    openssl req -sha256 -new -key server.key -out server.csr
  fi
    
#  if [ -f server_public.crt ]
#  then
#    echo "Deleting old certificate [${dir}/server_public.crt]"
#    rm server_public.crt
#  fi

  if [ ! -f server_public.crt ]
  then
    echo "====== Generating Certificate [${dir}/server_public.crt]"
    openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server_public.crt
  fi

  echo "====== Certificate fingerprint [${dir}/server_public.crt]"
  openssl x509 -fingerprint -in server_public.crt -noout

  popd > /dev/null
done
