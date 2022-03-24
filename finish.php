<?php
session_start();
ini_set('max_execution_time', 901);
unset($_SESSION['ca']);
if (isset($_GET['ca']) && isset($_GET['country']) && isset($_GET['state']) && isset($_GET['locality']) && isset($_GET['org']) && isset($_GET['org_unit'])) {

	$_SESSION["ca"][0] = $_GET['ca'];
	$_SESSION["ca"][1] = $_GET['country'];
	$_SESSION["ca"][2] = $_GET['state'];
	$_SESSION["ca"][3] = $_GET['locality'];
	$_SESSION["ca"][4] = $_GET['org'];
	$_SESSION["ca"][5] = $_GET['org_unit'];

  $fp = fopen('./json/hosts.json', 'w');
  fwrite($fp, json_encode($_SESSION['hosts']));
  fclose($fp);

  $fp = fopen('./json/ca.json', 'w');
  fwrite($fp, json_encode($_SESSION['ca']));
  fclose($fp);
  
  $fp = fopen('./json/orderers.json', 'w');
  fwrite($fp, json_encode($_SESSION['orderers']));
  fclose($fp);
  
  $fp = fopen('./json/struct.json', 'w');
  fwrite($fp, json_encode($_SESSION['struct']));
  fclose($fp);
  
  $fp = fopen('./json/bootstrap.json', 'w');
  fwrite($fp, json_encode($_SESSION['bootstrap']));
  fclose($fp);
  
  $fp = fopen('./json/channels.json', 'w');
  fwrite($fp, json_encode($_SESSION['channels']));
  fclose($fp); 
  


}
else if (isset($_GET['file'])) {

$file = file_get_contents("./json/hosts.json");

$_SESSION['hosts'] = json_decode($file, true);

$file = file_get_contents("./json/ca.json");

$_SESSION['ca'] = json_decode($file, true);

$file = file_get_contents("./json/orderers.json");

$_SESSION['orderers'] = json_decode($file, true);

$file = file_get_contents("./json/couch.json");

$_SESSION['couch'] = json_decode($file, true);

$file = file_get_contents("./json/struct.json");

$_SESSION['struct'] = json_decode($file, true);

$file = file_get_contents("./json/bootstrap.json");

$_SESSION['bootstrap'] = json_decode($file, true);

$file = file_get_contents("./json/channels.json");

$_SESSION['channels'] = json_decode($file, true);

}
else {

	header("Location: ./index.php");
	die("0");

}
	
	
?>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Setup Panel (9/9)</title>
  <style>
	table {
	  font-family: arial, sans-serif;
	  border-collapse: collapse;
	  width: 100%;
	}

	td, th {
	  border: 1px solid #dddddd;
	  text-align: left;
	  padding: 8px;
	}

	tr:nth-child(even) {
	  background-color: #dddddd;
	}
</style>

</head>
<body>
	
	<h2>Hyperledger Fabric Setup Finished</h2>

	<?php
 
    unlink("./flag.txt");
 
		$hosts = "";
		$hosts2 = "";
		for ($j=0; $j<count($_SESSION['hosts']); $j++) {
			$hosts = $hosts."    - ".$_SESSION['hosts'][$j]."\n";
			$hosts2 = $hosts2."      - ".$_SESSION['hosts'][$j]."\n";
						
		}

		$orgs = "  orderer:\n    - orderer\n";
		$config_orgs = "";
		for ($j=0; $j<count($_SESSION['struct']); $j++) {
			$orgs = $orgs."  ".$_SESSION['struct'][$j]['name'].":\n    - ".$_SESSION['struct'][$j]['name']."\n";
			$config_orgs = $config_orgs."                - <<: *".ucfirst($_SESSION['struct'][$j]['name'])."\n";
		}			

		
		// config_proto/caclient/fabric-ca-client-config.yaml
		$edit_file = file_get_contents('./config_proto/caclient/fabric-ca-client-config.yaml');
		$edit_file = str_replace('$$url$$', $_SESSION["ca"][0],$edit_file);
		$edit_file = str_replace('$$c$$', $_SESSION["ca"][1],$edit_file);
		$edit_file = str_replace('$$st$$', $_SESSION["ca"][2],$edit_file);
		$edit_file = str_replace('$$l$$', $_SESSION["ca"][3],$edit_file);
		$edit_file = str_replace('$$o$$', $_SESSION["ca"][4],$edit_file);
		$edit_file = str_replace('$$ou$$', $_SESSION["ca"][5],$edit_file);
		$edit_file = str_replace('$$hosts$$', $hosts,$edit_file);	
		file_put_contents('./config/caclient/fabric-ca-client-config.yaml', $edit_file);
		
		// config_proto/ica/admin/fabric-ca-client-config.yaml
		$edit_file = file_get_contents('./config_proto/ica/admin/fabric-ca-client-config.yaml');
		$edit_file = str_replace('$$url$$', $_SESSION["ca"][0],$edit_file);
		$edit_file = str_replace('$$c$$', $_SESSION["ca"][1],$edit_file);
		$edit_file = str_replace('$$st$$', $_SESSION["ca"][2],$edit_file);
		$edit_file = str_replace('$$l$$', $_SESSION["ca"][3],$edit_file);
		$edit_file = str_replace('$$o$$', $_SESSION["ca"][4],$edit_file);
		$edit_file = str_replace('$$ou$$', $_SESSION["ca"][5],$edit_file);
		$edit_file = str_replace('$$hosts$$', $hosts,$edit_file);	
		file_put_contents('./config/ica/admin/fabric-ca-client-config.yaml', $edit_file);

		
		// config_proto/ica/fabric-ca-client-config.yaml
		$edit_file = file_get_contents('./config_proto/ica/fabric-ca-client-config.yaml');
		$edit_file = str_replace('$$url$$', $_SESSION["ca"][0],$edit_file);
		$edit_file = str_replace('$$c$$', $_SESSION["ca"][1],$edit_file);
		$edit_file = str_replace('$$st$$', $_SESSION["ca"][2],$edit_file);
		$edit_file = str_replace('$$l$$', $_SESSION["ca"][3],$edit_file);
		$edit_file = str_replace('$$o$$', $_SESSION["ca"][4],$edit_file);
		$edit_file = str_replace('$$ou$$', $_SESSION["ca"][5],$edit_file);
		$edit_file = str_replace('$$hosts$$', $hosts,$edit_file);	
		file_put_contents('./config/ica/fabric-ca-client-config.yaml', $edit_file);		

		
		// config_proto/fabric-ca-client-config.yaml
		$edit_file = file_get_contents('./config_proto/fabric-ca-client-config.yaml');
		$edit_file = str_replace('$$url$$', $_SESSION["ca"][0],$edit_file);
		$edit_file = str_replace('$$c$$', $_SESSION["ca"][1],$edit_file);
		$edit_file = str_replace('$$st$$', $_SESSION["ca"][2],$edit_file);
		$edit_file = str_replace('$$l$$', $_SESSION["ca"][3],$edit_file);
		$edit_file = str_replace('$$o$$', $_SESSION["ca"][4],$edit_file);
		$edit_file = str_replace('$$ou$$', $_SESSION["ca"][5],$edit_file);
		$edit_file = str_replace('$$hosts$$', $hosts,$edit_file);	
		file_put_contents('./config/fabric-ca-client-config.yaml', $edit_file);
		
		$pwd = bin2hex(openssl_random_pseudo_bytes(16));
		$pwd2 = bin2hex(openssl_random_pseudo_bytes(16));
		
		// config_proto/ica/fabric-ca-server-config.yaml
		$edit_file = file_get_contents('./config_proto/ica/fabric-ca-server-config.yaml');
		$edit_file = str_replace('$$url$$', $_SESSION["ca"][0],$edit_file);
		$edit_file = str_replace('$$c$$', $_SESSION["ca"][1],$edit_file);
		$edit_file = str_replace('$$st$$', $_SESSION["ca"][2],$edit_file);
		$edit_file = str_replace('$$l$$', $_SESSION["ca"][3],$edit_file);
		$edit_file = str_replace('$$o$$', $_SESSION["ca"][4],$edit_file);
		$edit_file = str_replace('$$ou$$', $_SESSION["ca"][5],$edit_file);
		$edit_file = str_replace('$$hosts$$', $hosts2,$edit_file);	
		$edit_file = str_replace('$$aff$$', $orgs,$edit_file);	
		$edit_file = str_replace('$$pw$$', $pwd,$edit_file);		// ICA PASSWORD
		$edit_file = str_replace('$$pw2$$', $pwd2,$edit_file);		// CA PASSWORD
		
		file_put_contents('./config/ica/fabric-ca-server-config.yaml', $edit_file);

		// config_proto/fabric-ca-server-config.yaml
		$edit_file = file_get_contents('./config_proto/fabric-ca-server-config.yaml');
		$edit_file = str_replace('$$c$$', $_SESSION["ca"][1],$edit_file);
		$edit_file = str_replace('$$st$$', $_SESSION["ca"][2],$edit_file);
		$edit_file = str_replace('$$l$$', $_SESSION["ca"][3],$edit_file);
		$edit_file = str_replace('$$o$$', $_SESSION["ca"][4],$edit_file);
		$edit_file = str_replace('$$ou$$', $_SESSION["ca"][5],$edit_file);
		$edit_file = str_replace('$$hosts$$', $hosts2,$edit_file);	
		$edit_file = str_replace('$$aff$$', $orgs,$edit_file);	
		$edit_file = str_replace('$$pw2$$', $pwd2,$edit_file);		// CA PASSWORD
		
		file_put_contents('./config/fabric-ca-server-config.yaml', $edit_file);		
	
		$config = file_get_contents('./config_proto/configtx.yaml');
		$all_files = "";
		for ($j=0; $j<count($_SESSION['struct']); $j++) {
		
			$edit_file = file_get_contents('./config_proto/configtx_orgs.yaml');
			$edit_file = str_replace('$$u_name$$', ucfirst($_SESSION['struct'][$j]['name']),$edit_file);
			$edit_file = str_replace('$$name$$', $_SESSION['struct'][$j]['name'],$edit_file);		
			
			$anchor = "";
			for ($z=0; $z<count($_SESSION['struct'][$j]['peers']); $z++) {
				if ($_SESSION['struct'][$j]['peers'][$z][2] == 1)
					$anchor = $anchor."      - Host: ".$_SESSION['struct'][$j]['peers'][$z][4]."\n        Port: ".$_SESSION['struct'][$j]['peers'][$z][1]."\n";				
			
			}
			$edit_file = str_replace('$$anchor$$', $anchor,$edit_file);		
			$all_files = $all_files."".$edit_file."\n\n";

			
		}
		
		$config = str_replace('$$orgs$$', $all_files,$config);	
		
		
		$addr = "";
		$raft = "";
		for ($j=0; $j<count($_SESSION['orderers']); $j++) {
			$addr = $addr."    - ".$_SESSION['orderers'][$j][2].":".$_SESSION['orderers'][$j][1]."\n";
			$raft = $raft."          - Host: ".$_SESSION['orderers'][$j][2]."\n            Port: ".$_SESSION['orderers'][$j][1]."\n";			
			$raft = $raft."            ClientTLSCert: /etc/hyperledger/client/orderer/".$_SESSION['orderers'][$j][0]."/msp/tls/cert.pem\n            ServerTLSCert: /etc/hyperledger/client/orderer/".$_SESSION['orderers'][$j][0]."/msp/tls/cert.pem\n\n";
		}	

		$config = str_replace('$$addr$$', $addr,$config);	
		$config = str_replace('$$raft$$', $raft,$config);	
		
		$consor = "";
		$channel = "";
		for ($j=0; $j<count($_SESSION['channels']); $j++) {
			$consor_name = ucfirst($_SESSION['channels'][$j]['name'])."Consortium";
			
			$channel = $channel."  ".ucfirst($_SESSION['channels'][$j]['name']).":\n    <<: *ChannelDefaults\n";
			$channel = $channel."    Consortium: ".$consor_name."\n\n    Application:\n        <<: *ApplicationDefaults\n\n        Organizations:\n";
			
			$consor = $consor."        ".$consor_name.":\n            Organizations:\n";
			for ($z=0; $z<count($_SESSION['channels'][$j]['orgs']); $z++) {
			$consor = $consor."                  - <<: *".ucfirst($_SESSION['channels'][$j]['orgs'][$z])."\n";
			
			$channel = $channel."            - <<: *".ucfirst($_SESSION['channels'][$j]['orgs'][$z])."\n";
			}
			$channel = $channel."\n";
		}		
		
		$config = str_replace('$$consor$$', $consor,$config);	
		$config = str_replace('$$channel$$', $channel,$config);
		
		$config = str_replace('$$appl$$', $config_orgs,$config);
		
		
		file_put_contents('./config/configtx.yaml', $config);		

		
		$ca_ica_admin_pass = bin2hex(openssl_random_pseudo_bytes(16));
		$ica_admin_pass = bin2hex(openssl_random_pseudo_bytes(16));
		
		?>
		
<table>
  <tr>
    <th>CA Server admins</th>
    <th>user</th>
    <th>password</th>
  </tr>
  <tr>
    <td><?php echo $_SESSION["ca"][0]; ?></td>
    <td>admin</td>
    <td><?php echo $pwd2; ?></td>
  </tr>
  <tr>
    <td><?php echo $_SESSION["ca"][0]; ?></td>
    <td>ica-admin</td>
    <td><?php echo $ca_ica_admin_pass; ?></td>
  </tr>
</table><br><br>		

<table>
  <tr>
    <th>ICA Server admins</th>
    <th>user</th>
    <th>password</th>
  </tr>

		<?php
		$ca_file = '#!/bin/sh
DIR=`dirname "$(realpath $0)"`
cp -rp $DIR/config /etc/hyperledger/
cd $DIR/ca
SLEEP_TIME=2s
SLEEP_TIME2=1s

./clean.sh
sleep $SLEEP_TIME2
echo "====> 1. Cleaning Done"

./server.sh "start" "'.$_SESSION["ca"][0].'" "'.$pwd2.'"
echo "====> 2. Starting ROOT CA server"
sleep $SLEEP_TIME
sleep $SLEEP_TIME2


./server.sh "enroll" "'.$_SESSION["ca"][0].'" "'.$pwd2.'"
sleep $SLEEP_TIME

ca_pid=$(pgrep fabric-ca-serve)

./register-enroll-ica-admin.sh "'.$_SESSION["ca"][0].'" "'.$ca_ica_admin_pass.'"
echo "====> 3. Enrolled Bootstrap ROOT Identity and ICA"
sleep $SLEEP_TIME


./icaserver.sh "start" "'.$_SESSION["ca"][0].'" "'.$pwd.'"
echo "====> 4. Starting ICA server"
sleep $SLEEP_TIME
sleep $SLEEP_TIME2


./icaserver.sh "enroll" "'.$_SESSION["ca"][0].'" "'.$pwd.'"
echo "====> 5. Enrolled Bootstrap Identity"
sleep $SLEEP_TIME

kill $ca_pid
echo "====> 6. Stoping/Killing ROOT CA server"
sleep $SLEEP_TIME


./register-enroll-orderer-admin.sh "orderer" "'.$_SESSION["ca"][0].'" "'.$ica_admin_pass.'" "-1"
sleep $SLEEP_TIME
./setup-org-msp.sh "orderer"
sleep $SLEEP_TIME2
';

?>

  <tr>
    <td><?php echo $_SESSION["ca"][0]; ?></td>
    <td>orderer-admin</td>
    <td><?php echo $ica_admin_pass; ?></td>
  </tr>

<?php
	
	for ($j=0; $j<count($_SESSION['struct']); $j++) {
		$ica_org_admins_pass = bin2hex(openssl_random_pseudo_bytes(16));
		$ca_file = $ca_file.'
./register-enroll-admin.sh "'.$_SESSION['struct'][$j]['name'].'" "'.$_SESSION["ca"][0].'" "'.$ica_org_admins_pass.'" "-1"
sleep $SLEEP_TIME
./setup-org-msp.sh "'.$_SESSION['struct'][$j]['name'].'"
sleep $SLEEP_TIME2
';
		
		echo '<tr><td>'.$_SESSION["ca"][0].'</td><td>'.$_SESSION['struct'][$j]['name'].'-admin</td><td>'.$ica_org_admins_pass.'</td></tr>';

	}			
	
	$ca_file = $ca_file.'
echo "====> 7. Enrolled Admin Identities"

echo "====> 8. Completed MSP setup for orgs"
';
	
	?>

</table><br><br>

<table>
  <tr>
    <th>ICA Server identities</th>
    <th>user</th>
    <th>password</th>
  </tr>


<?php

	for ($j=0; $j<count($_SESSION['orderers']); $j++) {
		$ica_orderer_ident_pass = bin2hex(openssl_random_pseudo_bytes(16));
		$ca_file = $ca_file.'
./register-enroll-orderer.sh "'.$_SESSION['orderers'][$j][0].'" "'.$_SESSION["ca"][0].'" "'.$ica_orderer_ident_pass.'"
sleep $SLEEP_TIME';
		echo '<tr><td>'.$_SESSION["ca"][0].'</td><td>'.$_SESSION['orderers'][$j][0].'</td><td>'.$ica_orderer_ident_pass.'</td></tr>';
	}	
	$ca_file = $ca_file.'

echo "====> 9. Orderer(s) completed!"
';	


		for ($j=0; $j<count($_SESSION['struct']); $j++) {
			for ($z=0; $z<count($_SESSION['struct'][$j]['peers']); $z++) {
				$ica_peer_ident_pass = bin2hex(openssl_random_pseudo_bytes(16));
				$ca_file = $ca_file.'
./register-enroll-peer.sh "'.$_SESSION['struct'][$j]['name'].'" "'.$_SESSION['struct'][$j]['peers'][$z][0].'" "'.$_SESSION["ca"][0].'" "'.$ica_peer_ident_pass.'"
sleep $SLEEP_TIME';

		echo '<tr><td>'.$_SESSION["ca"][0].'</td><td>'.$_SESSION['struct'][$j]['peers'][$z][0].'</td><td>'.$ica_peer_ident_pass.'</td></tr>';
		
			}
		}
	$ca_file = $ca_file.'

echo "====> 10. Peer(s) completed!"

./generate-genesis.sh
sleep $SLEEP_TIME
echo "====> 11. Genesis block completed!"
';	


		for ($j=0; $j<count($_SESSION['channels']); $j++) {
			$ca_file = $ca_file.'
./generate-channel-tx.sh "'.$_SESSION['channels'][$j]['name'].'"
sleep $SLEEP_TIME2';
			
		}

		$ca_file = $ca_file.'
echo "====> 12. Channels-tx completed!"

ps -eal | grep fabric-ca-serve
echo "$0 PLEASE - Go through the logs above to ensure there are NO errors!!!"
chmod -R 755 /etc/hyperledger/config/
chmod -R 755 /etc/hyperledger/client/
test -e /etc/hyperledger/client/caserver/admin/msp/signcerts/cert.pem && echo 1 > /var/www/html/setup/flag.txt || echo 0 > /var/www/html/setup/flag.txt';	

?>
	
</table><br><br>
	
Execute /var/www/html/setup/setup_ca.sh via terminal and when the proccess is finished (with NO errors), just press Distribute Files<br><br>
<button onclick="location.href='./distribution.php'" type="button">Distribute Files</button>
<?php
  $ca_file = str_replace("\r", '', $ca_file);
	file_put_contents('./setup_ca.sh', $ca_file);		
  
  
  
  $output = shell_exec('sh ./run.sh > ./setup_ca.log');
  //echo nl2br($output);
?>
</body>
</html>
