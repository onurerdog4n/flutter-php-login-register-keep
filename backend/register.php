<?php

	 require_once "config.php"; 
	 
	$username = $_POST['username'];
	$password = $_POST['password'];


	$dogrula = $db->prepare("SELECT * FROM login WHERE username=?  ");
	$dogrula->Execute([$username]);
	$engellemail = $dogrula->fetch();

	

		if (strlen(trim($username)) == 0 || strlen(trim($password)) == 0 )
		{
			echo json_encode("Error");
		}else{
		if ($engellemail)
        {

			echo json_encode("Error");
        }
        else
        {
			$query = $db->prepare("INSERT INTO login SET username = ?, password = ?");
			$insert = $query->execute(array( $username, $password ));
			if ( $insert ){
				echo json_encode("Success");
			}

			
		}
	}


?>