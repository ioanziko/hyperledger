#!/bin/sh
# Registers the 3 admins
# acme-admin, budget-admin, orderer-admin

# Registers the admins
registerAdmins() {
    # 1. Set the CA Server Admin as FABRIC_CA_CLIENT_HOME
    export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/rootclient/caserver/admin
    
    # 2. Register ica-admin
    echo "Registering: ica-admin"
    ATTRIBUTES='"hf.Registrar.Roles=user,admin","hf.Revoker=true","hf.IntermediateCA=true"'
    fabric-ca-client register --id.name ica-admin --id.secret $PASSWORD --id.attrs $ATTRIBUTES

}

# Setup MSP
setupMSP() {
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts

    echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
    
    mkdir -p /etc/hyperledger/rootclient/ica/admin/msp/tls
    
    CA_FILENAME=`ls -A /etc/hyperledger/rootclient/ica/admin/msp/tlscacerts`
    cp /etc/hyperledger/rootclient/ica/admin/msp/tlscacerts/$CA_FILENAME /etc/hyperledger/rootclient/ica/admin/msp/tls/ca.pem
    cp /etc/hyperledger/rootclient/ica/admin/msp/tlscacerts/$CA_FILENAME /etc/hyperledger/rootclient/ica/admin/msp/cacerts/$CA_FILENAME
    KEY_FILENAME=`ls -A /etc/hyperledger/rootclient/ica/admin/msp/keystore/`
    cp /etc/hyperledger/rootclient/ica/admin/msp/keystore/$KEY_FILENAME /etc/hyperledger/rootclient/ica/admin/msp/tls/key.pem
    cp /etc/hyperledger/rootclient/ica/admin/msp/signcerts/cert.pem /etc/hyperledger/rootclient/ica/admin/msp/tls/cert.pem    
}

# Enroll admin
enrollAdmins() {
    
    # 1. Enroll ica-admin
    echo "Enrolling: ica-admin"

    export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/rootclient/ica/admin    
    checkCopyYAML
    fabric-ca-client enroll -u https://ica-admin:$PASSWORD@$CA_ADDRESS:7056 --tls.certfiles /etc/hyperledger/rootserver/ca-cert.pem --enrollment.profile tls

    setupMSP

}

# If client YAML not found then copy the client YAML before enrolling
# YAML picked from setup/config/multi-org-ca/yaml.0/ORG-Name/*
checkCopyYAML() {
    SETUP_CONFIG_CLIENT_YAML="/etc/hyperledger/config"
    if [ -f "$FABRIC_CA_CLIENT_HOME/fabric-ca-client.yaml" ]
    then 
        echo "Using the existing Client Yaml for ica admin"
    else
        echo "Copied the Client Yaml from $SETUP_CONFIG_CLIENT_YAML/ica "
        mkdir -p $FABRIC_CA_CLIENT_HOME
        cp  "$SETUP_CONFIG_CLIENT_YAML/ica/fabric-ca-client-config.yaml" "$FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml"
    fi
}


usage() {
    echo    "Usage:     ./register-enroll-admin   CA_ADDRESS"
    echo    "           Uses the Organization Identity provided"
}

if [ -z $1 ]
then
    usage
    echo 'Please provide CA_ADDRESS!!!'
    exit 1
else 
    CA_ADDRESS=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Please provide PASSWORD!!!'
    exit 1
else 
    PASSWORD=$2
fi

echo "========= Registering ==============="
registerAdmins
echo "========= Enrolling ==============="
enrollAdmins
echo "==================================="
