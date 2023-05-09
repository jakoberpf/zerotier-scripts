#!/usr/bin/env bash

TMP_ZEROTIER_API="http://localhost:4000/api"
TMP_ZEROTIER_TOKEN=""
TMP_ZEROTIER_NETWORK=""
TMP_ZEROTIER_MEMBER=""

zt_get_token() {
    docker exec -u root zu-main cat /app/backend/data/db.json | jq '.users[0].token' | tr '"' ' ' | xargs
}

zt_get_networks() {
    curl -s -X GET -H "Authorization: token $1" $TMP_ZEROTIER_API/network
}

zt_create_network() {
    curl -s -X POST -H "Authorization: token $1" -d '{}' $TMP_ZEROTIER_API/network
}

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'
    load 'helpers/bats-file/load'
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"

    docker compose --file docker-compose.yaml up -d

    TMP_ZEROTIER_TOKEN=$(zt_get_token)

    if [ "$(zt_get_networks $TMP_ZEROTIER_TOKEN | xargs)"="[]" ]; then
        echo "No networks created, creating new one"
        zt_create_network $TMP_ZEROTIER_TOKEN
        # zt_get_networks $TMP_ZEROTIER_TOKEN
    else
        echo "There is already a network created"
    fi 
}

@test "should install zerotier" {
    run bash -c "docker exec -u root zerotier-scripts-client-1 /zerotier-installer.sh | tail -2"
    assert_output --partial 'Success!'
    run bash -c "docker exec -u root zerotier-scripts-client-1 zerotier-cli info | cut -d ' ' -f 1 | xargs"
    assert_output '200'
    # TODO simply join network and verify successfull join
}

teardown() {
    docker compose --file docker-compose.yaml down
}
