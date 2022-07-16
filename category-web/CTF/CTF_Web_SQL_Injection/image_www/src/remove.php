<?php

session_start();

include_once 'database.php';

$driver = new mysqli_driver();
$driver->report_mode = MYSQLI_REPORT_STRICT; // Throw mysqli_sql_exception for errors instead of warnings

try
{
   $conn = dbconnect();
   
   $taskId= $_POST["taskId"];
   
   $query = "DELETE FROM " . $_SESSION['todosTable'] . " WHERE id='$taskId'";
   
   if (!$conn->query($query))
   {
      printf("mysqli error: %s<br>\n", $conn-> error);
   }
     
   $conn->close();
   
   header('Location: index.php', true, 303);
}
catch (mysqli_sql_exception $e)
{
   exit("mysqli error: " . $e->getMessage() . "<br>\n");
}

?>
