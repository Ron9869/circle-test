#/bin/bash

set -e

bastion_ip="34.207.40.58"
deploy_user="circleci"
service_name="ciq-finantials-provider"
swarm_master_ip="172.31.96.208"
network_name="koyfin"
node_label="node.labels.group!=masters"
test="aaaa"

cat <<EOF >> ~/.ssh/known_hosts
34.207.40.58 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFLl4WK42/V1qgec1S1wNjbjeFQZ6rlsa34UYDOaHwhIVU6SNo2itzZwNf6oi4y0zBAVudJQw6g9+5GKtRlhmAE=
172.31.96.208 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHHQdkO+/aULBMZyVpR3mk+2mU1OU9Ljf6RN/4qse3aoXqPA2ZlIpBjtwSL5mjr74bLZVJY+bWMZu+NXXeN4lSo=
EOF

ssh -T \
    -o ProxyCommand="ssh -A -q -W %h:%p ${deploy_user}@${bastion_ip}" \
    ${deploy_user}@${swarm_master_ip} \
<<EOF
    set -e
    network_created=\$(docker network ls --filter name=koyfin --quiet)
    echo \${network_created}
    echo ${CIRCLE_SHA1:0:8}

    if [[ -z "\${network_created}" ]]
    then
        echo "Creating network koyfin"
        cmd='docker network create --driver overlay ${network_name}'
        echo "\${cmd}"
        eval \${cmd}
    fi

    service_created=\$(docker service ls --filter name=${service_name} --quiet)

    if [[ -z "\${service_created}" ]]
    then
        echo "Creating service ${service_name}"
        cmd='docker service create
            --with-registry-auth
            --name ${service_name}
            --env TET=TEST
            --network=${network_name}
            --constraint "${node_label}"
            koyfin/ciq-finantials-provider:${CIRCLE_BRANCH}-${CIRCLE_SHA1:0:8} sleep 100000'
        echo "\${cmd}"
        eval \${cmd}
    else
        echo "Updating service ${service_name}"
        cmd='docker service update
            --with-registry-auth
            --env-add TET=TEST3
            --image koyfin/ciq-finantials-provider:${CIRCLE_BRANCH}-${CIRCLE_SHA1:0:8}
            --constraint-add "${node_label}"
            ${service_name}'
        echo "\${cmd}"
        eval \${cmd}
        test='ls -la ${test}'
        test2='ls -la \${test}'
        echo "\${test}"
        echo "\${test2}"
        eval \${test2}
    fi
    echo "end"
EOF
