#!/bin/bash
# Fetch a specified block, writing it to a file.
usage() {
    echo "Usage:     ./fetch-channel.sh  PEER_NAME  BLOCK<newest|oldest|config|(number)>  CHANNEL_NAME  ORDERER_ADDRESS  ORDERER_PORT"
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
    echo 'Please provide BLOCK NUMBER!!!'
    exit 1
else 
    BLOCK=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Please provide CHANNEL NAME!!!'
    exit 1
else 
    CHANNEL_NAME=$3
fi

if [ -z $4 ]
then
    usage
    echo 'Please provide ORDERER ADDRESS!!!'
    exit 1
else 
    ORDERER_ADDRESS=$4
fi

if [ -z $5 ]
then
    usage
    echo 'Please provide ORDERER PORT!!!'
    exit 1
else 
    ORDERER_PORT=$5
fi


DIR=`dirname "$(realpath $0)"`
# Set the environment vars
source $DIR/peer_data.sh $SELECT_PEER

CHANNEL_BLOCK=./${CHANNEL_NAME}_${PEER_NAME}_$BLOCK.block

source $DIR/set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD"

# Fetch channel configuration
peer channel fetch $BLOCK $CHANNEL_BLOCK -o $ORDERER_ADDRESS:$ORDERER_PORT -c ${CHANNEL_NAME} --tls --cafile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/cert.pem

echo "File created: `pwd`/${CHANNEL_NAME}_${PEER_NAME}_$BLOCK.block";

