
CONT_ID=`docker ps -aqf "name=couch"`

docker stop $CONT_ID

sleep 1s

docker rm $CONT_ID

sleep 1s

docker ps