
<?php

try {
    $db = new PDO("mysql:host=localhost;dbname=lrmobil", "lrmobil", "9tmf@86Y");
$db->exec("SET NAMES utf8");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  
    
} catch ( PDOException $e ){
    echo "Bir Hata Oluştu: ".$e->getMessage();
}




?>
