#!/bin/bash
# Registers the 3 admins
# acme-admin, budget-admin, orderer-admin

# Registers the admins
registerAdmins() {
    # 1. Set the CA Server Admin as FABRIC_CA_CLIENT_HOME
    source setclient.sh caserver admin

    # 2. Register ORG_NAME-admin
    echo "Registering: $ORG_NAME-admin"
    ATTRIBUTES='"hf.Registrar.Roles=orderer"'
    fabric-ca-client register --id.type client --id.name $ORG_NAME-admin --id.secret $PASSWORD --id.affiliation $ORG_NAME --id.attrs $ATTRIBUTES --csr.cn $ORG_NAME-admin --id.maxenrollments $MAX_ENROLLMENTS

}

# Setup MSP
setupMSP() {
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts

    echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
    
    mkdir -p /etc/hyperledger/client/orderer/admin/msp/tls

    CA_FILENAME=`ls -A /etc/hyperledger/client/orderer/admin/msp/tlsintermediatecerts`
    cp /etc/hyperledger/client/orderer/admin/msp/tlsintermediatecerts/$CA_FILENAME /etc/hyperledger/client/orderer/admin/msp/tls/ca.pem
    cp /etc/hyperledger/client/orderer/admin/msp/tlsintermediatecerts/$CA_FILENAME /etc/hyperledger/client/orderer/admin/msp/cacerts/$CA_FILENAME
    KEY_FILENAME=`ls -A /etc/hyperledger/client/orderer/admin/msp/keystore/`
    cp /etc/hyperledger/client/orderer/admin/msp/keystore/$KEY_FILENAME /etc/hyperledger/client/orderer/admin/msp/tls/key.pem
    cp /etc/hyperledger/client/orderer/admin/msp/signcerts/cert.pem /etc/hyperledger/client/orderer/admin/msp/tls/cert.pem
}

# Enroll admin
enrollAdmins() {
    
    # 1. Enroll ORG_NAME-admin
    echo "Enrolling: $ORG_NAME-admin"

    source setclient.sh $ORG_NAME admin
    checkCopyYAML
    fabric-ca-client enroll -u https://$ORG_NAME-admin:$PASSWORD@$CA_ADDRESS:7054 --tls.certfiles /etc/hyperledger/server/ca-cert.pem --enrollment.profile tls

    setupMSP

}

# If client YAML not found then copy the client YAML before enrolling
# YAML picked from setup/config/multi-org-ca/yaml.0/ORG-Name/*
checkCopyYAML() {
    SETUP_CONFIG_CLIENT_YAML="/etc/hyperledger/config"
    if [ -f "$FABRIC_CA_CLIENT_HOME/fabric-ca-client.yaml" ]
    then 
        echo "Using the existing Client Yaml for $ORG_NAME  admin"
    else
        echo "Copied the Client Yaml from $SETUP_CONFIG_CLIENT_YAML/$ORG_NAME "
        mkdir -p $FABRIC_CA_CLIENT_HOME
        cp  "$SETUP_CONFIG_CLIENT_YAML/caclient/fabric-ca-client-config.yaml" "$FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml"
    fi
}


usage() {
    echo    "Usage:     ./register-enroll-orderer-admin   ORG_NAME   CA_ADDRESS   MAX_ENROLLMENTS"
    echo    "           Uses the Organization Identity provided"
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


if [ -z $4 ]
then
    usage
    echo 'Please provide MAX_ENROLLMENTS!!!'
    exit 1
else 
    MAX_ENROLLMENTS=$4
fi


echo "========= Registering ==============="
registerAdmins
echo "========= Enrolling ==============="
enrollAdmins
echo "==================================="
