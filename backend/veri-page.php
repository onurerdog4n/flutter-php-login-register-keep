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
$layers = array();
$streamArr = array();

//TokenID den user id bulma
$tokenid = $_GET['userId'];
$dogrula = $db->prepare("SELECT * FROM uyeler WHERE token_id=? ");
$dogrula->Execute([$tokenid]);
$idcek = $dogrula->fetch();
$uyeid = $idcek['id'];

// Desc Limit Query
$query = $db->query("SELECT * FROM veriler   where userId = $uyeid Order By id  DESC  Limit $sayfa1,$sayfa_limiti ", PDO::FETCH_ASSOC);



    foreach($query as $q){
        
        $postid = $q['id'];
  
        if($q['post_type'] == 2){

            $layerimg = $db->query("SELECT * FROM veriler inner join post_gallery on post_gallery.post_id = veriler.id where userId = $uyeid and post_id = $postid Order By id  ", PDO::FETCH_ASSOC);
          $count = 0;
            foreach ($layerimg as $layer) {
                $count = $count+1;
                $layers[] = array(
                    'imgcount' => $count,
                    'imgurl' => $layer['pg_url']
                );
            }

            $data = array(
                'id' => $q['id'],
                'userId' => $q['userId'],
                'icerik' => $q['icerik'],
                'post_type' => $q['post_type'],
                'img' => $layers
            );

            unset($layers);

        
           
        }else{

            $data = array(
                'id' => $q['id'],
                'userId' => $q['userId'],
                'icerik' => $q['icerik'],
                'post_type' => $q['post_type']
               
            );

        }

        $streamArr[] = $data;
        
        
    }

echo json_encode($streamArr,  JSON_UNESCAPED_UNICODE);
