<?php

function sessStart() {
   printf("In function sessStart, session_status()==%s<br>\n", session_status());
   if (session_status() === PHP_SESSION_NONE) {
      $lifetime_or_options = 0; // lifetime of session cookie, defined in seconds
      session_set_cookie_params($lifetime_or_options);
      if (session_start()) {
         printf("Started new PHP session.<br>\n");
         printf("The session ID: %s<br>\n", session_id());
         $_SESSION['todosTableName'] = session_id() . "_ToDos";
         $_SESSION['secretTableName'] = session_id() . "_Secret";
         $_SESSION['todosTableCreated'] = false;
         $_SESSION['secretTableCreated'] = false;
         $_SESSION['bothTablesCreated'] = false;
         return true;
      }
      else {
         printf("Failed to start new PHP session!<br>\n");
      }
   }
   else {
      printf("PHP session already exists!<br>\n");
   }
   return false;
}










?>
