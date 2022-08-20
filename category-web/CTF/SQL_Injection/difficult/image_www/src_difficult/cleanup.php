<?php

include_once 'database.php';

function cleanup() 
{
   session_start();
   
   if (connection_aborted()) // The client disconnected
   {
      $conn = dbConnect();
      $conn->query("DROP TABLE IF EXISTS " . $_SESSION['todosTable'] . ", " . $_SESSION['secretTable']);
      $conn->close();
      unset($_SESSION['hits'],
            $_SESSION['todosTable'],
            $_SESSION['secretTable'],
            $_SESSION['todosTableCreated'],
            $_SESSION['secretTableCreated']);
   }
}

?>
