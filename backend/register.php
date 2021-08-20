<?php

	 require_once "config.php"; 
	 
	$username = $_POST['username'];
	$password = $_POST['password'];
	$token = md5(uniqid(mt_rand(), true));
	$data = array();
	$dogrula = $db->prepare("SELECT * FROM uyeler WHERE username=?  ");
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
			$query = $db->prepare("INSERT INTO uyeler SET token_id = ?, username = ?, password = ?");
			$insert = $query->execute(array( $token, $username, $password ));
			if ( $insert ){
				$data['msg'] = "Success";
            $data['token_id'] = $token;
            echo json_encode($data);
			}

			
		}
	}


?>