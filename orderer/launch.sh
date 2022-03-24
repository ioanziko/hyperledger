usage() {
    echo    "Usage:     ./launch   ORDERER_NAME  PORT_NUMBER"
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
    echo 'Please provide PORT_NUMBER!!!'
    exit 1
else 
    PORT_NUMBER=$2
fi

VAR=$((PORT_NUMBER-1))

export FABRIC_CFG_PATH=/etc/hyperledger/config/

export ORDERER_FILELEDGER_LOCATION="/var/ledgers/orderer/$ORDERER_NAME/ledger" 

export ORDERER_GENERAL_TLS_CERTIFICATE="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/cert.pem"
export ORDERER_GENERAL_TLS_CLIENTAUTHREQUIRED=true
export ORDERER_GENERAL_TLS_CLIENTROOTCAS=["/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/ca.pem"]
export ORDERER_GENERAL_TLS_ENABLED=true
export ORDERER_GENERAL_TLS_PRIVATEKEY="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/key.pem"
export ORDERER_GENERAL_TLS_ROOTCAS="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/ca.pem"

export ORDERER_GENERAL_LOCALMSPDIR="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp"

export ORDERER_GENERAL_LISTENPORT=$PORT_NUMBER

export ORDERER_GENERAL_LOCALMSPID="OrdererMSP"

export ORDERER_OPERATIONS_TLS_CERTIFICATE="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/cert.pem"
export ORDERER_OPERATIONS_TLS_CLIENTAUTHREQUIRED=true
export ORDERER_OPERATIONS_TLS_CLIENTROOTCAS=["/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/ca.pem"]
export ORDERER_OPERATIONS_TLS_ENABLED=true
export ORDERER_OPERATIONS_TLS_PRIVATEKEY="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/key.pem"
export ORDERER_OPERATIONS_TLS_ROOTCAS="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/ca.pem"


export ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/cert.pem"
export ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY="/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/key.pem"
export ORDERER_GENERAL_CLUSTER_ROOTCAS=["/etc/hyperledger/client/orderer/$ORDERER_NAME/msp/tls/ca.pem"]

export ORDERER_CONSENSUS_WALDIR="/var/ledgers/orderer/$ORDERER_NAME/etcdraft/wal"
export ORDERER_CONSENSUS_SNAPDIR="/var/ledgers/orderer/$ORDERER_NAME/etcdraft/snapshot"

export ORDERER_OPERATIONS_LISTENADDRESS="0.0.0.0:$VAR"



#export FABRIC_LOGGING_SPEC=DEBUG

mkdir -p /etc/hyperledger/config/orderer/$ORDERER_NAME

LOG_FILE=/etc/hyperledger/config/orderer/$ORDERER_NAME/orderer.log

orderer 2> $LOG_FILE &

ps -eal | grep orderer

echo "===> Done.  Please check logs under   $LOG_FILE"
