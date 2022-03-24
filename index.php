<?php
session_start();
unset($_SESSION['ca']);
unset($_SESSION["couch"]);
unset($_SESSION["channels"]);
unset($_SESSION["struct"]);
unset($_SESSION["orderers"]);
unset($_SESSION["hosts"]);
unset($_SESSION["bootstrap"]);
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Hyperledger Fabric Setup Panel (1/9)</title>
  
</head>
<body>
	
	<h2>Hyperledger Fabric Setup Panel</h2>
	<form action="./hosts.php" medthod="GET">

		<label for="machines">How many machines do you have?</label>
		<input type="number" id="machines" name="machines" style="width:62px;" min="3" step="1" placeholder="Min 3" required><br><br>
		<input type="submit" value="Next">
	</form>

  
  
</body>
</html>
