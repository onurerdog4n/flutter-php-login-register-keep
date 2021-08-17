<?php 
require_once "BasicDB.php"; 
require_once "config.php"; 

        $data = array();

        $username = $_POST['username'];
        $password = $_POST['password'];

        $dogrula = $db->prepare("SELECT * FROM login WHERE username=? AND password=? ");
        $dogrula->Execute([$username, $password]);
        $girisyap = $dogrula->fetch();

        
    
        if (@$girisyap) {
            $data['msg'] = "Success";
            $data['id'] = $girisyap['id'];
            echo json_encode($data);
        } else {
            $data['msg'] = "error";
            echo json_encode($data);
        }
?>