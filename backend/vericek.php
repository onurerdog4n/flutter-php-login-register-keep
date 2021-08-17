<?php 

    require_once "BasicDB.php"; 
    require_once "config.php"; 

        $data = array();
        $userid = $_POST['userId'];

        $cektim = $db -> query("SELECT * FROM veriler where userId = $userid ", PDO::FETCH_OBJ);
        foreach ($cektim as $cek) { 
            if(isset($cek) && $cek != null){
                $data['msg'] = "Success";
                $data['id'] = $cek->id;
                $data['icerik'] = $cek->icerik;
                
                echo json_encode($data,  JSON_UNESCAPED_UNICODE);
            }else{
                $data['msg'] = "error";
                echo json_encode($data,  JSON_UNESCAPED_UNICODE);
            }
        }


    
    
?>