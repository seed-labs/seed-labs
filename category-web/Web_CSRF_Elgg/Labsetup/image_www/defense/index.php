<?php
  setcookie('cookie-normal', 'aaaaaa');
  setcookie('cookie-lax', 'bbbbbb', ['samesite' => 'Lax']);
  setcookie('cookie-strict', 'cccccc', ['samesite' => 'Strict']);
?>

<html>
<head><title>SameSite Cookie Experiment</title></head>
<style>
body{
      background-color: #D4EFDF;
      font-family: Arial, Helvetica, sans-serif;
      margin: 40px;
}
.item { color: blue }
</style>
<body>

<h1>Setting Cookies</h1>

<p>
After visiting this web page, the following three cookies will be 
set on your browser.
<ul>
<li><span class='item'>cookie-normal:</span> normal cookie</li>
<li><span class='item'>cookie-lax:</span> samesite cookie (Lax type)</li>
<li><span class='item'>cookie-strict:</span> samesite cookie (Strict type)</li>
</ul>
</p>

<h2>Experiment A: click <a href="http://www.csrflab-defense.com/testing.html">Link A</a></h2>
<h2>Experiment B: click <a href="http://www.csrflab-attacker.com/testing.html">Link B</a></h2>

</body>
</html>
