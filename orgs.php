<?php
session_start();
if (empty($_GET)) {
	header("Location: ./index.php");
	die("0");
}
else {
	$count = count($_GET) / 3;
	$j = 0;
	
	unset($_SESSION['orderers']); 
	
	for ($i = 1; $i <= $count; $i++) {
		$_SESSION['orderers'][$j][0] = strtolower($_GET['orderer'.$i]);
		$_SESSION['orderers'][$j][1] = $_GET['port'.$i];
		$_SESSION['orderers'][$j][2] = $_GET['orderer_mach'.$i];
		$j++;
	}

}

?>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Setup Panel (5/9)</title>
  
</head>
<body>
	
	<h2>Organizations</h2>
	<form action="./orgs_names.php" medthod="GET">

		<label for="orgs">How many organizations do you want?</label>
		<input type="number" id="orgs" name="orgs" style="width:92px;" min="1" step="1" required><br><br>
		<input type="submit" value="Next">
	</form>
  
</body>
</html>
