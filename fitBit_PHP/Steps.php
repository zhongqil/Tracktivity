<?php

$date = $_GET['date'];

$response = array();
$mysqli = new mysqli("localhost", "zhongqil","leewilli", "zhongqil");
		 
		 if(mysqli_connect_errno()){
			 printf("Connect failed: %s\n", mysqli_connect_error());
			 exit();
			 }
		if($_GET['date'] == ""){	 
			$titlequery = "SELECT Steps FROM `FitBit_Test_Data`";
		$titleresult = $mysqli->query($titlequery);
		
		while($titlerow = $titleresult->fetch_array(MYSQLI_ASSOC)){
			$response[] = $titlerow;
		}
		echo json_encode($response);
} else {
	    $titlequery = "SELECT Steps FROM `FitBit_Test_Data` WHERE Date = DATE('$date')";
		$titleresult = $mysqli->query($titlequery);
		
		while($titlerow = $titleresult->fetch_array(MYSQLI_ASSOC)){
			$response[] = $titlerow;
		}	
		echo json_encode($response);
		}
?>