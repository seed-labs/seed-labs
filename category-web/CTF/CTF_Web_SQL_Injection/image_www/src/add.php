<?php

session_start();

require 'database.php';

$driver = new mysqli_driver();
$driver->report_mode = MYSQLI_REPORT_STRICT; // Throw mysqli_sql_exception for errors instead of warnings

try
{
   $todo = $_POST["todo"];
   
   printf("todo to add: %s<br>\n", $todo);
   
   if (strlen($todo) > 0)
   {
      echo "strlen() check passed<br>\n";
      $conn = dbConnect();
      echo "created database connection<br>\n";
      
      $query = "INSERT INTO " . $_SESSION['todosTable'] . " (task) VALUES ('$todo');";
      printf("query: %s<br>\n", $query);
      
      if ($conn->multi_query($query))
      {
         echo "inside first multi_query() check<br>\n";
         while ($conn->more_results())
         {
            echo "inside while loop<br>\n";
            if ($conn->next_result())
            {
               if ($result = $conn->store_result()) 
               {
                  while ($row = mysqli_fetch_row($result)) 
                  {
                     printf("%s<br>\n", $row[0]);
                  }
               }
            }
         }
      }
      
      $conn->close();
   }
   
   header('Location: index.php', true, 303);
}
catch (mysqli_sql_exception $e)
{
   exit("mysqli error: " . $e->getMessage() . "<br>\n");
}

?>
