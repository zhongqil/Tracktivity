<?php


$response = array();
$mysqli = new mysqli("localhost", "zhongqil","leewilli", "zhongqil");
		 
		 if(mysqli_connect_errno()){
			 printf("Connect failed: %s\n", mysqli_connect_error());
			 exit();
			 }
        if ($_GET['userId'] != "" && $_POST['delete'] == "")
		{
	    $titlequery = "SELECT * FROM `FitBit_User_Info` WHERE FB_Id = '$_GET[userId]'";
		$titleresult = $mysqli->query($titlequery);
		
		while($titlerow = $titleresult->fetch_array(MYSQLI_ASSOC)){
			$response[] = $titlerow;
		}		
		//$response = array( $_GET['userId'] => 1, 'b' => 2, 'c' => 3);
		echo json_encode($response);
		$_GET['userId'] = "";
		} 
		
		if($_POST['username'] != "" && $_POST['delete'] == "")
		{
		$titlequery = "INSERT INTO `FitBit_User_Info` (`Username`, `FB_Id`, `Team_Name`, `Role`) VALUES ('$_POST[username]', '$_POST[userId]', '$_POST[teamname]', '$_POST[role]')";
		//$titlequery = "UPDATE `FitBit_Indie_Track_Rank` SET Time_Duration = '$_POST[timeduration]' WHERE Username = '$_POST[username]'";
		$titleresult = $mysqli->query($titlequery);
		//$response = array( $_POST['userId'] => 1, 'b' => 2, 'c' => 3);
		//echo json_encode($response);
		$_POST['username'] = "";
		}
		
		if($_POST['delete'] != "")
		{
		   $titlequery = "DELETE FROM `FitBit_User_Info` WHERE FB_Id = '$_POST[userId]'";
		//$titlequery = "UPDATE `FitBit_Indie_Track_Rank` SET Time_Duration = '$_POST[timeduration]' WHERE Username = '$_POST[username]'";
		   $titleresult = $mysqli->query($titlequery);
		   $_POST['delete'] = "";
		}
?>