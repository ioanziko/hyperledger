<?php
session_start();
if (isset($_GET['orderer'])) {

	$orderer = intval($_GET['orderer']);

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
  <title>Hyperledger Fabric Setup Panel (4/9)</title>
  
</head>
<body>
	
	<h2>Give the orderer names and select a machine for each one</h2>
	<form action="./orgs.php" medthod="GET" onsubmit="return valid()">


	<?php
		for ($i=1; $i<=$orderer; $i++) {
			
			echo "<label for='orderer$i'>Orderer $i: </label>";
			echo "<input type='text' id='orderer$i' name='orderer$i' placeholder='lower case' required>";
			echo "<label for='port$i'>, port: </label>";
			echo "<input type='number' id='port$i' name='port$i' style='width:92px;' min='1' step='1' placeholder='Eg 7050' required>";
			echo "<label for='orderer_mach$i'>, machine: </label>";
			echo "<select name='orderer_mach$i' id='orderer_mach$i'>";
					for ($j=0; $j<count($_SESSION['hosts']); $j++) {
						echo "<option value='".$_SESSION['hosts'][$j]."'>".$_SESSION['hosts'][$j]."</option>";
						
					}				

			echo "</select><br><br>";
		}

	
	
	?>

		<input type="submit" value="Next">
	</form>	  
  
	<script>
		function valid(){
			var count = <?php echo $orderer; ?>;
			var select;
			var select2;
			var text;
			var text2;
			var flag = 0;
			
			
			for (var i=1; i<count; i++) {

				select = document.getElementById('orderer_mach'+i).options[document.getElementById('orderer_mach'+i).selectedIndex].value;
				text = document.getElementById('orderer'+i).value;
				
				for (var j=i+1; j<=count; j++) {
					
					select2 = document.getElementById('orderer_mach'+j).options[document.getElementById('orderer_mach'+j).selectedIndex].value;
					text2 = document.getElementById('orderer'+j).value;
					
					if (select === select2 || text === text2 || text.toLowerCase() === "admin" || text2.toLowerCase() === "admin")
						flag = 1;
					
				}				
		
			}
			flag = 0; //REMOVE THAT
			if (flag == 1) {
				alert('One machine must have maximum one orderer AND orderer names must be unique AND name "admin" not allowed');
				return false;
			}
			else
				return true;
		}
	
	</script>
</body>
</html>
