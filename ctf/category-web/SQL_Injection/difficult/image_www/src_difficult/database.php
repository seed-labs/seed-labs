<?php

function dbConnect() 
{
   session_start();

   $driver = new mysqli_driver();
   $driver->report_mode = MYSQLI_REPORT_STRICT; // Throw mysqli_sql_exception for errors instead of warnings
   
   try
   {
      $hostname = '10.9.0.3';
      $username = 'seed';
      $password = 'dees';
      $database = 'ctf_sql';

      $mysqli = new mysqli($hostname, $username, $password, $database);
      
      if ($mysqli->connect_errno)
      {
         exit("mysqli connection error: " . $mysqli->connect_error . "<br>\n");
      }

      return $mysqli;
   }
   catch (mysqli_sql_exception $e)
   {
      exit("mysqli exception: " . $e->getMessage() . "<br>\n");
   }
}

function dbInit()
{
   session_start();
   
   $driver = new mysqli_driver();
   $driver->report_mode = MYSQLI_REPORT_STRICT; // Throw mysqli_sql_exception for errors instead of warnings
  
   try
   { 
      $conn = dbConnect(); 
      
      if (!$_SESSION['todosTableCreated'])
      {
         // copy the 'initToDos' table
         if ($conn->query("CREATE TABLE IF NOT EXISTS " . $_SESSION['todosTable'] . " LIKE initToDos"))
         {
            if ($conn->query("INSERT " . $_SESSION['todosTable'] . " SELECT * FROM initToDos"))
            {
               $_SESSION['todosTableCreated'] = TRUE;
            }
         }
      }
      
      if (!$_SESSION['completedTableCreated'])
      {
         // copy the 'initCompleted' table
         if ($conn->query("CREATE TABLE IF NOT EXISTS " . $_SESSION['completedTable'] . " LIKE initCompleted"))
         {
            if ($conn->query("INSERT " . $_SESSION['completedTable'] . " SELECT * FROM initCompleted"))
            {
               $_SESSION['completedTableCreated'] = TRUE;
            }
         }
      }

      $conn->close();
   }
   catch (mysqli_sql_exception $e)
   {
      exit("mysqli exception: " . $e->getMessage() . "<br>\n");
   }
}

?>
