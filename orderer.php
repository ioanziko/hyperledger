<?php
session_start();
if (empty($_GET)) {
	header("Location: ./index.php");
	die("0");
}
else {
	$i = 0;
	unset($_SESSION['hosts']); 
	foreach($_GET as $key => $value)
	{
		$_SESSION['hosts'][$i] = $value;
		$i++;
	}

}
?>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Setup Panel (3/9)</title>
  
</head>
<body>
	
	<h2>Orderers</h2>
	<form action="./orderer_names.php" medthod="GET">

		<label for="orderer">How many orderers do you want?</label>
		<input type="number" id="orderer" name="orderer" style="width:122px;" min="3" max="<?php echo count($_SESSION['hosts']); ?>" step="1" placeholder="Min 3, Max <?php echo count($_SESSION['hosts']); ?>*" required><br>
		*One orderer max per machine<br><br>
		<input type="submit" value="Next">
	</form>
  
</body>
</html>
