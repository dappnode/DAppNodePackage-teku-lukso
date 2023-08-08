#!/bin/bash

# Concatenate EXTRA_OPTS string
[[ -n $CHECKPOINT_SYNC_URL ]] && EXTRA_OPTS="--initial-state=$(echo $CHECKPOINT_SYNC_URL | sed 's:/*$::')/eth/v2/debug/beacon/states/finalized ${EXTRA_OPTS}"

case $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_LUKSO in
"lukso-geth.dnp.dappnode.eth")
    HTTP_ENGINE="http://lukso-geth.dappnode:8551"
    ;;
"lukso-nethermind.dnp.dappnode.eth")
    HTTP_ENGINE="http://lukso-nethermind.dappnode:8551"
    ;;
"lukso-besu.dnp.dappnode.eth")
    HTTP_ENGINE="http://lukso-besu.dappnode:8551"
    ;;
"lukso-erigon.dnp.dappnode.eth")
    HTTP_ENGINE="http://lukso-erigon.dappnode:8551"
    ;;
*)
    echo "Unknown value for _DAPPNODE_GLOBAL_EXECUTION_CLIENT_LUKSO: $_DAPPNODE_GLOBAL_EXECUTION_CLIENT_LUKSO"
    HTTP_ENGINE=$_DAPPNODE_GLOBAL_EXECUTION_CLIENT_LUKSO
    ;;
esac

exec /opt/teku/bin/teku \
    --network=lukso \
    --data-base-path=/opt/teku/data \
    --ee-endpoint=$HTTP_ENGINE \
    --ee-jwt-secret-file="/jwtsecret" \
    --p2p-port=$P2P_PORT \
    --rest-api-cors-origins="*" \
    --rest-api-interface=0.0.0.0 \
    --rest-api-port=$BEACON_API_PORT \
    --rest-api-host-allowlist "*" \
    --rest-api-enabled=true \
    --rest-api-docs-enabled=true \
    --metrics-enabled=true \
    --metrics-interface 0.0.0.0 \
    --metrics-port 8008 \
    --metrics-host-allowlist "*" \
    --log-destination=CONSOLE \
    --validators-proposer-default-fee-recipient="${FEE_RECIPIENT_ADDRESS}" \
    $EXTRA_OPTS
