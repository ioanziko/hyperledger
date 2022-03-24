#!/bin/bash
# Joins the peer to a channel

usage() {
    echo "Usage:     ./join-channel.sh  ORG_NAME  PEER_NAME  [PORT_NUMBER_BASE default=7050] [ORDERER_ADDRESS default=localhost:7050]"
    echo "           Specified Peer MUST be up for the command to be successful"
}

if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Please provide PEER_NAME!!!'
    exit 1
else 
    PEER_NAME=$2
fi


if [ -z $3 ]
then
    usage
    echo 'Please provide PORT_NUMBER_BASE!!!'
    exit 1
else 
    PORT_NUMBER_BASE=$3
fi

if [ -z $4 ]
then
    usage
    echo 'Please provide PEER_ADDRESS!!!'
    exit 1
else 
    PEER_ADDRESS=$4
fi

if [ -z $5 ]
then
    usage
    echo  "Please specify STATEDATABASE!!!"
    exit 0
else
    STATEDATABASE=$5
    
fi

if [ -z "$6" ]
then
    usage
    echo  "Please specify BOOTSTRAP!!!"
    exit 0
else
    BOOTSTRAP=$6
    
fi

if [ -z $7 ]
then
    usage
    echo 'Please provide ORDERER_ADDRESS!!!'
    exit 1
else 
    ORDERER_ADDRESS=$7
fi

if [ -z $8 ]
then
    usage
    echo 'Please provide ORDERER_PORT!!!'
    exit 1
else 
    ORDERER_PORT=$8
fi

if [ -z $9 ]
then
    usage
    echo 'Please provide CHANNEL_NAME!!!'
    exit 1
else 
    CHANNEL_NAME=$9
fi

shift
shift

if [ -z $8 ]
then
    echo "USERNAME blank"
    USERNAME=""
else
    USERNAME=$8
    
fi

if [ -z $9 ]
then
    echo "PASSWORD blank"
    PASSWORD=""
else
    PASSWORD=$9
    
fi

CHANNEL_BLOCK=/etc/hyperledger/config/${CHANNEL_NAME}_$PEER_NAME.block

# Set the environment vars
source set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" $USERNAME $PASSWORD

./show-env.sh

# Only admin is allowed to execute join command
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/admin/msp

# Fetch airline channel configuration
# peer channel fetch config $CHANNEL_BLOCK -o $ORDERER_ADDRESS -c airlinechannel
peer channel fetch 0 $CHANNEL_BLOCK -o $ORDERER_ADDRESS:$ORDERER_PORT -c ${CHANNEL_NAME} --tls --cafile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/cert.pem
#peer channel fetch 0 $AIRLINE_CHANNEL_BLOCK -o $ORDERER_ADDRESS:7050 -c ${CHANNEL_NAME}
# Give some time
sleep 2s

# Join the channel
peer channel join -o $ORDERER_ADDRESS:$ORDERER_PORT -b $CHANNEL_BLOCK --tls --cafile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/cert.pem
#peer channel join -o $ORDERER_ADDRESS:7050 -b $CHANNEL_BLOCK
# Execute the anchor peer update
