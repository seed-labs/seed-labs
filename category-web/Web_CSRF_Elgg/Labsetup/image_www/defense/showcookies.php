<html>
<head><title>SameSite Cookie Experiment</title></head>
<style>
body{
      background-color: #D4EFDF;
      font-family: Arial, Helvetica, sans-serif;
      margin: 40px;
}
li { color: blue }
</style>
<body>

<h1>Displaying All Cookies Sent by Browser</h1>

<ul>
<?php
foreach ($_COOKIE as $key=>$val)
  {
    echo '<li><h3>'.$key.'='.$val."</h3></li>\n";
  }
?>
</ul>

<h2>Your request is a <font color='red'>
<?php
if(isset($_COOKIE['cookie-strict'])) {
   echo 'same-site ';
}  
else {
   echo 'cross-site ';
}
?>
</font>
request!
</h2>

</body>
</html>



