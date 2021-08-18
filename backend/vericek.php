
<?php

require_once "config.php"; 

$id = $_GET['userId'];

$data = array();
    $query = $db->query('SELECT * FROM veriler where userId = '. $id .' ', PDO::FETCH_ASSOC);
    foreach($query as $q){

        $data[] = $q;
    }

echo json_encode($data,  JSON_UNESCAPED_UNICODE);



?>
