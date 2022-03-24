#!/bin/bash
# Fetch a specified block, writing it to a file.
usage() {
    echo "Usage:     ./info-channel.sh  PEER_NAME  CHANNEL_NAME  ORDERER_ADDRESS  ORDERER_PORT"
    echo "           Specified Peer MUST be up for the command to be successful"
}

if [ -z $1 ]
then
    usage
    echo 'Please provide PEER NAME!!!'
    exit 1
else 
    SELECT_PEER=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Please provide ORDERER ADDRESS!!!'
    exit 1
else 
    ORDERER_ADDRESS=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Please provide ORDERER PORT!!!'
    exit 1
else 
    ORDERER_PORT=$3
fi


DIR=`dirname "$(realpath $0)"`
# Set the environment vars
source $DIR/peer_data.sh $SELECT_PEER

source $DIR/set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD"

export FABRIC_LOGGING_SPEC=FATAL
# Fetch channel configuration
peer channel list -o $ORDERER_ADDRESS:$ORDERER_PORT --tls --cafile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/cert.pem
