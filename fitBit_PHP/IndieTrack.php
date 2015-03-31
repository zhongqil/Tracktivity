<?php


$response = array();
$mysqli = new mysqli("localhost", "zhongqil","leewilli", "zhongqil");
		 
		 if(mysqli_connect_errno()){
			 printf("Connect failed: %s\n", mysqli_connect_error());
			 exit();
			 }
        if ($_POST['username'] == "")
		{
	    $titlequery = "SELECT * FROM `FitBit_Indie_Track_Rank`";
		$titleresult = $mysqli->query($titlequery);
		
		while($titlerow = $titleresult->fetch_array(MYSQLI_ASSOC)){
			$response[] = $titlerow;
		}		
		echo json_encode($response);
		} else {
		//$titlequery = "INSERT INTO `FitBit_Indie_Track_Rank` (`Username`, `Competition`, `Team_Name`, `Time_Duration`) VALUES ('$_GET[username]', '$_GET[competition]', '$_GET[teamname]', STR_TO_DATE('$_GET[timeduration]', '%h:%i:%s'))";
		$titlequery = "UPDATE `FitBit_Indie_Track_Rank` SET Time_Duration = '$_POST[timeduration]' WHERE Username = '$_POST[username]'";
		$titleresult = $mysqli->query($titlequery);
		$response = array( '$_POST[username]' => 1, 'b' => 2, 'c' => 3);
		echo json_encode($response);
		}
?>