<?php
session_start();
if (empty($_GET)) {
	unset($_SESSION['couch']);
}
else {
	$count = count($_GET) / 3;
	$j = 0;
	unset($_SESSION['couch']);
				
	for ($i = 1; $i <= $count; $i++) {
		$_SESSION['couch'][$j][0] = strtolower($_GET['host'.$i]);
		$_SESSION['couch'][$j][1] = $_GET['username'.$i];
		$_SESSION['couch'][$j][2] = $_GET['password'.$i];
		
		$j++;
	}
	

}
  unset($_SESSION["bootstrap"]);
	for ($j=0; $j<count($_SESSION['struct']); $j++) {
   $_SESSION["bootstrap"][$j][0] = $_SESSION['struct'][$j]['name'];
   $_SESSION["bootstrap"][$j][1] = '';
		for ($z=0; $z<count($_SESSION['struct'][$j]['peers']); $z++) {
		
			$_SESSION["bootstrap"][$j][1] = $_SESSION["bootstrap"][$j][1].''.$_SESSION['struct'][$j]['peers'][$z][4].':'.(intval($_SESSION['struct'][$j]['peers'][$z][1])+1).' ';
				
		}
   $_SESSION["bootstrap"][$j][1] = substr($_SESSION["bootstrap"][$j][1], 0, -1);
	}

	
	
	
?>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Setup Panel (9/9)</title>
  
</head>
<body>
	
	<h2>Select CA and provide certification info</h2>
	<form action="./finish.php" medthod="GET" onsubmit="return valid()">

	<?php

			
			echo "<label for='ca' style='font-size:19px;'>Which host will be the ca server? </label>";
			echo "<select name='ca' id='ca'>";
					for ($j=0; $j<count($_SESSION['hosts']); $j++) {
						echo "<option value='".$_SESSION['hosts'][$j]."'>".$_SESSION['hosts'][$j]."</option>";
						
					}				

			echo "</select><br><br>";
		
?>


			<label for='country' style='font-size:19px;'>Country (C): </label>
			<input type='text' id='country' name='country' placeholder='2 Letters' required><br><br>
			<label for='state' style='font-size:19px;'>State (ST): </label>
			<input type='text' id='state' name='state' placeholder='state or province' required><br><br>			
			<label for='locality' style='font-size:19px;'>Locality (L): </label>
			<input type='text' id='locality' name='locality' placeholder='locality or municipality' required><br><br>		
			<label for='org' style='font-size:19px;'>Organization (O): </label>
			<input type='text' id='org' name='org' placeholder='organization' required><br><br>		
			<label for='org_unit' style='font-size:19px;'>Organizational unit (OU): </label>
			<input type='text' id='org_unit' name='org_unit' placeholder='organizational unit' required><br><br>		
	


 


 
  		<input type="submit" value="Finish">
	</form>	 
</body>
</html>
