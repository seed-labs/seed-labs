
<?php
require("dbconnect.php");

$conn = dbconnect();
if ($conn == false) { exit(); }

$taskId= $_POST["taskId"];
$query = "DELETE FROM ToDos WHERE id='$taskId'";
$conn->query($query);
$conn->close();

header('Location: index.php', true, 303);
?>
