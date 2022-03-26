<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Files Distribution</title>
  
</head>
<body>
<?php
ini_set('max_execution_time', 360);
session_start();

if (file_exists("./flag.txt")) {

  $flag = file_get_contents('./flag.txt');
  if (substr($flag, 0, 1) === "1") {
  
  ?>
    <h2>Files Distribution</h2>
     Your ICA is up and running...<br>
     Move /etc/hyperledger/rootclient and /etc/hyperledger/rootserver folders (ROOT CA private keys) to a safe (offline maybe) place<br><br>
     Execute the commands below in each host<br><br>
  <?php
    $options = [
      'cost' => 11
    ];
		
		for ($j=0; $j<count($_SESSION['hosts']); $j++) {
			$hosts = $_SESSION['hosts'][$j];

      if (!file_exists("./host/$hosts")) {
		    mkdir("./host/$hosts", 0777, true);
		  }
      if (!file_exists("./host/temp")) {
		    mkdir("./host/temp", 0777, true);
        mkdir("./host/temp/bin", 0777, true);
		  }
      $htacc = '
AuthName "Authentication Required"
AuthType Basic
AuthUserFile /var/www/html/setup/host/.htpasswd_'.$j.'
require valid-user
';

    $rand_pass = bin2hex(openssl_random_pseudo_bytes(16));
    $htpass = $hosts.':'.password_hash($rand_pass, PASSWORD_BCRYPT, $options);
    
    file_put_contents("./host/$hosts/.htaccess", $htacc);
    
    file_put_contents("./host/.htpasswd_$j", $htpass);
    
    $add_peer = '#!/bin/sh
DIR=`dirname "$(realpath $0)"`
cd $DIR/data
';
    $peer_data = '#!/bin/sh
usage() {
    echo ". peer_data.sh   PEER_NAME"
    echo "               Sets the environment variables for the peer that need to be administered"
}
if [ -z "$1" ];
then
    usage
    echo "Please provide the PEER Name!!!"
    exit 0
else
  SELECTED_PEER=0
';
    $peer_data_json = array();
    
    $ordererflag = 0;
      for ($i=0; $i<count($_SESSION['orderers']); $i++) {
        if ($_SESSION['orderers'][$i][2] == $hosts) {
          
          shell_exec("cp -rp /var/www/html/setup/orderer /var/www/html/setup/host/temp/");
          shell_exec("cp -rp /etc/hyperledger/config/zerodata-genesis.block /var/www/html/setup/host/temp/");
          shell_exec("cp -rp /etc/hyperledger/client/orderer-".$_SESSION['orderers'][$i][0].".tar /var/www/html/setup/host/temp/");
          shell_exec("cp -rp /var/www/html/setup/bin/configtxlator /var/www/html/setup/host/temp/bin/configtxlator");
          shell_exec("cp -rp /var/www/html/setup/bin/orderer /var/www/html/setup/host/temp/bin/orderer");        
          shell_exec("cp -rp /etc/hyperledger/config/orderer.yaml /var/www/html/setup/host/temp/");

         
          $setup_orderer = '#!/bin/sh
DIR=`dirname "$(realpath $0)"`
cd $DIR/orderer
killall orderer 2> /dev/null
sleep 1s
./launch.sh '.$_SESSION['orderers'][$i][0].' '.$_SESSION['orderers'][$i][1].'';

          $setup_orderer = str_replace("\r", '', $setup_orderer);
        	file_put_contents("./host/temp/setup_orderer.sh", $setup_orderer);		
         
         
         $ordererflag = 1;
         
          
         
        }
      }
    
    $couchdbflag = 0;
    $user = '';
    $pass = '';
    for ($i=0; $i<count($_SESSION['couch']); $i++) {
      if ($_SESSION['couch'][$i][0] == $hosts) {
        $user = $_SESSION['couch'][$i][1];
        $pass = $_SESSION['couch'][$i][2];
        $couchdbflag = 1;
      }
    
    }
    
    
    $peerflag = 0;
    $has_couch = 0;
  	for ($i=0; $i<count($_SESSION['struct']); $i++) {
  		  $org_name = $_SESSION['struct'][$i]['name'];
  			for ($z=0; $z<count($_SESSION['struct'][$i]['peers']); $z++) {  
        
          $setup_peer = '';  
          if ($_SESSION['struct'][$i]['peers'][$z][4] == $hosts) {
            $peer_name = $_SESSION['struct'][$i]['peers'][$z][0];
            $peer_port = $_SESSION['struct'][$i]['peers'][$z][1];
            $peer_db = $_SESSION['struct'][$i]['peers'][$z][3];
            if ($peer_db == "1") {
              $has_couch = 1;
              $peer_db = 'CouchDB';
              $db_user_pass = ' '.$user.' '.$pass;
            }
            else {
              $peer_db = 'goleveldb';
              $db_user_pass = '';
            }
            
            $bootstrap = '';
            
            for ($i_bootst=0; $i_bootst<count($_SESSION['bootstrap']); $i_bootst++) {
              if ($org_name == $_SESSION['bootstrap'][$i_bootst][0])
                $bootstrap = $_SESSION['bootstrap'][$i_bootst][1];
            
            }
            
            $setup_peer = $setup_peer.'#!/bin/bash
DIR=`dirname "$(realpath $0)"`
cd $DIR/peer
SLEEP_TIME=3s
SLEEP_TIME2=2s
source set-env.sh '.$org_name." ".$peer_name." ".$peer_port." ".$hosts." ".$peer_db." '".$bootstrap."'".$db_user_pass."

peer node rebuild-dbs
echo 'Ingore the errors (if exists)!!!'

./launch-peer.sh ".$org_name." ".$peer_name." ".$peer_port." ".$hosts." ".$peer_db." '".$bootstrap."'".$db_user_pass."
sleep ".'$SLEEP_TIME2'."
ps -eal | grep peer
";
            
    
            
            for ($i_channel=0; $i_channel<count($_SESSION['channels']); $i_channel++) { 
              
              for ($z_channel=0; $z_channel<count($_SESSION['channels'][$i_channel]['orgs']); $z_channel++) {
                if ($_SESSION['channels'][$i_channel]['orgs'][$z_channel] == $org_name) {
                  $setup_peer = $setup_peer."
./submit-create-channel.sh ".$org_name." admin ".$_SESSION['orderers'][0][2]." ".$_SESSION['orderers'][0][1]." ".$_SESSION['channels'][$i_channel]['name']."
sleep ".'$SLEEP_TIME'."
./join-channel.sh ".$org_name." ".$peer_name." ".$peer_port." ".$hosts." ".$peer_db." '".$bootstrap."' ".$_SESSION['orderers'][0][2]." ".$_SESSION['orderers'][0][1]." ".$_SESSION['channels'][$i_channel]['name']."".$db_user_pass."
sleep ".'$SLEEP_TIME2'."";
                
                  shell_exec("cp -rp /etc/hyperledger/config/".$_SESSION['channels'][$i_channel]['name']."-channel.tx /var/www/html/setup/host/temp/");
                
                }
            
              }
            
            }
            
            $setup_peer = $setup_peer.'

peer channel list

echo "====> Peer launched, channels created and joined (if the channels have already created, it will appear an error but it is ok)!"

mkdir $DIR/peer/source
';


            for ($i_channel=0; $i_channel<count($_SESSION['channels']); $i_channel++) { 
              
              for ($z_channel=0; $z_channel<count($_SESSION['channels'][$i_channel]['orgs']); $z_channel++) {
                if ($_SESSION['channels'][$i_channel]['orgs'][$z_channel] == $org_name) {
                  $setup_peer = $setup_peer.'
./commit-chaincode.sh '.$peer_name.' '.$_SESSION['orderers'][0][2].":".$_SESSION['orderers'][0][1].' "$DIR/peer/ccoc" ccoc "1.0" "1.0" node '.$_SESSION['channels'][$i_channel]['name'].' \'{"function":"initLedger","Args":[]}\'

sleep 3s
';
                
                
                }
            
              }
            
            }
 
            $setup_peer = $setup_peer.'
docker_ip=$(docker ps -aqf "name='.$peer_name.'-ccoc")

sleep 1s

docker cp $DIR/peer/source $docker_ip:/usr/local/

sleep 1s

rm -r $DIR/peer/source';           

            $setup_peer = str_replace("\r", '', $setup_peer);
        	  file_put_contents("./host/temp/setup_".$peer_name.".sh", $setup_peer);
            shell_exec("cp -rp /etc/hyperledger/client/".$org_name."-".$peer_name.".tar /var/www/html/setup/host/temp/");
            
            $add_peer = $add_peer."
./setup_".$peer_name.".sh
sleep 1s";
            
            $peer_data = $peer_data.'
  if [ "$1" = "'.$peer_name.'" ]; then
    SELECTED_PEER=1
    ORG_NAME='.$org_name.'
    PEER_NAME='.$peer_name.'
    PORT_NUMBER_BASE='.$peer_port.'
    PEER_ADDRESS='.$hosts.'
    STATEDATABASE='.$peer_db."
    BOOTSTRAP='".$bootstrap."'
    USERNAME='".$user."'
    PASSWORD='".$pass."'
    IDENTITY=".'$PEER_NAME
  fi';
            array_push($peer_data_json, $peer_name);
            $peerflag = 1;        
          }
    
        }
    }
    
    if ($peerflag == 1) {
      shell_exec("cp -rp /var/www/html/setup/peer /var/www/html/setup/host/temp/");
      shell_exec("cp -rp /var/www/html/setup/bin/configtxlator /var/www/html/setup/host/temp/bin/configtxlator");
      shell_exec("cp -rp /var/www/html/setup/bin/discover /var/www/html/setup/host/temp/bin/discover");    
      shell_exec("cp -rp /var/www/html/setup/bin/peer /var/www/html/setup/host/temp/bin/peer");
      shell_exec("cp -rp /var/www/html/setup/docker /var/www/html/setup/host/temp/");
      shell_exec("cp -rp /etc/hyperledger/config/core.yaml /var/www/html/setup/host/temp/");
      $add_peer = $add_peer.'
sleep 5s
cd $DIR/data/peer
./peer_watchdog &>/dev/null &';      
      $add_peer = str_replace("\r", '', $add_peer);
     	file_put_contents("./host/$hosts/setup_peers.sh", $add_peer);    
      
      $peer_data = $peer_data.'
  if [ "$1" = "*" ]; then 
     echo \''.json_encode($peer_data_json).'\';
  elif [ "$SELECTED_PEER" -eq "0" ]; then
     echo "Peer not found!!!";
     exit;
  fi
fi';   
      
      $peer_data = str_replace("\r", '', $peer_data);
     	file_put_contents("./host/temp/peer/peer_data.sh", $peer_data);         
    }
   if ($couchdbflag == 1) {    
      shell_exec("cp -rp /var/www/html/setup/couch /var/www/html/setup/host/temp/");
   }
   
   $delete_all = '#!/bin/sh
killall fabric-ca-server 2> /dev/null
killall orderer 2> /dev/null
killall peer 2> /dev/null

rm -rf /etc/hyperledger/server/* 2> /dev/null

rm -rf /etc/hyperledger/client/* 2> /dev/null

rm -rf /etc/hyperledger/rootserver/* 2> /dev/null

rm -rf /etc/hyperledger/rootclient/* 2> /dev/null

rm -rf /etc/hyperledger/config/* 2> /dev/null

rm -rf /var/ledgers/* 2> /dev/null

DIR=`dirname "$(realpath $0)"`
rm -rf $DIR/../* 2> /dev/null

CONT_ID=`docker ps -aqf "name=couch"`

docker stop $CONT_ID

sleep 1s

docker rm $CONT_ID

sleep 1s

docker ps';
   
    $delete_all = str_replace("\r", '', $delete_all);
   	file_put_contents("./host/temp/delete_all.sh", $delete_all);	 
   
    shell_exec("tar -cf /var/www/html/setup/host/$hosts/data.tar -C /var/www/html/setup/host/temp .");
    //shell_exec("cp -r /var/www/html/setup/host/temp/* /var/www/html/setup/host/$hosts/");
    $setup = '#!/bin/sh
sudo mkdir /var/ledgers
sudo chmod -R 777 /var/ledgers
mkdir /var/ledgers/gopath
mkdir /var/ledgers/nodechaincode
mkdir /var/ledgers/source

sudo mkdir -p /etc/hyperledger
sudo chmod -R 777 /etc/hyperledger

DIR=`dirname "$(realpath $0)"`
mkdir $DIR/data
tar -xf data.tar -C $DIR/data
cd $DIR/data
chmod -R 755 ./

chmod 755 $DIR/setup_peers.sh

sudo cp -r bin /usr/local/
rm -rf bin

mkdir -p /etc/hyperledger/config/
mkdir -p /etc/hyperledger/client/

mv *.tar /etc/hyperledger/client/

mv zerodata-genesis.block /etc/hyperledger/config/
mv orderer.yaml /etc/hyperledger/config/

mv core.yaml /etc/hyperledger/config/
mv *.tx /etc/hyperledger/config/

C_PATH=`pwd`
cd /etc/hyperledger/client/
cat *.tar | tar -xf - -i
cd $C_PATH
rm /etc/hyperledger/client/*.tar

./setup_orderer.sh

';

   if ($couchdbflag == 1) {    
      $setup = $setup.'
./couch/couchdb.sh "'.$user.'" "'.$pass.'"';
   }
    $setup = str_replace("\r", '', $setup);
   	file_put_contents("./host/$hosts/setup.sh", $setup);	   
    
    shell_exec("rm -rf /var/www/html/setup/host/temp");
    
    echo '<h3>Host: '.$hosts.'</h3>';
    echo "<div>wget --no-check-certificate https://".$hosts.':'.$rand_pass."@".$_SESSION["ca"][0]."/setup/host/".$hosts."/data.tar && wget --no-check-certificate https://".$hosts.':'.$rand_pass."@".$_SESSION["ca"][0]."/setup/host/".$hosts."/setup.sh && wget --no-check-certificate https://".$hosts.':'.$rand_pass."@".$_SESSION["ca"][0]."/setup/host/".$hosts."/setup_peers.sh && chmod 755 setup.sh && ./setup.sh</div><br>";
    
		}
    
?>

<br>After executing ALL the above commands, wait a few minutes and execute in every host ./setup_peers.sh (if exists)

<?php
  
  }
  else {
  
    echo 'Error detected, please execute /var/www/html/setup/setup_ca.sh again via terminal and then refresh this page!!!';
  
  }
  
}
else {

  echo 'Execute /var/www/html/setup/setup_ca.sh via terminal and then refresh this page!!!';

}


?>



	


  
</body>
</html>
