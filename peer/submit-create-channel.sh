#!/bin/bash
# This script simply submits the channel create transaction transaction
usage() {
    echo    "Usage:     ./submit-create-channel   ORG_NAME  IDENTITY   ORDERER_ADDRESS   ORDERER_PORT   CHANNEL_NAME"
    echo    "           Uses the Organization Identity provided to submit transaction"
    echo    "           Script will fail if the Orderer is not up !!!"
}

# Org Name is needed
if [ -z $1 ]
then
    usage
    echo 'Please provide ORG_NAME!!!'
    exit 1
else 
    ORG_NAME=$1
fi

# Identity check
if [ -z $2 ]
then
    usage
    echo 'Please provide IDENTITY!!!'
    exit 1
else 
    IDENTITY=$2
fi

# Orderer address
if [ -z $3 ]
then
    usage
    echo 'Please provide ORDERER_ADDRESS!!!'
    exit 1
else 
    ORDERER_ADDRESS=$3
fi

# Orderer address
if [ -z $4 ]
then
    usage
    echo 'Please provide ORDERER_PORT!!!'
    exit 1
else 
    ORDERER_PORT=$4
fi

# Channel id
if [ -z $5 ]
then
    usage
    echo 'Please provide CHANNEL_NAME!!!'
    exit 1
else 
    CHANNEL_NAME=$5
fi

# Channel transaction file location
# The transaction should have been signed by one or more admins based on policy
CHANNEL_TX_FILE="/etc/hyperledger/config/$CHANNEL_NAME-channel.tx"

# Sets the environment variables for the given identity
source set-identity.sh  


# Submit the channel create transation
peer channel create -o $ORDERER_ADDRESS:$ORDERER_PORT -c ${CHANNEL_NAME} -f $CHANNEL_TX_FILE --outputBlock /etc/hyperledger/config/${CHANNEL_NAME}.block --tls --cafile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/cert.pem

echo "====> Done. Check Orderer logs for any errors !!!"

















