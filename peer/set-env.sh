#!/bin/bash

# Sets the env & identity to specified   Org   User

# Extract name of the ORG from the folder name
#ORG_NAME="${PWD##*/}"
#ORG_PWD=`pwd`

usage() {
    echo ". set-env.sh   ORG_NAME   PEER_NAME  [PORT_NUMBER_BASE default=7050]  [Identity]"
    echo "               Sets the environment variables for the peer that need to be administered"
    echo "               If [Identity] is specified then the MSP is set to the specified Identity instead of PEER MSP"
}

# Change this to appropriate level
#export CORE_LOGGING_LEVEL=info  #debug  #info #warning
export FABRIC_LOGGING_SPEC=INFO


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
    echo  "Please specify PEER_NAME or Peer name!!!"
    exit 0
else
    PEER_NAME=$2
fi


if [ -z $3 ]
then
    usage
    echo  "Please specify PORT_NUMBER_BASE!!!"
    exit 0
else
    PORT_NUMBER_BASE=$3
fi

if [ -z $4 ]
then
    usage
    echo  "Please specify PEER_ADDRESS!!!"
    exit 0
else
    PEER_ADDRESS=$4
fi

export CORE_PEER_ID=$PEER_NAME

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
    BOOTSTRAP="$6"
    
fi

if [ -z $7 ]
then
    USERNAME=""
else
    USERNAME=$7
    
fi

if [ -z $8 ]
then
    PASSWORD=""
else
    PASSWORD=$8
    
fi

if [ -z $9 ]
then
    IDENTITY=$PEER_NAME
else
    IDENTITY=$9
    
fi

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER="/etc/hyperledger/client"
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
export FABRIC_CFG_PATH="/etc/hyperledger/config/"

#export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$PEER_NAME/msp
# Capitalize the first letter of Org name e.g., acme => Acme  budget => Budget
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"

export GOPATH="/var/ledgers/gopath"

export NODECHAINCODE="/var/ledgers/nodechaincode"

export CORE_PEER_FILESYSTEMPATH=/var/ledgers/$ORG_NAME/$PEER_NAME/ledger
export CORE_PEER_FILESYSTEM_PATH="/var/ledgers/$ORG_NAME/$PEER_NAME/ledger" 

# This is to avoid Port Number contention
VAR=$((PORT_NUMBER_BASE+1))
export CORE_PEER_LISTENADDRESS=0.0.0.0:$VAR
export CORE_PEER_ADDRESS=$PEER_ADDRESS:$VAR
export CORE_PEER_GOSSIP_ENDPOINT=$PEER_ADDRESS:$VAR
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=$PEER_ADDRESS:$VAR
VAR=$((PORT_NUMBER_BASE+2))
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:$VAR
VAR=$((PORT_NUMBER_BASE+3))
export CORE_PEER_EVENTS_ADDRESS=0.0.0.0:$VAR

# Prevent operations port contention
VAR=$((PORT_NUMBER_BASE+5))
export CORE_OPERATIONS_LISTENADDRESS="0.0.0.0:$VAR"

# All Peers will connect to this - peer 
export CORE_PEER_GOSSIP_BOOTSTRAP="$BOOTSTRAP"




export PEER_LOGS=/etc/hyperledger/config/$ORG_NAME/$PEER_NAME

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_CERT_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem"
export CORE_PEER_TLS_KEY_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem"
export CORE_PEER_TLS_ROOTCERT_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem"


export CORE_PEER_TLS_CLIENTAUTHREQUIRED=true

export CORE_PEER_TLS_CLIENTCERT_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem"
export CORE_PEER_TLS_CLIENTKEY_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem"
export CORE_PEER_TLS_CLIENTROOTCAS_FILES="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem"

VAR=$((PORT_NUMBER_BASE+7))
export CORE_LEDGER_STATE_STATEDATABASE=$STATEDATABASE
export CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=127.0.0.1:$VAR
export CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=$USERNAME
export CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=$PASSWORD


export CORE_OPERATIONS_TLS_ENABLED=true
export CORE_OPERATIONS_TLS_CERT_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem"
export CORE_OPERATIONS_TLS_KEY_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem"
export CORE_OPERATIONS_TLS_ROOTCERT_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem"

export CORE_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true

export CORE_OPERATIONS_TLS_CLIENTCERT_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem"
export CORE_OPERATIONS_TLS_CLIENTKEY_FILE="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem"
export CORE_OPERATIONS_TLS_CLIENTROOTCAS_FILES="/etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem"

#echo "====>Peer binary will use CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH"

# Simply checks if this script was executed directly on the terminal/shell
# it has the '.'
if [[ $0 = *"set-env.sh" ]]
then
    echo "Did you use the . before ./set-env.sh? If yes then we are good :)"
fi
