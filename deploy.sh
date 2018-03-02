#/bin/bash

set -e

ssh-add -l

mkdir ~/.ssh

cat <<EOF > ~/.ssh/known_hosts
34.207.40.58 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFLl4WK42/V1qgec1S1wNjbjeFQZ6rlsa34UYDOaHwhIVU6SNo2itzZwNf6oi4y0zBAVudJQw6g9+5GKtRlhmAE=
172.31.96.208 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHHQdkO+/aULBMZyVpR3mk+2mU1OU9Ljf6RN/4qse3aoXqPA2ZlIpBjtwSL5mjr74bLZVJY+bWMZu+NXXeN4lSo=
EOF

ssh -o ProxyCommand="ssh -A -q -W %h:%p circleci@34.207.40.58" circleci@172.31.96.208 docker service ls

cat ~/.ssh/known_hosts
