<?php
//include_once 'session.php';
include_once 'database.php';

session_start();

//error_reporting(0); // disable PHP error reporting, will manually check

if (isset($_SESSION['hits']) === true)
{
   $_SESSION['hits']++;
}
else
{
   printf("Initializing session<br>\n");
   $_SESSION['hits'] = 1;
   $_SESSION['todosTableName'] = session_id() . "_ToDos";
   $_SESSION['secretTableName'] = session_id() . "_Secret";
   $_SESSION['todosTableCreated'] = false;
   $_SESSION['secretTableCreated'] = false;
   $_SESSION['bothTablesCreated'] = false;
   $_SESSION['dbConn'] = NULL;
}

var_dump($_SESSION);

if (isset($_SESSION['dbConn']) === false)
{
   $_SESSION['dbConn'] = dbConnect();
}

$conn = dbConnect();
if ($conn === NULL)
{
   exit();
}




//$newSessionStarted = sessStart();
//if ($newSessionStarted === true) {
//   var_dump($_SESSION);
//}
//$_SESSION['hits']++;


printf("bothTablesCreated === %s<br>\n", $_SESSION['bothTablesCreated'] === true ? "true" : "false");

if ($_SESSION['bothTablesCreated'] === false)
{
   //dbInit($conn);
   dbInit($_SESSION['dbConn']);
}
else 
{
   printf("Both tables exist<br>\n");
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
      <p>You have visited this page <?php printf($_SESSION['hits']); ?> times</p>
      
      <div class="center">
         <h1 style="text-decoration:underline">To do list</h1>

         <form action="add.php" method="POST" target="_self">
            <label for="todo">New task:</label>
            <input type="text" id="todo" name="todo">
            <input type="submit" value="Add to 'ToDos'">
         </form>

         <br>
        
         <?php
         session_start();
         $max = 0;
         $min = PHP_INT_MAX;
         $sql = "SELECT id FROM " . $_SESSION['todosTable'];
         $result = $conn->query($sql);
         if ($result->num_rows > 0) 
         {
            while ($row = $result->fetch_assoc()) 
            {
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
         session_start();
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
