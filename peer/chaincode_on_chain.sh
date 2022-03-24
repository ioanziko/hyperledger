#!/bin/bash

# ./chaincode_on_chain.sh peer1 duthathenachannel test_pack "1.0" "1.0" "java" "/home/fabric/HLF2-Project-Repo-V2.1-1.1/fabric-samples/chaincode/fabcar/java/src/" "16-12-2021" "Chaincode description"
# ./chaincode_on_chain.sh peer3 duthathenachannel gocc "1.0" "1.0" "golang" "/home/fabric/HLF2-Project-Repo-V2.1-1.1/fabric-samples/chaincode/fabcar/go/" "16-12-2021" "Chaincode description"
usage() {
    echo "Usage:     ./chaincode_on_chain.sh  PEER_NAME  CHANNEL  PACKAGE_NAME  VERSION  INTERNAL_DEV_VERSION  LANGUAGE  PATH  TIMESTAMP  DESCRIPTION"
    echo "           Specified Peer MUST be up for the command to be successful"
}


if [ -z "$1" ]
then
    usage
    echo 'Please provide PEER_NAME!!!'
    exit 1
else 
    SELECT_PEER="$1"
fi

if [ -z "$2" ]
then
    usage
    echo 'Please provide CHANNEL!!!'
    exit 1
else 
    channel="$2"
fi

if [ -z "$3" ]
then
    usage
    echo 'Please provide PACKAGE_NAME!!!'
    exit 1
else 
    package_name="$3"
fi

if [ -z "$4" ]
then
    usage
    echo 'Please provide VERSION!!!'
    exit 1
else 
    version="$4"
fi

if [ -z "$5" ]
then
    usage
    echo 'Please provide INTERNAL_DEV_VERSION!!!'
    exit 1
else 
    dev_version="$5"
fi

if [ -z "$6" ]
then
    usage
    echo 'Please provide LANGUAGE!!!'
    exit 1
else 
    lang="$6"
fi

if [ -z "$7" ]
then
    usage
    echo 'Please provide PATH!!!'
    exit 1
else 
    path="$7"
fi

if [ -z "$8" ]
then
    usage
    echo 'Please provide TIMESTAMP!!!'
    exit 1
else 
    time="$8"
fi

if [ -z "$9" ]
then
    usage
    echo 'Please provide DESCRIPTION!!!'
    exit 1
else 
    descr="$9"
fi


DIR=`dirname "$(realpath $0)"`

source $DIR/peer_data.sh $SELECT_PEER

owner="$ORG_NAME.$PEER_NAME"


temp=$(pwd)

base_name=$(basename $path)

id=$package_name-$version-$dev_version


cp -frp $path -T $temp/$id


docker_ip=$(docker ps -aqf "name=$PEER_NAME-ccoc")


sleep 1s

docker cp $temp/$id $docker_ip:/usr/local/source


sleep 1s

rm -r $temp/$id

$DIR/invoke-chaincode.sh $PEER_NAME ccoc $channel '{"Args":["createIdent","'${id}'","'${lang}'","'${time}'","'"$descr"'","'${owner}'"]}'


sleep 2s

$DIR/query-chaincode.sh $PEER_NAME ccoc $channel '{"Args":["queryAllIdent"]}'







