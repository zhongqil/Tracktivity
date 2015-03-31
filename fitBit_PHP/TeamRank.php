<?php

$response = array();
$mysqli = new mysqli("localhost", "zhongqil","leewilli", "zhongqil");
		 
		 if(mysqli_connect_errno()){
			 printf("Connect failed: %s\n", mysqli_connect_error());
			 exit();
			 }

	if($_POST['teamname'] == "") {
	    $titlequery = "SELECT * FROM `FitBit_Team_Rank`";
		$titleresult = $mysqli->query($titlequery);
		
		while($titlerow = $titleresult->fetch_array(MYSQLI_ASSOC)){
			$response[] = $titlerow;
		}	
		echo json_encode($response);
		} 
   
    if($_POST['teamname'] != "" && $_POST['delete'] == "")
		{
		$titlequery = "INSERT INTO `FitBit_Team_Rank` (`Team_Name`, `Team_Total_Steps`, `Team_Rank`) VALUES ('$_POST[teamname]', 0, Team_Rank = Team_Rank + 1)";
		$titleresult = $mysqli->query($titlequery);
		
		}
		
	if($_POST['teamname'] != "" && $_POST['delete'] != "")
		{
		$titlequery = "DELETE FROM `FitBit_Team_Rank` WHERE Team_Name = '$_POST[teamname]'";
		$titleresult = $mysqli->query($titlequery);
		
		}
?>