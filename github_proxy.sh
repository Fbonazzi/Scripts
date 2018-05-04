#!/bin/sh
# Add the following lines to .ssh/config:
# Host github.com *.github.com
#   ProxyCommand=<THIS_SCRIPT> %h %p

echo "Using $0 as an SSH proxy..." 1>&2

if [ -z $https_proxy ]
then
  echo "Proxy not configured!" 1>&2
  exit 1
fi

# https_proxy = "https://user:pwd@ip:port"

USERNAME=$(echo $https_proxy | sed -E 's/https:\/\/([^:]+):([^@]+)@([^:]+):([0-9]+).*/\1/')
PASSWORD=$(echo $https_proxy | sed -E 's/https:\/\/([^:]+):([^@]+)@([^:]+):([0-9]+).*/\2/')
ADDRESS=$(echo $https_proxy | sed -E 's/https:\/\/([^:]+):([^@]+)@([^:]+):([0-9]+).*/\3/')
PORT=$(echo $https_proxy | sed -E 's/https:\/\/([^:]+):([^@]+)@([^:]+):([0-9]+).*/\4/')

# echo socat - PROXY:"$ADDRESS":$1:$2,proxyport="$PORT",proxyauth="$USERNAME":"$PASSWORD" 1>&2
socat - "PROXY:$ADDRESS:$1:$2,proxyport=$PORT,proxyauth=$USERNAME:$PASSWORD"
