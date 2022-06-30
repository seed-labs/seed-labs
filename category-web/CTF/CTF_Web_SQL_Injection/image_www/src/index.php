<!DOCTYPE html>
<html lang="en">

   <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="style.css">
      <title>To do list</title>
   </head>

   <body>
      <?php require("dbconnect.php"); ?>
      
      <div class="center">
         <h1 style="text-decoration:underline">To do list</h1>

         <form action="add.php" method="POST" target="_self">
            <label for="todo">New task:</label>
            <input type="text" id="todo" name="todo">
            <input type="submit" value="Add to 'ToDos'">
         </form>

         <br>
        
         <?php
         $max = 0;
         $min = PHP_INT_MAX;
         $conn = dbconnect();
         if ($conn == false) { exit(); }
         $sql = "SELECT id FROM ToDos";
         $result = $conn->query($sql);
         if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
               if ($row["id"] > $max) { $max = $row["id"]; }
               if ($row["id"] < $min) { $min = $row["id"]; }
            }
         }
         ?>
         
         <form action="remove.php" method="POST" target="_self">
            <label for="taskId">Complete task by 'id':</label>
            <input type="number" id="taskId" name="taskId" min=<?php echo $min; ?> max=<?php echo $max; ?>>
            <input type="submit" value="Submit">
         </form>
         
         <br>
         
         <table border="1" align="center">
            <tr>
               <th>id</th>
               <th>task</th>
            </tr>

         <?php
         $sql = "SELECT id, task FROM ToDos";
         $result = $conn->query($sql);
         if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
               echo "<tr><td>" . $row["id"] . "</td><td>" . $row["task"] . "</td></tr>\n";
            }
         }
         $conn->close();
         ?>
         </table>
      </div>
   
   </body>

</html>
