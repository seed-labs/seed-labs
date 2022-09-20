<?php

session_start();

include_once 'database.php';

$driver = new mysqli_driver();
$driver->report_mode = MYSQLI_REPORT_STRICT; // Throw mysqli_sql_exception for errors instead of warnings

try
{
   $conn = dbconnect();
   
   $taskId= $_POST["taskId"];
 
   $query = sprintf("INSERT INTO %s (task) SELECT task FROM %s WHERE id=%s;", $_SESSION['completedTable'], $_SESSION['todosTable'], $taskId); 
   $query .= sprintf("DELETE FROM %s WHERE id=%s;", $_SESSION['todosTable'], $taskId);
 
   if ($conn->multi_query($query))
   {
      while ($conn->more_results())
      {
         $conn->next_result();
      }
   }
     
   $conn->close();
   
   header('Location: index.php', true, 303);
}
catch (mysqli_sql_exception $e)
{
   exit("mysqli exception: " . $e->getMessage() . "<br>\n");
}

?>
