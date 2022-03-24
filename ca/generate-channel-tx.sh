#!/bin/bash
# Generates the orderer | generate the airline channel transaction

# export ORDERER_GENERAL_LOGLEVEL=debug
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=/etc/hyperledger/config/

usage() {
    echo "./generate-channel-tx.sh ORG_NAME"
    echo "     Creates the airline-channel.tx for the channel airlinechannel"
}


if [ -z $1 ];
then
    usage
    echo "Please provide the Org Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

ORG_NAME_UPPER1="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"


echo    "================ Writing $ORG_NAMEchannel ================"


configtxgen -profile ${ORG_NAME_UPPER1} -outputCreateChannelTx /etc/hyperledger/config/$ORG_NAME-channel.tx -channelID ${ORG_NAME}



echo    '======= Done. Launch by executing orderer ======'
