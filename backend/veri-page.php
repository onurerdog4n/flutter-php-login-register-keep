<?php

require_once "config.php";

// Pagination 
$sayfa = $_GET['sayfa'];
    if ( empty($sayfa) ){
      $sayfa =1;}else{
      $sayfa = $_GET['sayfa']; }
$sayfa_limiti  = 9;

if($sayfa == '' || $sayfa == 1){
    $sayfa1 = 0;
}else{
    $sayfa1 = ($sayfa * $sayfa_limiti) - $sayfa_limiti;
}


// Data ARRAY
$data = array();

//TokenID den user id bulma
$tokenid = $_GET['userId'];
$dogrula = $db->prepare("SELECT * FROM uyeler WHERE token_id=? ");
$dogrula->Execute([$tokenid]);
$idcek = $dogrula->fetch();
$uyeid = $idcek['id'];

// Desc Limit Query
$query = $db->query("SELECT * FROM veriler where userId = $uyeid Order By id  DESC  Limit $sayfa1,$sayfa_limiti ", PDO::FETCH_ASSOC);



    foreach($query as $q){
        $data[] = $q;
        
    }

echo json_encode($data,  JSON_UNESCAPED_UNICODE);

