#!/bin/bash
#Create package, install, approve and commit (meet the endorsement policy)
# ./commit-chaincode.sh peer1 ledger1.drosatos.eu:7050 "/home/fabric/HLF2-Project-Repo-V2.1-1.1/fabric-samples/chaincode/fabcar/javascript/" gocc8 "1.0" "1.0" node duthchannel '{"function":"initLedger","Args":[]}'

usage() {
    echo "Usage:     ./commit-chaincode.sh  PEER_NAME  ORDERER_ADDRESS<:port>  CC_PATH  CC_NAME  CC_VERSION  INTERNAL_DEV_VERSION  CC_LANGUAGE  CC_CHANNEL_ID  CC_CONSTRUCTOR"
    echo "           Specified Peer MUST be up for the command to be successful"
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
    echo 'Please provide ORDERER ADDRESS:ORDERER PORT!!!'
    exit 1
else 
    ORDERER_ADDRESS=$2
fi

if [ -z $3 ]
then
    usage
    echo 'Please provide CC PATH!!!'
    exit 1
else 
    CC_PATH=$3
fi
if [ -z $4 ]
then
    usage
    echo 'Please provide CC NAME!!!'
    exit 1
else 
    CC_NAME=$4
fi


if [ -z $5 ]
then
    usage
    echo 'Please provide CC VERSION!!!'
    exit 1
else 
    CC_VERSION=$5
fi

if [ -z $6 ]
then
    usage
    echo 'Please provide INTERNAL DEV VERSION!!!'
    exit 1
else 
    INTERNAL_DEV_VERSION=$6
fi

if [ -z $7 ]
then
    usage
    echo 'Please provide CC LANGUAGE!!!'
    exit 1
else 
    CC_LANGUAGE=$7
fi

if [ -z $8 ]
then
    usage
    echo 'Please provide CC CHANNEL ID!!!'
    exit 1
else 
    CC_CHANNEL_ID=$8
fi

if [ -z "$9" ]
then
    usage
    echo 'Please provide CC CONSTRUCTOR!!!'
    exit 1
else 
    CC_CONSTRUCTOR="$9"
fi

export FABRIC_LOGGING_SPEC=ERROR

DIR=`dirname "$(realpath $0)"`
# Set the environment vars
source $DIR/peer_data.sh $SELECT_PEER

source $DIR/set-env.sh $ORG_NAME  $PEER_NAME  $PORT_NUMBER_BASE  $PEER_ADDRESS  $STATEDATABASE "$BOOTSTRAP" "$USERNAME" "$PASSWORD" admin

CC2_PACKAGE_FOLDER="/var/ledgers/packages/$CC_CHANNEL_ID"
CC2_SEQUENCE=1
CC2_INIT_REQUIRED="--init-required"

mkdir -p $CC2_PACKAGE_FOLDER

# 2. Create the package
PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"

# Extracts the package ID for the installed chaincode
LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"
cc_get_package_id() {  
    OUTPUT=$(peer lifecycle chaincode queryinstalled -O json --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem)
    PACKAGE_ID=$(echo $OUTPUT | jq -r ".installed_chaincodes[]|select(.label==\"$LABEL\")|.package_id")
    #calculatepackageid
}


# This is to check if the chaincode is already committed
    

    # Check if package already exist
    if [ -f "$CC2_PACKAGE_FOLDER/$PACKAGE_NAME" ]; then
        echo "====> Step 1 Using the existing chaincode package:   $CC2_PACKAGE_FOLDER/$PACKAGE_NAME"
    else
        echo "====> Step 1 Creating the chaincode package $CC2_PACKAGE_FOLDER/$PACKAGE_NAME"
        peer lifecycle chaincode package $CC2_PACKAGE_FOLDER/$PACKAGE_NAME -p $CC_PATH \
                    --label="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION" -l $CC_LANGUAGE --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
    fi
  
  
    cc_get_package_id
    if [ -z "$PACKAGE_ID" ]
    then
    # 2. Install the chaincode
    echo "====> Step 2   Installing chaincode (may fail if CC/version already there)"
    peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
    sleep 1s
    # Set the package ID -  PACAKGE_ID will be set
    cc_get_package_id
    fi
    
    
    
    CHECK_IF_COMMITTED=$(peer lifecycle chaincode querycommitted -O json -C $CC_CHANNEL_ID -n $CC_NAME --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem)
    if [ $? == "0" ]; then
    
      CC2_SEQUENCE=1
      echo "Chaincode already Committed"
      echo "====> Step 3   Approving the chaincode"
      peer lifecycle chaincode approveformyorg --channelID $CC_CHANNEL_ID  --name $CC_NAME \
            --version $CC_VERSION --package-id $PACKAGE_ID --sequence $CC2_SEQUENCE \
            $CC2_INIT_REQUIRED    -o $ORDERER_ADDRESS --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem  --waitForEvent
            
      peer lifecycle chaincode querycommitted -C $CC_CHANNEL_ID -n $CC_NAME --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
              
    else
    
    
      # 3. Approve for my org
      echo "====> Step 3   Approving the chaincode"
      peer lifecycle chaincode approveformyorg --channelID $CC_CHANNEL_ID  --name $CC_NAME \
              --version $CC_VERSION --package-id $PACKAGE_ID --sequence $CC2_SEQUENCE \
              $CC2_INIT_REQUIRED    -o $ORDERER_ADDRESS --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem  --waitForEvent
  
      # This is to confirm the approval         
      peer lifecycle chaincode checkcommitreadiness -C $CC_CHANNEL_ID -n \
          $CC_NAME --sequence $CC2_SEQUENCE -v $CC_VERSION  $CC2_INIT_REQUIRED --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
  
      # 4. Commit the chaincode
      echo "====> Step 4   Committing the chaincode (may fail if endorsement policy is not met)"
      peer lifecycle chaincode commit -C $CC_CHANNEL_ID -n $CC_NAME -v $CC_VERSION \
              --sequence $CC2_SEQUENCE  $CC2_INIT_REQUIRED    --waitForEvent --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
      # this is to check commited chaincode
      peer lifecycle chaincode querycommitted -C $CC_CHANNEL_ID -n $CC_NAME --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
  
      # 5. Init the chaincode
      echo "====> Step 5   Initializing (may fail if endorsement policy is not met)"
  
  
      peer chaincode invoke  -C $CC_CHANNEL_ID -n $CC_NAME -c "$CC_CONSTRUCTOR" \
          --waitForEvent --isInit -o $ORDERER_ADDRESS --tls --cafile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/ca.pem --clientauth --keyfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/key.pem --certfile /etc/hyperledger/client/$ORG_NAME/admin/msp/tls/cert.pem
        
fi
