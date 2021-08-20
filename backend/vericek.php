<?php

require_once "config.php"; 


$data = array();

//TokenID den user id bulma
$tokenid = $_GET['userId'];

$dogrula = $db->prepare("SELECT * FROM uyeler WHERE token_id=? ");
$dogrula->Execute([$tokenid]);
$idcek = $dogrula->fetch();
$uyeid = $idcek['id'];


    $data = array();
    $query = $db->query('SELECT * FROM veriler where userId = '. $uyeid .' ', PDO::FETCH_ASSOC);
    foreach($query as $q){
        $data[] = $q;
        
    }

echo json_encode($data,  JSON_UNESCAPED_UNICODE);

