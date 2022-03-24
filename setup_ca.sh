#!/bin/sh
DIR=`dirname "$(realpath $0)"`
cp -rp $DIR/config /etc/hyperledger/
cd $DIR/ca
SLEEP_TIME=2s
SLEEP_TIME2=1s

./clean.sh
sleep $SLEEP_TIME2
echo "====> 1. Cleaning Done"

./server.sh "start" "ledger1.drosatos.eu" "396da9ead0b610d5421bc57d88b6c64e"
echo "====> 2. Starting ROOT CA server"
sleep $SLEEP_TIME
sleep $SLEEP_TIME2


./server.sh "enroll" "ledger1.drosatos.eu" "396da9ead0b610d5421bc57d88b6c64e"
sleep $SLEEP_TIME

ca_pid=$(pgrep fabric-ca-serve)

./register-enroll-ica-admin.sh "ledger1.drosatos.eu" "8f716bdbccb0f28c60627d3cd3b0a117"
echo "====> 3. Enrolled Bootstrap ROOT Identity and ICA"
sleep $SLEEP_TIME


./icaserver.sh "start" "ledger1.drosatos.eu" "40f244b1d5be6c407c88ee2f4c3a2abf"
echo "====> 4. Starting ICA server"
sleep $SLEEP_TIME
sleep $SLEEP_TIME2


./icaserver.sh "enroll" "ledger1.drosatos.eu" "40f244b1d5be6c407c88ee2f4c3a2abf"
echo "====> 5. Enrolled Bootstrap Identity"
sleep $SLEEP_TIME

kill $ca_pid
echo "====> 6. Stoping/Killing ROOT CA server"
sleep $SLEEP_TIME


./register-enroll-orderer-admin.sh "orderer" "ledger1.drosatos.eu" "98f5d0f63d1ca9595d9c8b1295776c4e" "-1"
sleep $SLEEP_TIME
./setup-org-msp.sh "orderer"
sleep $SLEEP_TIME2

./register-enroll-admin.sh "duth" "ledger1.drosatos.eu" "ab7b4fddd5000df7912e99bdbc623179" "-1"
sleep $SLEEP_TIME
./setup-org-msp.sh "duth"
sleep $SLEEP_TIME2

./register-enroll-admin.sh "athena" "ledger1.drosatos.eu" "5bddfcd80993749e9a20e0725acae9b0" "-1"
sleep $SLEEP_TIME
./setup-org-msp.sh "athena"
sleep $SLEEP_TIME2

echo "====> 7. Enrolled Admin Identities"

echo "====> 8. Completed MSP setup for orgs"

./register-enroll-orderer.sh "orderer1" "ledger1.drosatos.eu" "ca0a31b3170aa65ef9e4a99fc85bf8a5"
sleep $SLEEP_TIME
./register-enroll-orderer.sh "orderer2" "ledger1.drosatos.eu" "faa3ccaefae21b51c9e0206d8bf4fdf6"
sleep $SLEEP_TIME
./register-enroll-orderer.sh "orderer3" "ledger1.drosatos.eu" "b224ae2433c6c56239fdf24f0a4681c9"
sleep $SLEEP_TIME

echo "====> 9. Orderer(s) completed!"

./register-enroll-peer.sh "duth" "peer1" "ledger1.drosatos.eu" "ef06d4565698813eafda27d6bfafb9c2"
sleep $SLEEP_TIME
./register-enroll-peer.sh "duth" "peer2" "ledger1.drosatos.eu" "e5ecb07a504a53942c16303945d010b8"
sleep $SLEEP_TIME
./register-enroll-peer.sh "athena" "peer3" "ledger1.drosatos.eu" "d077512968a519f58fbda9a08587ef70"
sleep $SLEEP_TIME

echo "====> 10. Peer(s) completed!"

./generate-genesis.sh
sleep $SLEEP_TIME
echo "====> 11. Genesis block completed!"

./generate-channel-tx.sh "duthchannel"
sleep $SLEEP_TIME2
./generate-channel-tx.sh "athenachannel"
sleep $SLEEP_TIME2
./generate-channel-tx.sh "duthathenachannel"
sleep $SLEEP_TIME2
echo "====> 12. Channels-tx completed!"

ps -eal | grep fabric-ca-serve
echo "$0 PLEASE - Go through the logs above to ensure there are NO errors!!!"
chmod -R 755 /etc/hyperledger/config/
chmod -R 755 /etc/hyperledger/client/
test -e /etc/hyperledger/client/caserver/admin/msp/signcerts/cert.pem && echo 1 > /var/www/html/setup/flag.txt || echo 0 > /var/www/html/setup/flag.txt