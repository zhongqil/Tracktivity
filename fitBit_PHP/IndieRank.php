<?php
$userName = $_GET['username'];
$response = array();
$mysqli = new mysqli("localhost", "zhongqil","leewilli", "zhongqil");
		 
		 if(mysqli_connect_errno()){
			 printf("Connect failed: %s\n", mysqli_connect_error());
			 exit();
			 }
if($userName == "") {
	    $titlequery = "SELECT * FROM `FitBit_Indie_Rank`";
	    } else {
	    $titlequery = "SELECT * FROM `FitBit_Indie_Rank` WHERE Username LIKE '$userName'";
	    }
		$titleresult = $mysqli->query($titlequery);
		
		while($titlerow = $titleresult->fetch_array(MYSQLI_ASSOC)){
			$response[] = $titlerow;
		}	
		echo json_encode($response);
?>