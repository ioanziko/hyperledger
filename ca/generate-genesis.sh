#!/bin/sh
# Generates the orderer | generate genesis block for ordererchannel
# export ORDERER_GENERAL_LOGLEVEL=debug
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=/etc/hyperledger/config/

# Create the Genesis Block
echo    '================ Writing Genesis Block ================'
configtxgen -profile OrdererGenesis -outputBlock /etc/hyperledger/config/zerodata-genesis.block -channelID ordererchannel
