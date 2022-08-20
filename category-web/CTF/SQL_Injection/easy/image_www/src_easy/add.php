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
      
      if ($conn->multi_query($query))
      {
         while ($conn->more_results())
         {
            if ($conn->next_result())
            {
               if ($result = $conn->store_result()) 
               {
                  while ($row = $result->fetch_row()) 
                  {
                     $showOutput = TRUE; // want to show the user output from their query
                     
                     foreach ($row as $item)
                     {
                        echo $item . ' ';
                     }
                     echo "<br>\n";
                  }
               }
            }
         }
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
