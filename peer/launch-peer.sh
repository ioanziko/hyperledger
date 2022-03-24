#!/bin/bash
usage() {
    echo ". launch-peer.sh   ORG_NAME   PEER_NAME  [PORT_NUMBER_BASE default=7050] "
    echo "                   Sets the environment variables for the peer & then launches it"
}

# Org name Must be provided
if [ -z $1 ];
then
    usage
    echo "Please provide the ORG Name!!!"
    exit 0
else
    ORG_NAME=$1
fi

# Peer name Must be provided
if [ -z $2 ];
then
    usage
    echo  "Please specify PEER_NAME!!!"
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
    BOOTSTRAP=$6
    
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

# Set up the environment variables
source set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" $USERNAME $PASSWORD
./show-env.sh
export CORE_PEER_FILESYSTEMPATH="/var/ledgers/$ORG_NAME/$PEER_NAME/ledger" 

# Create the ledger folders
# To retain the environment vars we need to use -E flag with sudo
mkdir -p $CORE_PEER_FILESYSTEMPATH

# Create the folder for the logs
mkdir -p $PEER_LOGS

# Start the peer
peer node start 2> $PEER_LOGS/peer.log &

echo "====>PLEASE Check Peer Log under  $PWD/$ORG_NAME/$PEER_NAME"
echo "====>Make sure there are no errors!!!"