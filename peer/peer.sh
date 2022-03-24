#!/bin/bash
# Fetch a specified block, writing it to a file.
# ROLLBACK: stop, pause channel, rollback channel, start
usage() {
    echo "Usage:     ./peer.sh  PEER_NAME  COMMAND<pause,resume,reset,rollback,start,stop,unjoin>  (CHANNEL_NAME)  (BLOCK_NUMBER)"
}

if [ -z $1 ]
then
    usage
    echo 'Please provide PEER NAME!!!'
    exit 1
else 
    SELECT_PEER=$1
fi

if [ -z $2 ]
then
    usage
    echo 'Please provide COMMAND!!!'
    exit 1
else 
    COMMAND=$(echo $2 | tr '[:upper:]' '[:lower:]')
fi

CHANNEL_NAME=""
BLOCK_NUMBER=""

if [ "$COMMAND" = "rollback" ]; then
  if [ -z $3 ]
  then
      usage
      echo 'Please provide CHANNEL NAME!!!'
      exit 1
  else 
      CHANNEL_NAME="-c $3"
  fi

  if [ -z $4 ]
  then
      usage
      echo 'Please provide BLOCK NUMBER!!!'
      exit 1
  else 
      BLOCK_NUMBER="-b $4"
  fi
fi

if [[ "$COMMAND" != "start" && "$COMMAND" != "reset" && "$COMMAND" != "stop" ]]; then
  if [ -z $3 ]
  then
      usage
      echo 'Please provide CHANNEL NAME!!!'
      exit 1
  else 
      CHANNEL_NAME="-c $3"
  fi

fi

DIR=`dirname "$(realpath $0)"`
# Set the environment vars
source $DIR/peer_data.sh $SELECT_PEER

source $DIR/set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD"

if [ "$COMMAND" = "stop" ]; then

  kill $(lsof -t -i:$((PORT_NUMBER_BASE+1)) -sTCP:LISTEN -P -n)

  
else
  if [ "$COMMAND" = "start" ]; then
    $DIR/launch-peer.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD"
  else
    peer node $COMMAND $CHANNEL_NAME $BLOCK_NUMBER
  fi
  

fi
