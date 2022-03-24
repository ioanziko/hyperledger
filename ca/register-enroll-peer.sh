#!/bin/sh
# Creates/Enrolls the Peer's identity + Sets up MSP for peer
# Script needs to be executed for the peers setup
# PS: Since Register (step 1) can happen only once - ignore register error if you run script multiple times

usage() {
    echo "./register-enroll-peer.sh ORG_NAME  PEER_NAME CA_ADDRESS"
    echo "     Sets up the Peer identity and MSP"
    echo "     Script will fail if CA Server is not running!!!"
}

if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME!!!"
    exit 0
else
    PEER_NAME=$2
fi

if [ -z $3 ];
then
    usage
    echo  "Please specify CA_ADDRESS!!!"
    exit 0
else
    CA_ADDRESS=$3
fi

if [ -z $4 ]
then
    usage
    echo 'Please provide PASSWORD!!!'
    exit 1
else 
    PASSWORD=$4
fi

# Function checks for the availability of the 
checkCopyYAML() {
    SETUP_CONFIG_CLIENT_YAML="/etc/hyperledger/config/caclient/fabric-ca-client-config.yaml"
 	mkdir -p "/etc/hyperledger/client/$ORG_NAME/$PEER_NAME"
	cp  "$SETUP_CONFIG_CLIENT_YAML" "/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/fabric-ca-client-config.yaml"
    # Placeholder
    # This is not implemented - but is placed here to show how you can manage the CSR for the peers like other identities
}

# Function sets the FABRIC_CA_CLIENT_HOME
setFabricCaClientHome() {
    CA_CLIENT_FOLDER="/etc/hyperledger/client/$ORG_NAME"
    export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
}

# Identity of the peer will be created by the admin from the organization
IDENTITY="admin"

# A function similar to the setclient.sh script - sets the FABRIC_CA_CLIENT_HOME
setFabricCaClientHome
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME

# Step-1  Register the identity
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
fabric-ca-client register --id.type peer --id.name $PEER_NAME --id.secret $PASSWORD --id.affiliation $ORG_NAME --csr.cn $PEER_NAME --id.maxenrollments 0
echo "======Completed: Step 1 : Registered peer (can be done only once)===="

# Set the FABRIC_CA_CLIENT_HOME for peer
IDENTITY=$PEER_NAME
setFabricCaClientHome

# Step-2 Copies the YAML file for CSR setup
checkCopyYAML

# Step-3 Peer identity is enrolled
# Admin will  enroll the peer identity. The MSP will be written in the 
# FABRIC_CA_CLIENT_HOME
fabric-ca-client enroll -u https://$PEER_NAME:$PASSWORD@$CA_ADDRESS:7054 --tls.certfiles /etc/hyperledger/server/ca-cert.pem --enrollment.profile tls
echo "======Completed: Step 3 : Enrolled $PEER_NAME ========"

# Step-4 Copy the admincerts to the appropriate folder
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts

echo "======Completed: Step 4 : MSP setup for the peer========"

mkdir -p $FABRIC_CA_CLIENT_HOME/msp/tls

CA_FILENAME=`ls -A /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tlsintermediatecerts`
cp /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tlsintermediatecerts/$CA_FILENAME /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem
cp /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tlsintermediatecerts/$CA_FILENAME /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/cacerts/$CA_FILENAME
KEY_FILENAME=`ls -A /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/keystore/`
cp /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/keystore/$KEY_FILENAME /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem
cp /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/signcerts/cert.pem /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem


cd /etc/hyperledger/client
tar -cf ./$ORG_NAME-$PEER_NAME.tar $ORG_NAME/admin $ORG_NAME/$PEER_NAME
echo "======Completed: Step 5 : Tar files for the peer========"


