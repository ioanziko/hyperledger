<?php
session_start();
if (isset($_GET['orgs'])) {

	$orgs = intval($_GET['orgs']);

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
  <title>Hyperledger Fabric Setup Panel (6/9)</title>
  
</head>
<body>
	
	<h2>Give the Organization names and add the peers</h2>
	<form action="../" medthod="GET" onsubmit="return valid()">


	<?php
		for ($i=1; $i<=$orgs; $i++) {
			
			echo "<label for='orgs$i' style='font-size:19px;'>Organization $i name: </label>";
			echo "<input type='text' id='orgs$i' name='orgs$i' placeholder='lower case' required>, Org CA host: ";
			?>
      <select id='orgs_ca<?php echo $i; ?>' name='orgs_ca<?php echo $i; ?>'><?php for ($j=0; $j<count($_SESSION['hosts']); $j++) { echo '<option value=\''.$_SESSION['hosts'][$j].'\'>'.$_SESSION['hosts'][$j].'</option>';} ?></select>
			<button onclick="addpeer('org<?php echo $i; ?>')">Add peer</button><br><br>		
			<?php
			echo "<div id='org$i'></div><br><hr><br>";
		}
	
	
	?>
	
	


    *Admin: Install, query, approve, commit, invoke<br>
    *Non-admin: Install, query<br>
		<input type="submit" value="Next">
	</form>	  

	<script>
		function addpeer(org_id) {
		    var div = document.createElement('div');
			div.innerHTML = "<span>Peer name: <input type='text' name='peername' placeholder='lower case' required></span><span>, port: </span><input type='number' name='peerport' style='width:92px;' min='1' step='1' placeholder='Eg 7051' required><span>, anchor: </span><select name='peeranchor'><option value='0'>No</option><option value='1' selected>Yes</option></select><span>, stateledger: </span><select name='peerstate'><option value='0'>goleveldb</option><option value='1' selected>CouchDB</option></select><span>, CouchDB user: </span><input type='password' name='couchuser' placeholder='Fill these fields'><span>, CouchDB password: </span><input type='password' name='couchpass' placeholder='IF Couchdb selected'>, Admin: </span><input type='checkbox' name='admin' checked><span>, machine: </span><select name='peer_mach'><?php for ($j=0; $j<count($_SESSION['hosts']); $j++) { echo '<option value=\''.$_SESSION['hosts'][$j].'\'>'.$_SESSION['hosts'][$j].'</option>';} ?></select> <span onclick='this.parentNode.remove();' style='color:red; font-weight:bold; cursor:pointer;'> X </span><br><br>";
			
			document.getElementById(org_id).appendChild(div);
		
		};
	
		function valid(){
			var count = <?php echo $orgs; ?>;
			var text;
			var text2;
			var flag = 0;
			var ca;
			
			json_data = '[';
			for (var i=1; i<=count; i++) {

				text = (document.getElementById('orgs'+i).value).toLowerCase();
				ca = document.getElementById('orgs_ca'+i).options[document.getElementById('orgs_ca'+i).selectedIndex].value;
        
				json_data += '{"name":"'+text+'", "ca":"'+ca+'", "peers": [';
				var childDivs = document.getElementById('org'+i).getElementsByTagName('div');

				for( i2=0; i2< childDivs.length; i2++ )
				{
					var childDiv = childDivs[i2].getElementsByTagName('input');
					var childDiv_input = childDivs[i2].getElementsByTagName('select');
					json_data += '[';
					for( j=0; j< childDiv.length; j++ ) {
               
             if (childDiv[j].type === "number")   
						    json_data += '"'+(parseInt(childDiv[j].value)-1)+'",';
             else if (childDiv[j].type === "text")
                json_data += '"'+(childDiv[j].value).toLowerCase()+'",';
					
					}
					for( j=0; j< childDiv_input.length; j++ ) {
						json_data += '"'+childDiv_input[j].options[childDiv_input[j].selectedIndex].value+'",';

						
					
					}
					for( j=0; j< childDiv.length; j++ ) {
               
            if (childDiv[j].type === "password")
                json_data += '"'+(childDiv[j].value).toLowerCase()+'",';
            else if (childDiv[j].type === "checkbox") {
                if (childDiv[j].checked)
                  json_data += '"1",';
                else
                  json_data += '"0",';
            }				
                
					}
					json_data = json_data.substring(0, json_data.length - 1);
					json_data += '],';
				}
				json_data = json_data.substring(0, json_data.length - 1);
				json_data += ']},';
			}
			
			json_data = json_data.substring(0, json_data.length - 1);
			json_data += ']';
			
			json_data = JSON.parse(json_data);

			var flag = 0;

			for (var i=0; i<(json_data.length-1); i++) {
			
				for (var j=(i+1); j<json_data.length; j++) {
					
					if (json_data[i].name === json_data[j].name || json_data[i].ca === json_data[j].ca || json_data[i].name === 'admin' || json_data[j].name === 'admin')
						flag = 1;
				
				
				}			
			
			}
			if (flag == 1) {
				alert('Organization names and CA hosts must be unique');
				return false;
			}
			
			
			var peer_names = document.getElementsByName("peername");
			for (var i = 0; i < (peer_names.length-1); i++) {
				for (var j = (i+1); j < peer_names.length; j++) {
					if (peer_names[i].value === peer_names[j].value || peer_names[i].value === 'admin' || peer_names[j].value === 'admin')
						flag = 1;
				}
			}
			if (flag == 1) {
				alert('Peer names must be unique');
				return false;
			}			
			
			var peer_ports = document.getElementsByName("peerport");
			var peer_mach = document.getElementsByName("peer_mach");
			for (var i = 0; i < (peer_ports.length-1); i++) {
				for (var j = (i+1); j < peer_ports.length; j++) {
					var port1 = parseInt(peer_ports[i].value);
					var port2 = parseInt(peer_ports[j].value);

					
					var mach1 = peer_mach[i].options[peer_mach[i].selectedIndex].value;
					var mach2 = peer_mach[j].options[peer_mach[j].selectedIndex].value;

					if (mach1 === mach2 && (port1 - 7) <= port2 && (port1 + 7) >= port2)
						flag = 1;
				}
			}			
			if (flag == 1) {
				alert('Same peer port (or very close) found on the same machine');
				return false;
			}
			
			
			for (var i=0; i<json_data.length; i++) {
				var found = 0;
				for (var j=0; j<json_data[i].peers.length; j++) {
					if (json_data[i].peers[j][2] == 1)
						found = 1;
				}
				if (found == 0)
					flag = 1;
			}
			
			if (flag == 1) {
				alert('Every organization must have at least one anchor peer');
				return false;
			}
			

			var peerstate = document.getElementsByName("peerstate");
			var couchuser = document.getElementsByName("couchuser");
			var couchpass = document.getElementsByName("couchpass");
      for (var i = 0; i < (peerstate.length); i++) {
        if (peerstate[i].options[peerstate[i].selectedIndex].value === "1") {
          if ((couchuser[i].value).length < 4 || (couchpass[i].value).length < 4)
            flag = 1;
        
        }
      
      
      }
			if (flag == 1) {
				alert('Every peer with CouchDB must have a user and a password. User and password must be at least 4 characters.');
				return false;
			}            
			window.location.replace("./channels.php?struct="+JSON.stringify(json_data)+"");


			return false;

			
		};
	
	</script>
</body>
</html>