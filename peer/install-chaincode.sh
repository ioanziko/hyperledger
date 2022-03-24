#!/bin/bash
# ./install-chaincode.sh peer1 ledger1.drosatos.eu:7050 gocc8 "1.0" "1.0" duthchannel
usage() {
    echo "Usage:     ./install-chaincode.sh  PEER_NAME  ORDERER_ADDRESS<:port>  CC_NAME  CC_VERSION  INTERNAL_DEV_VERSION  CC_CHANNEL_ID"
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
    echo 'Please provide ORDERER ADDRESS:ORDERER PORT!!!'
    exit 1
else 
    ORDERER_ADDRESS=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Please provide CC NAME!!!'
    exit 1
else 
    CC_NAME=$3
fi

if [ -z $4 ]
then
    usage
    echo 'Please provide CC VERSION!!!'
    exit 1
else 
    CC_VERSION=$4
fi

if [ -z $5 ]
then
    usage
    echo 'Please provide INTERNAL DEV VERSION!!!'
    exit 1
else 
    INTERNAL_DEV_VERSION=$5
fi

if [ -z $6 ]
then
    usage
    echo 'Please provide CC CHANNEL ID!!!'
    exit 1
else 
    CC_CHANNEL_ID=$6
fi

export FABRIC_LOGGING_SPEC=ERROR

DIR=`dirname "$(realpath $0)"`
# Set the environment vars
source $DIR/peer_data.sh $SELECT_PEER

source $DIR/set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD" admin

CC2_PACKAGE_FOLDER="/var/ledgers/packages/$CC_CHANNEL_ID"
PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"

CC2_SEQUENCE=1
CC2_INIT_REQUIRED="--init-required"

# Extracts the package ID for the installed chaincode
LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"
function cc_get_package_id {  
    OUTPUT=$(peer lifecycle chaincode queryinstalled -O json --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem)
    PACKAGE_ID=$(echo $OUTPUT | jq -r ".installed_chaincodes[]|select(.label==\"$LABEL\")|.package_id")
}

peer lifecycle chaincode install $CC2_PACKAGE_FOLDER/$PACKAGE_NAME --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem


cc_get_package_id

echo "====> Approving the chaincode"
peer lifecycle chaincode approveformyorg --channelID $CC_CHANNEL_ID  --name $CC_NAME \
            --version $CC_VERSION --package-id $PACKAGE_ID --sequence $CC2_SEQUENCE \
            $CC2_INIT_REQUIRED    -o $ORDERER_ADDRESS --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem  --waitForEvent  
            