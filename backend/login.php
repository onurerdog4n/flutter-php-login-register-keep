<?php 

	 $con = mysqli_connect('localhost', 'lrmobil', '9tmf@86Y', 'lrmobil') or die('DATABASE WARN');

        $data = array();

        $username = $_POST['username'];
        $password = $_POST['password'];

        $query = mysqli_query($con, "SELECT * FROM login WHERE username='$username' AND password='$password'");
        $cek = mysqli_fetch_array($query);

        if(isset($cek) && $cek != null){
            $data['msg'] = "Success";
            $data['id'] = $cek['id'];
            echo json_encode($data);
        }else{
            $data['msg'] = "error";
            echo json_encode($data);
        }
    
?>