#/bin/bash

set -e

#ssh-add -l

#mkdir ~/.ssh

cat <<EOF >> ~/.ssh/known_hosts
34.207.40.58 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFLl4WK42/V1qgec1S1wNjbjeFQZ6rlsa34UYDOaHwhIVU6SNo2itzZwNf6oi4y0zBAVudJQw6g9+5GKtRlhmAE=
172.31.96.208 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHHQdkO+/aULBMZyVpR3mk+2mU1OU9Ljf6RN/4qse3aoXqPA2ZlIpBjtwSL5mjr74bLZVJY+bWMZu+NXXeN4lSo=
EOF

ssh -o ProxyCommand="ssh -A -q -W %h:%p circleci@34.207.40.58" circleci@172.31.96.208 <<EOF
    set -e
    docker service ls
    network_created=\$(docker network ls --filter name=koyfin --quiet)
    echo \${network_created}
    echo ${CIRCLE_SHA1:0:8}

    if [[ -z "\${network_created}" ]]
    then
        echo "Creating network koyfin"
        docker network create --driver overlay koyfin
    fi

    service_created=\$(docker service ls --filter name=test1 --quiet)

    if [[ -z "\${service_created}" ]]
    then
        echo "Creating service test"
        docker service create --with-registry-auth --name test --env TET=TEST --network=koyfin --constraint "node.labels.group!=masters" koyfin/ciq-finantials-provider:${CIRCLE_BRANCH}-${CIRCLE_SHA1:0:8} sleep 100000
    fi
EOF


cat ~/.ssh/known_hosts
