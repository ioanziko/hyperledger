killall orderer

rm /etc/hyperledger/config/*.tx 2> /dev/null
rm /etc/hyperledger/config/*.block 2> /dev/null



rm -rf /etc/hyperledger/config/orderer/  2> /dev/null


rm -rf /var/ledgers/orderer/ 2> /dev/null




echo "Removed all genesis, tx files"
