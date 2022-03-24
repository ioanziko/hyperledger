#!/bin/sh
killall peer 2> /dev/null

# Remove all generated files
rm /etc/hyperledger/config/*.block 2> /dev/null
rm /etc/hyperledger/config/*.json 2> /dev/null
rm /etc/hyperledger/config/*.pb 2> /dev/null

# Remove the subfolders under acme | peer
function cleanOrgFolders {
    rm -rf /etc/hyperledger/config/$ORG_NAME/ 2> /dev/null

    CORE_PEER_FILESYSTEM_PATH="/var/ledgers/$ORG_NAME"
    rm -rf $CORE_PEER_FILESYSTEM_PATH
}

# Clean up the acme folder
ORG_NAME=duth
cleanOrgFolders


# Clean up the budget folder
ORG_NAME=athina
cleanOrgFolders

# Clean up the config folder
rm  config/* 2> /dev/null

rm *.block 2> /dev/null
rm *.tx 2> /dev/null

echo "===== Done."
