#!/bin/bash
# ./query-chaincode.sh peer1 gocc8 duthchannel '{"Args":["GetAllAssets"]}'
usage() {
    echo "Usage:     ./query-chaincode.sh  PEER_NAME  CC_NAME  CC_CHANNEL_ID  CC_CONSTRUCTOR"
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
    echo 'Please provide CC NAME!!!'
    exit 1
else 
    CC_NAME=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Please provide CC CHANNEL ID!!!'
    exit 1
else 
    CC_CHANNEL_ID=$3
fi

if [ -z "$4" ]
then
    usage
    echo 'Please provide CC CONSTRUCTOR!!!'
    exit 1
else 
    CC_CONSTRUCTOR="$4"
fi

export FABRIC_LOGGING_SPEC=ERROR

DIR=`dirname "$(realpath $0)"`
# Set the environment vars
source $DIR/peer_data.sh $SELECT_PEER

source $DIR/set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD"


peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c "$CC_CONSTRUCTOR" --tls --cafile /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem

