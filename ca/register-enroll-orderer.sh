#!/bin/sh
# Creates/Enrolls the Orderer's identity + Sets up MSP for orderer
# Script may executed multiple times 
# PS: Since Register (step 1) can happen only once - ignore register error if you run multiple times

# Function checks for the availability of the 
checkCopyYAML() {
    SETUP_CONFIG_CLIENT_YAML="/etc/hyperledger/config/caclient/fabric-ca-client-config.yaml"
    if [ -f "$FABRIC_CA_CLIENT_HOME/fabric-ca-client.yaml" ]
    then 
        echo "Using the existing Client Yaml for orderer"
    else
        echo "Copied the Client Yaml from $SETUP_CONFIG_CLIENT_YAML/orderer "
        mkdir -p $FABRIC_CA_CLIENT_HOME
        cp  "$SETUP_CONFIG_CLIENT_YAML" "$FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml"
    fi
}

# Function sets the FABRIC_CA_CLIENT_HOME
setFabricCaClientHome() {
    CA_CLIENT_FOLDER="/etc/hyperledger/client/orderer"
    export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
}

usage() {
    echo    "Usage:     ./register-enroll-orderer   ORDERER_NAME   CA_ADDRESS"
    echo    "           Uses the Organization Identity provided"
}


# Org Name is needed
if [ -z $1 ]
then
    usage
    echo 'Please provide ORDERER_NAME!!!'
    exit 1
else 
    ORDERER_NAME=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Please provide CA_ADDRESS!!!'
    exit 1
else 
    CA_ADDRESS=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Please provide PASSWORD!!!'
    exit 1
else 
    PASSWORD=$3
fi

# Identity of the orderer will be created by the admin from the orderer org
IDENTITY="admin"
# A function similar to the setclient.sh script - sets the FABRIC_CA_CLIENT_HOME
setFabricCaClientHome
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Step-1  Register the orderer identity
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
fabric-ca-client register --id.type orderer --id.name $ORDERER_NAME --id.secret $PASSWORD --id.affiliation orderer --csr.cn $ORDERER_NAME --id.maxenrollments 0
echo "======Completed: Step 1 : Registered orderer (can be done only once)===="

# Step-2 Copy the client config yaml file

# Set the FABRIC_CA_CLIENT_HOME for orderer
IDENTITY=$ORDERER_NAME
setFabricCaClientHome

checkCopyYAML
echo "======Completed: Step 2 : Copy Check Orderer Client YAML=========="

# Step-3 Orderer identity is enrolled
# Admin will  enroll the orderer identity. The MSP will be written in the 
# FABRIC_CA_CLIENT_HOME
fabric-ca-client enroll -u https://$ORDERER_NAME:$PASSWORD@$CA_ADDRESS:7054 --tls.certfiles /etc/hyperledger/server/ca-cert.pem --enrollment.profile tls
echo "======Completed: Step 3 : Enrolled orderer ========"

# Step-4 Copy the admincerts to the appropriate folder
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "======Completed: Step 4 : MSP setup for the orderer========"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/tls

CA_FILENAME=`ls -A /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tlsintermediatecerts`
cp /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tlsintermediatecerts/$CA_FILENAME /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/ca.pem
cp /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tlsintermediatecerts/$CA_FILENAME /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/cacerts/$CA_FILENAME
KEY_FILENAME=`ls -A /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/keystore/`
cp /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/keystore/$KEY_FILENAME /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/key.pem
cp /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/signcerts/cert.pem /etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/cert.pem

cd /etc/hyperledger/client
tar -cf ./orderer-$ORDERER_NAME.tar orderer/admin orderer/$ORDERER_NAME
echo "======Completed: Step 5 : Tar files for the orderer========"


