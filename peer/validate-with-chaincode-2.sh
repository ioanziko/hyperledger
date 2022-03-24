#!/bin/bash
#
# Validates the working of : Acme Peer1 & Acme Peer2
#

# Installs | commits on Acme peer1
source ./validate-with-chaincode-1.sh

# Install the chaincode on Acme peer2
PEER_NAME="peer2"
PEER_BASE_PORT=8050
source  set-env.sh duth peer2 8050 ledger1.drosatos.eu goleveldb 'ledger1.drosatos.eu:7051 ledger1.drosatos.eu:8051' "" "" admin


echo "====> 9. Installing $PACKAGE_NAME on Acme Peer2"
peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem

echo "====> 10. Querying for value of A in Acme peer2"

peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["GetAllAssets"]}' --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem

echo "====> Value of A should be SAME on Acme peer1 & peer2"

# GET COMMITTED PACKAGE NAME
# peer lifecycle chaincode querycommitted -C duthchannel --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem
# GET COMMITTED PACKAGE NAME JSON
# peer lifecycle chaincode querycommitted -C duthchannel -O json --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem

# GET COMMITTED PACKAGE ID
# peer lifecycle chaincode queryapproved -C duthchannel -n gocc8 --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem
# GET COMMITTED PACKAGE ID JSON
# peer lifecycle chaincode queryapproved -C duthchannel -n gocc8 -O json --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem


# peer lifecycle chaincode getinstalledpackage --tls --cafile /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --certfile /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem --tlsRootCertFiles /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --package-id gocc8.1.0-1.0:d5b470fa08adecea1f7df6d1acdd3196e48032e51de7b43ac8d0edbb5901155d --peerAddresses ledger1.drosatos.eu:7051

# DISCOVER PEERS IN CHANNEL
# discover --peerTLSCA /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --tlsCert /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem --tlsKey /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --userKey /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --userCert /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem --MSP DuthMSP peers --channel duthchannel --server ledger1.drosatos.eu:8051


# DISCOVER config 
# discover --peerTLSCA /etc/hyperledger/client/duth/peer2/msp/tls/ca.pem --tlsCert /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem --tlsKey /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --userKey /etc/hyperledger/client/duth/peer2/msp/tls/key.pem --userCert /etc/hyperledger/client/duth/peer2/msp/tls/cert.pem --MSP DuthMSP config --channel duthchannel --server ledger1.drosatos.eu:8051
