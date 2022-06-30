<?php
require("dbconnect.php");

try {
   $conn = dbconnect();
   if ($conn == false) { exit(); }
   
   $todo = $_POST["todo"];
   if (strlen($todo) > 0) {
      $query = "INSERT INTO ToDos (task) VALUES ('$todo');";
      $conn->multi_query($query);
      while ($conn->more_results()) {
         if (!$conn->next_result()) {
            echo "Error: " . $conn->error; 
         }
      }
   }
   $conn->close();
   
   header('Location: index.php', true, 303);
}
catch (Exception $e) {
   echo "Error when inserting task into table 'ToDos': " . $e->getMessage(); 
}
?>
