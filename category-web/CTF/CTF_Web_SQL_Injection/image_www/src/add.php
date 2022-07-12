<?php
require("dbconnect.php");

try {
   session_start();
   $conn = dbconnect();
   //if ($conn == false) { exit(); }
   
   $todo = $_POST["todo"];
   if (strlen($todo) > 0) {
      $query = "INSERT INTO " . session_id() . "_ToDos (task) VALUES ('$todo');";
      $conn->multi_query($query);
      while ($conn->more_results()) {
         if (!$conn->next_result()) {
            echo "Error: " . $conn->error; 
         }
      }
   }
   $conn->close();
   
   header('Location: index.php', true, 303);
} catch (Exception $e) {
   exit("Error when inserting task into table 'ToDos': " . $e->getMessage()); 
}
?>
