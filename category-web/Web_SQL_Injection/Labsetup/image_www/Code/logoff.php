<!--
SEED Lab: SQL Injection Education Web plateform
Author: Kailiang Ying
Email: kying@syr.edu
-->
<?php
   /* clean session info */
   session_start();
   unset($_SESSION);
   session_destroy();
   session_write_close();
   /* clean browswer cache information */
   header("Cache-Control: no-cache, must-revalidate");
   header("Expires: Mon,  Jun 2016 05:00:00 GMT");
   header("Content-Type: application/xml; charset=utf-8");
   header('Location: index.html');
   die;
?>
