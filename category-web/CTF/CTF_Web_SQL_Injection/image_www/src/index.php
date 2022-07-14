<?php

session_start();

require 'database.php';

error_reporting(0); // disable PHP error reporting, will manually check

if (isset($_SESSION['hits']))
{
   $_SESSION['hits']++;
}
else
{
   $_SESSION['hits'] = 1;
   $_SESSION['todosTable'] = session_id() . "_ToDos";
   $_SESSION['secretTable'] = session_id() . "_Secret";
   $_SESSION['todosTableCreated'] = FALSE;
   $_SESSION['secretTableCreated'] = FALSE;
}

if (!$_SESSION['todosTableCreated'] || !$_SESSION['secretTableCreated'])
{
   dbInit();
}

?>

<html lang="en">

   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="style.css">
      <title>To do list</title>
   </head>

   <body>
      <p>PHP session ID: <?php echo session_id(); ?></p>
      
      <div class="center">
         <h1 style="text-decoration:underline">To do list</h1>

         <form action="add.php" method="POST" target="_self">
            <label for="todo">New task:</label>
            <input type="text" id="todo" name="todo" placeholder="Task description...">
            <input type="submit" value="Add to 'ToDos'">
         </form>

         <br>
        
         <?php
         //session_start();
         $conn = dbConnect();
         $max = PHP_INT_MIN;
         $min = PHP_INT_MAX;
         $sql = "SELECT id FROM " . $_SESSION['todosTable'];
         $result = $conn->query($sql);
         if ($result->num_rows > 0) 
         {
            while ($row = $result->fetch_assoc()) 
            {
               if ($row["id"] > $max) 
               { 
                  $max = $row["id"]; 
               }
               
               if ($row["id"] < $min) 
               { 
                  $min = $row["id"]; 
               }
            }
         }

         if ($min === PHP_INT_MAX)
         {
            $min = 0;
         }

         if ($max === PHP_INT_MIN)
         {
            $max = 0;
         } 
         //$conn->close();
         ?>
         
         <form action="remove.php" method="POST" target="_self">
            <label for="taskId">Complete task by 'id':</label>
            <input type="number" id="taskId" name="taskId" value=<?php echo $min; ?> min=<?php echo $min; ?> max=<?php echo $max; ?>>
            <input type="submit" value="Submit">
         </form>
         
         <br>
         
         <table border="1" align="center">
            <tr>
               <th>id</th>
               <th>task</th>
            </tr>

         <?php
         //session_start();
         //$conn = dbConnect();
         $sql = "SELECT id, task FROM " . $_SESSION['todosTable'];
         $result = $conn->query($sql);
         if ($result->num_rows > 0) 
         {
            while ($row = $result->fetch_assoc()) 
            {
               echo "<tr><td>" . $row["id"] . "</td><td>" . $row["task"] . "</td></tr>\n";
            }
         }

         $conn->close(); 
         ?>
         </table>
      </div>
   
   </body>

</html>
