SELECT_PEER=$1
CC_NAME=gocc15
CC_CHANNEL_ID=$2
CC_CONSTRUCTOR=$3

export FABRIC_LOGGING_SPEC=FATAL

DIR=`dirname "$(realpath $0)"`
  
SELECTED_PEER=0
  if [ "$SELECT_PEER" = "peer1" ]; then
    SELECTED_PEER=1
    ORG_NAME=duth
    PEER_NAME=peer1
    PORT_NUMBER_BASE=7050
    PEER_ADDRESS=ledger1.drosatos.eu
    STATEDATABASE=goleveldb
    BOOTSTRAP='ledger1.drosatos.eu:7051 ledger1.drosatos.eu:8051'
    USERNAME=''
    PASSWORD=''
    IDENTITY=$PEER_NAME
  fi
  if [ "$SELECT_PEER" = "peer2" ]; then
    SELECTED_PEER=1
    ORG_NAME=duth
    PEER_NAME=peer2
    PORT_NUMBER_BASE=8050
    PEER_ADDRESS=ledger1.drosatos.eu
    STATEDATABASE=goleveldb
    BOOTSTRAP='ledger1.drosatos.eu:7051 ledger1.drosatos.eu:8051'
    USERNAME=''
    PASSWORD=''
    IDENTITY=$PEER_NAME
  fi
  if [ "$SELECT_PEER" = "peer3" ]; then
    SELECTED_PEER=1
    ORG_NAME=athena
    PEER_NAME=peer3
    PORT_NUMBER_BASE=9050
    PEER_ADDRESS=ledger1.drosatos.eu
    STATEDATABASE=goleveldb
    BOOTSTRAP='ledger1.drosatos.eu:9051'
    USERNAME=''
    PASSWORD=''
    IDENTITY=$PEER_NAME
  fi
  if [ "$SELECTED_PEER" -eq "0" ]; then
     echo "Peer not found!!!";
     exit;
  fi



CRYPTO_CONFIG_ROOT_FOLDER="/etc/hyperledger/client"
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
export FABRIC_CFG_PATH="/etc/hyperledger/config/"
export GOPATH="/var/ledgers/gopath"
export NODECHAINCODE="/var/ledgers/nodechaincode"
export CORE_PEER_FILESYSTEMPATH=/var/ledgers/$ORG_NAME/$PEER_NAME/ledger
export CORE_PEER_FILESYSTEM_PATH="/var/ledgers/$ORG_NAME/$PEER_NAME/ledger" 

VAR=$((PORT_NUMBER_BASE+1))
export CORE_PEER_LISTENADDRESS=0.0.0.0:$VAR
export CORE_PEER_ADDRESS=$PEER_ADDRESS:$VAR
export CORE_PEER_GOSSIP_ENDPOINT=$PEER_ADDRESS:$VAR
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=$PEER_ADDRESS:$VAR
VAR=$((PORT_NUMBER_BASE+2))
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:$VAR
VAR=$((PORT_NUMBER_BASE+3))
export CORE_PEER_EVENTS_ADDRESS=0.0.0.0:$VAR

VAR=$((PORT_NUMBER_BASE+43))
export CORE_OPERATIONS_LISTENADDRESS="0.0.0.0:$VAR"

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


export CORE_LEDGER_STATE_STATEDATABASE=$STATEDATABASE
export CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=127.0.0.1:5984
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


if [ "$CC_CHANNEL_ID" = "1" ]; then
peer channel list --tls --cafile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$IDENTITY/msp/tls/cert.pem
else
peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c $CC_CONSTRUCTOR --tls --cafile /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/$PEER_NAME/msp/tls/cert.pem
fi


