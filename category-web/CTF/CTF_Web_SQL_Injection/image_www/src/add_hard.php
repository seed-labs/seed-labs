<?php

session_start();

include_once 'database.php';

$driver = new mysqli_driver();
$driver->report_mode = MYSQLI_REPORT_STRICT; // Throw mysqli_sql_exception for errors instead of warnings

try
{
   $todo = $_POST["todo"];
   $showOutput = FALSE;
 
   if (strlen($todo) > 0)
   {
      $conn = dbConnect();
      
      $query = "INSERT INTO " . $_SESSION['todosTable'] . " (task) VALUES ('$todo');";
      
      $conn->multi_query($query);
      
      if ($conn->errno)
      {
         $showOutput = TRUE; // want to show the user output from their query
         printf("mysqli error: %s<br>\n", $conn->error);
      }
      
      $conn->close();
   }
   
   if (!$showOutput)
   {
      header('Location: index.php', true, 303); // go back to the index page
   }
}
catch (mysqli_sql_exception $e)
{
   exit("mysqli exception: " . $e->getMessage() . "<br>\n");
}

?>
