<?php

function dbConnect()
{
   session_start();
   mysqli_report(MYSQLI_REPORT_OFF); // turn off error reporting/exception throwing for mysqli functions, will manually check for errors
   
   $hostname = '10.9.0.3';
   $username = 'seed';
   $password = 'dees';
   $database = 'ctf_sql';
   
   $conn = new mysqli($hostname, $username, $password, $database);
   
   if ($conn->connect_errno !== 0) // an error occured
   { 
      printf("Error when connecting to database: %s<br>\n", $conn->connect_error);
      $conn = NULL;
   }
   return $conn;
}

function dbInit($mysqliConnection)
{
   session_start();
   
   if ($mysqliConnection === NULL)
   {
      exit();
   }
   
   if (session_status() === PHP_SESSION_ACTIVE)
   {
      printf("todosTableCreated === %s<br>\n", $_SESSION['todosTableCreated'] === true ? "true" : "false");
      if ($_SESSION['todosTableCreated'] === false)
      {
         // copy the 'ToDos' table
         if ($mysqliConnection->query("CREATE TABLE IF NOT EXISTS " . $_SESSION['todosTableName'] . " LIKE ToDos") == true)
         {
            if ($mysqliConnection->query("INSERT " . $_SESSION['todosTableName'] . " SELECT * FROM ToDos") == false)
            {
               printf("Failed to populate table %s: %s<br>\n", $_SESSION["todosTableName"], $mysqliConnection->error);
            }
            else
            {
               $_SESSION['todosTableCreated'] = true;
               printf("todosTableCreated === %s<br>\n", $_SESSION['todosTableCreated'] === true ? "true" : "false");
            }
         }
         else
         {
            printf("Failed to create table %s <br>\n", $_SESSION["todosTableName"]);
         }
      }
      else
      {
         printf("todos table already created<br>\n");
      }
      
      if ($_SESSION['secretTableCreated'] == false)
      {
         // copy the 'Secret' table
         if ($mysqliConnection->query("CREATE TABLE IF NOT EXISTS " . $_SESSION['secretTableName'] . " LIKE Secret") == true)
         {
            if ($mysqliConnection->query("INSERT " . $_SESSION['secretTableName'] . " SELECT * FROM Secret") == false)
            {
               printf("Failed to populate table %s<br>\n", $_SESSION["secretTableName"]);
            }
            else
            {
               $_SESSION['secretTableCreated'] = true;
            }
         }
         else
         {
            printf("Failed to create table %s <br>\n", $_SESSION["secretTableName"]);
         }
      }
      else
      {
         printf("todos table already created<br>\n");
      }

      $_SESSION['bothTablesCreated'] = ($_SESSION['todosTableCreated'] && $_SESSION['secretTableCreated']);
   }
   else
   {
      printf("In dbInit, session not active<br>\n");
   }
}



























?>
