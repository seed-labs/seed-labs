<?php
function dbconnect() {
   try {
      $server   = "10.9.0.3";
      $username = "seed";
      $password = "dees";
      $database = "ctf_sql";
      return mysqli_connect($server, $username, $password, $database); # returns either a mysqli object or false
   }
   catch (Exception $e) {
      echo "Error when connecting to database: " . $e->getMessage(); 
   }
   return false;
}
?>
