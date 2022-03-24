<?php
session_start();
if (isset($_GET['struct'])) {

	unset($_SESSION['struct']); 
	$_SESSION['struct'] = json_decode($_GET['struct'], true);

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
  <title>Hyperledger Fabric Setup Panel (7/9)</title>
  
</head>
<body>
	
	<h2>Channels</h2>
	
	<form action="./" medthod="GET" onsubmit="return valid()">
		<button onclick="addchannel()">Add Channel</button><br><br>		
		<div id='channels'></div><br><br>
	
		<input type="submit" value="Next">
	</form>	  	
	
	<script>
		function addchannel() {
			var div = document.createElement('div');

			
			div.innerHTML = "<span>Channel name: <input type='text' name='channelname' placeholder='lower case' required></span> <select name='orgs' style='width:100px; height:120px; vertical-align: middle;' multiple required><?php for ($i=0; $i<count($_SESSION['struct']); $i++) echo '<option value=\''.$_SESSION['struct'][$i]['name'].'\'>'.$_SESSION['struct'][$i]['name'].'</option>'; ?></select> <span onclick='this.parentNode.remove();' style='color:red; font-weight:bold; cursor:pointer;'> X </span><br><hr><br>";
				
			document.getElementById('channels').appendChild(div);
			
		};
		
		
		function valid() {
			
			json_data = '[';
			var childDivs = document.getElementById('channels').getElementsByTagName('div');
			for( i2=0; i2< childDivs.length; i2++ )
			{
				var childDiv = childDivs[i2].getElementsByTagName('input');
				var childDiv_input = childDivs[i2].getElementsByTagName('select');

				for( j=0; j< childDiv.length; j++ ) {

					json_data += '{"name":"'+(childDiv[j].value).toLowerCase()+'", "orgs": [';

					
				}
				for( j=0; j< childDiv_input.length; j++ ) {

						for (var option of childDiv_input[j].options) {
							if (option.selected) {
								json_data += '"'+option.value+'",';
								
							}
					}
				
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
					
					if (json_data[i].name === json_data[j].name)
						flag = 1;
				
				}			
			
			}
			if (flag == 1) {
				alert('Channel names must be unique');
				return false;
			}
			
		window.location.replace("./couchdb.php?channels="+JSON.stringify(json_data)+"");
		return false;
		}

	</script>
	<style>
		div {
			vertical-align:center;
		
		}
	
	</style>
</body>
</html>
