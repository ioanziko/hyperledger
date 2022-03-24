<?php
session_start();
if (isset($_GET['machines'])) {

	$machines = intval($_GET['machines']);

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
  <title>Hyperledger Fabric Setup Panel (2/9)</title>
  
</head>
<body>
	
	<h2>Give the Hostname or the Static IP of each machine</h2>
	<form action="./orderer.php" medthod="GET" onsubmit="return valid()">


	<?php
		for ($i=1; $i<=$machines; $i++) {
			
			echo "<label for='host$i'>Machine $i: </label>";
			echo "<input type='text' id='host$i' name='host$i' placeholder='x.x.x.x OR example.com' required><br><br>";
		
		}
	
	
	?>
		<input type="submit" value="Next">
	</form>	  

	<script>
		function valid(){
			var count = <?php echo $machines; ?>;
			var text;
			var text2;
			var flag = 0;
			
			
			for (var i=1; i<count; i++) {

				text = document.getElementById('host'+i).value;

				for (var j=i+1; j<=count; j++) {
					
					text2 = document.getElementById('host'+j).value;
					if (text === text2)
						flag = 1;
					
				}				
		
			}
			
			if (flag == 1) {
				alert('Hostnames, Static IPs must be unique');
				return false;
			}
			else
				return true;
		}
	
	</script>
</body>
</html>
