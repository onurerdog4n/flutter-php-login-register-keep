
<?php

require_once "config.php"; 



$data = array();
    $query = $db->query('SELECT * FROM veriler', PDO::FETCH_ASSOC);
    foreach($query as $q){

        $data[] = $q;
    }

echo json_encode($data,  JSON_UNESCAPED_UNICODE);



?>
