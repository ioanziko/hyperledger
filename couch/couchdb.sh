function usage {
    echo "Usage:     ./couchdb.sh  USERNAME  PASSWORD"
}

if [ -z $1 ]
then
    usage
    echo 'Please provide USERNAME!!!'
    exit 1
else 
    USERNAME=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Please provide PASSWORD!!!'
    exit 1
else 
    PASSWORD=$2
fi

#!/bin/bash
# Launches couchdb docker container
# If the container is already up then you may see an error which is OK
# To manually kill the container you may use:   docker rm -f couchdb

# 1. Start the container

# v1.3-3
# Pull version 2.2.0 of CouchDB - latest version 2.3.0 is not compatible with 
#docker run --name couchdb -e COUCHDB_USER=user -e COUCHDB_PASSWORD=password --name=couchdb -p 127.0.0.1:5984:5984 -d couchdb:latest
docker run -e COUCHDB_USER=$USERNAME -e COUCHDB_PASSWORD=$PASSWORD --name=couchdb -p 127.0.0.1:5984:5984 -d couchdb:latest

sleep 1s

docker ps
# 2. Verify that the container is up
# Updated the time from 5s to 8s
sleep 8s

curl 127.0.0.1:5984

echo "Do you see a welcome message?"
echo "If you don't see the message - try the following command in a few seconds: curl 127.0.0.1:5984"
