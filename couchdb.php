<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Setup Panel (8/9)</title>
  
</head>
<body>
	<h2>CouchDB set username, password</h2>
	<span>If CouchDB did not selected, this page will be empty (just press Next). Else, fill in the form.</span><br><br>
	<form action="./ca.php" medthod="GET">

<?php
session_start();
if (isset($_GET['channels'])) {

	unset($_SESSION['channels']); 
	$_SESSION['channels'] = json_decode($_GET['channels'], true);

	
	
	$counter = 1;
	for ($i=0; $i<count($_SESSION['hosts']); $i++) {
	
		$host = $_SESSION['hosts'][$i];
		$couch_found = 0;
		for ($j=0; $j<count($_SESSION['struct']); $j++) {
			for ($z=0; $z<count($_SESSION['struct'][$j]['peers']); $z++) {
		
				if ($_SESSION['struct'][$j]['peers'][$z][4] == $host && $_SESSION['struct'][$j]['peers'][$z][3] == 1)
					$couch_found = 1;
				
			}
		}

		
		

		if ($couch_found == 1) {
			
			echo "<label for='host$counter'>Host: </label>";
			echo "<input type='text' id='host$counter' name='host$counter' value='$host' required readonly>";
			echo "<label for='username$counter'>, username: </label>";
			echo "<input type='text' id='username$counter' name='username$counter' placeholder='Username' required>";
			echo "<label for='username$counter'>, password: </label>";
			echo "<input type='text' id='password$counter' name='password$counter' placeholder='Password' required><br><hr><br>";			
			
			$counter++;
		}
	
	}
	
	
}
else {

	header("Location: ./index.php");
	die("0");
}
?>

	


	<input type="submit" value="Next">
</form>	  
	
</body>
</html>
