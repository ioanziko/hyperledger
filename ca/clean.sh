# Cleans the setup
killall fabric-ca-server 2> /dev/null

rm /etc/hyperledger/config/*.tx 2> /dev/null

rm /etc/hyperledger/config/*.block 2> /dev/null

rm -rf /etc/hyperledger/server/* 2> /dev/null

rm -rf /etc/hyperledger/client/* 2> /dev/null

rm -rf /etc/hyperledger/rootserver/* 2> /dev/null

rm -rf /etc/hyperledger/rootclient/* 2> /dev/null

echo "Removed all files under the ./client & ./server folder !!"

