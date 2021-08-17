<?php
 	require_once "BasicDB.php"; 
	 require_once "config.php"; 
	 
	$username = $_POST['username'];
	$password = $_POST['password'];


	$engellemail = $db->select('login')
        ->where('username', $username)->run();

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
			$kayitol = $db->insert('login')
                    ->set(array(
                    'username' => $username,
                    'password' => $password,
                    
                ));
				if ($kayitol)
                {
					echo json_encode("Success");
				}
		}
	}


?>