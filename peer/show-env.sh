#!/bin/bash
# Dumps the Peer config

env | grep CORE_PEER
echo "FABRIC_CFG_PATH=$FABRIC_CFG_PATH"
echo "FABRIC_LOGGING_SPEC=$FABRIC_LOGGING_SPEC"