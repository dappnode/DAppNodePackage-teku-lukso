#!/bin/bash

NETWORK="lukso"
VALIDATOR_PORT=3500
WEB3SIGNER_API="http://web3signer.web3signer-${NETWORK}.dappnode:9000"

# If FEE_RECIPIENT_ADDRESS is an eth address, set it
if [[ $FEE_RECIPIENT_ADDRESS =~ ^0x[a-fA-F0-9]{40}$ ]]; then
  EXTRA_OPTS="--validators-proposer-default-fee-recipient=$FEE_RECIPIENT_ADDRESS ${EXTRA_OPTS}"
fi

# Teku must start with the current env due to JAVA_HOME var
exec /opt/teku/bin/teku --log-destination=CONSOLE \
  validator-client \
  --network=${NETWORK} \
  --data-base-path=/opt/teku/data \
  --beacon-node-api-endpoint="$BEACON_NODE_ADDR" \
  --validators-external-signer-url="$WEB3SIGNER_API" \
  --metrics-enabled=true \
  --metrics-interface 0.0.0.0 \
  --metrics-port 8008 \
  --metrics-host-allowlist=* \
  --validator-api-enabled=true \
  --validator-api-interface=0.0.0.0 \
  --validator-api-port="$VALIDATOR_PORT" \
  --validator-api-host-allowlist=* \
  --validators-graffiti="${GRAFFITI:0:32}" \
  --validator-api-keystore-file=/cert/teku_client_keystore.p12 \
  --validator-api-keystore-password-file=/cert/teku_keystore_password.txt \
  --logging="${LOG_TYPE}" \
  --doppelganger-detection-enabled=true \
  ${EXTRA_OPTS}
