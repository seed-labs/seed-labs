<!--
SEED Lab: SQL Injection Education Web plateform
Author: Kailiang Ying
Email: kying@syr.edu
-->

<!--
SEED Lab: SQL Injection Education Web plateform
Enhancement Version 1
Date: 12th April 2018
Developer: Kuber Kohli

Update: Implemented the new bootsrap design. Implemented a new Navbar at the top with two menu options for Home and edit profile, with a button to
logout. The profile details fetched will be displayed using the table class of bootstrap with a dark table head theme.

NOTE: please note that the navbar items should appear only for users and the page with error login message should not have any of these items at
all. Therefore the navbar tag starts before the php tag but it end within the php script adding items as required.
-->

<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="css/bootstrap.min.css">
  <link href="css/style_home.css" type="text/css" rel="stylesheet">

  <!-- Browser Tab title -->
  <title>SQLi Lab</title>
</head>
<body>
  <nav class="navbar fixed-top navbar-expand-lg navbar-light" style="background-color: #3EA055;">
    <div class="collapse navbar-collapse" id="navbarTogglerDemo01">
      <a class="navbar-brand" href="unsafe_home.php" ><img src="seed_logo.png" style="height: 40px; width: 200px;" alt="SEEDLabs"></a>

      <?php
      session_start();
      // if the session is new extract the username password from the GET request
      $input_uname = $_GET['username'];
      $input_pwd = $_GET['Password'];
      $hashed_pwd = sha1($input_pwd);

      // check if it has exist login session
      if($input_uname=="" and $hashed_pwd==sha1("") and $_SESSION['name']!="" and $_SESSION['pwd']!=""){
        $input_uname = $_SESSION['name'];
        $hashed_pwd = $_SESSION['pwd'];
      }

      // Function to create a sql connection.
      function getDB() {
        $dbhost="10.9.0.6";
        $dbuser="seed";
        $dbpass="dees";
        $dbname="sqllab_users";
        // Create a DB connection
        $conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
        if ($conn->connect_error) {
          echo "</div>";
          echo "</nav>";
          echo "<div class='container text-center'>";
          die("Connection failed: " . $conn->connect_error . "\n");
          echo "</div>";
        }
        return $conn;
      }

      // create a connection
      $conn = getDB();
      // Sql query to authenticate the user
      $sql = "SELECT id, name, eid, salary, birth, ssn, phoneNumber, address, email,nickname,Password
      FROM credential
      WHERE name= '$input_uname' and Password='$hashed_pwd'";
      if (!$result = $conn->query($sql)) {
        echo "</div>";
        echo "</nav>";
        echo "<div class='container text-center'>";
        die('There was an error running the query [' . $conn->error . ']\n');
        echo "</div>";
      }
      /* convert the select return result into array type */
      $return_arr = array();
      while($row = $result->fetch_assoc()){
        array_push($return_arr,$row);
      }

      /* convert the array type to json format and read out*/
      $json_str = json_encode($return_arr);
      $json_a = json_decode($json_str,true);
      $id = $json_a[0]['id'];
      $name = $json_a[0]['name'];
      $eid = $json_a[0]['eid'];
      $salary = $json_a[0]['salary'];
      $birth = $json_a[0]['birth'];
      $ssn = $json_a[0]['ssn'];
      $phoneNumber = $json_a[0]['phoneNumber'];
      $address = $json_a[0]['address'];
      $email = $json_a[0]['email'];
      $pwd = $json_a[0]['Password'];
      $nickname = $json_a[0]['nickname'];
      if($id!=""){
        // If id exists that means user exists and is successfully authenticated
        drawLayout($id,$name,$eid,$salary,$birth,$ssn,$pwd,$nickname,$email,$address,$phoneNumber);
      }else{
        // User authentication failed
        echo "</div>";
        echo "</nav>";
        echo "<div class='container text-center'>";
        echo "<div class='alert alert-danger'>";
        echo "The account information your provide does not exist.";
        echo "<br>";
        echo "</div>";
        echo "<a href='index.html'>Go back</a>";
        echo "</div>";
        return;
      }
      // close the sql connection
      $conn->close();

      function drawLayout($id,$name,$eid,$salary,$birth,$ssn,$pwd,$nickname,$email,$address,$phoneNumber){
        if($id!=""){
          session_start();
          $_SESSION['id'] = $id;
          $_SESSION['eid'] = $eid;
          $_SESSION['name'] = $name;
          $_SESSION['pwd'] = $pwd;
        }else{
          echo "can not assign session";
        }
        if ($name !="Admin") {
          // If the user is a normal user.
          echo "<ul class='navbar-nav mr-auto mt-2 mt-lg-0' style='padding-left: 30px;'>";
          echo "<li class='nav-item active'>";
          echo "<a class='nav-link' href='unsafe_home.php'>Home <span class='sr-only'>(current)</span></a>";
          echo "</li>";
          echo "<li class='nav-item'>";
          echo "<a class='nav-link' href='unsafe_edit_frontend.php'>Edit Profile</a>";
          echo "</li>";
          echo "</ul>";
          echo "<button onclick='logout()' type='button' id='logoffBtn' class='nav-link my-2 my-lg-0'>Logout</button>";
          echo "</div>";
          echo "</nav>";
          echo "<div class='container col-lg-4 col-lg-offset-4 text-center'>";
          echo "<br><h1><b> $name Profile </b></h1>";
          echo "<hr><br>";
          echo "<table class='table table-striped table-bordered'>";
          echo "<thead class='thead-dark'>";
          echo "<tr>";
          echo "<th scope='col'>Key</th>";
          echo "<th scope='col'>Value</th>";
          echo "</tr>";
          echo "</thead>";
          echo "<tr>";
          echo "<th scope='row'>Employee ID</th>";
          echo "<td>$eid</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>Salary</th>";
          echo "<td>$salary</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>Birth</th>";
          echo "<td>$birth</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>SSN</th>";
          echo "<td>$ssn</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>NickName</th>";
          echo "<td>$nickname</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>Email</th>";
          echo "<td>$email</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>Address</th>";
          echo "<td>$address</td>";
          echo "</tr>";
          echo "<tr>";
          echo "<th scope='row'>Phone Number</th>";
          echo "<td>$phoneNumber</td>";
          echo "</tr>";
          echo "</table>";
        }
        else {
          // if user is admin.
          $conn = getDB();
          $sql = "SELECT id, name, eid, salary, birth, ssn, password, nickname, email, address, phoneNumber
          FROM credential";
          if (!$result = $conn->query($sql)) {
            die('There was an error running the query [' . $conn->error . ']\n');
          }
          $return_arr = array();
          while($row = $result->fetch_assoc()){
            array_push($return_arr,$row);
          }
          $json_str = json_encode($return_arr);
          $json_aa = json_decode($json_str,true);
          $conn->close();
          $max = sizeof($json_aa);
          echo "<ul class='navbar-nav mr-auto mt-2 mt-lg-0' style='padding-left: 30px;'>";
          echo "<li class='nav-item active'>";
          echo "<a class='nav-link' href='unsafe_home.php'>Home <span class='sr-only'>(current)</span></a>";
          echo "</li>";
          echo "<li class='nav-item'>";
          echo "<a class='nav-link' href='unsafe_edit_frontend.php'>Edit Profile</a>";
          echo "</li>";
          echo "</ul>";
          echo "<button onclick='logout()' type='button' id='logoffBtn' class='nav-link my-2 my-lg-0'>Logout</button>";
          echo "</div>";
          echo "</nav>";
          echo "<div class='container'>";
          echo "<br><h1 class='text-center'><b> User Details </b></h1>";
          echo "<hr><br>";
          echo "<table class='table table-striped table-bordered'>";
          echo "<thead class='thead-dark'>";
          echo "<tr>";
          echo "<th scope='col'>Username</th>";
          echo "<th scope='col'>EId</th>";
          echo "<th scope='col'>Salary</th>";
          echo "<th scope='col'>Birthday</th>";
          echo "<th scope='col'>SSN</th>";
          echo "<th scope='col'>Nickname</th>";
          echo "<th scope='col'>Email</th>";
          echo "<th scope='col'>Address</th>";
          echo "<th scope='col'>Ph. Number</th>";
          echo "</tr>";
          echo "</thead>";
          echo "<tbody>";
          for($i=0; $i< $max;$i++){
            //TODO: printout all the data for that users.
            $i_id = $json_aa[$i]['id'];
            $i_name= $json_aa[$i]['name'];
            $i_eid= $json_aa[$i]['eid'];
            $i_salary= $json_aa[$i]['salary'];
            $i_birth= $json_aa[$i]['birth'];
            $i_ssn= $json_aa[$i]['ssn'];
            $i_pwd = $json_aa[$i]['Password'];
            $i_nickname= $json_aa[$i]['nickname'];
            $i_email= $json_aa[$i]['email'];
            $i_address= $json_aa[$i]['address'];
            $i_phoneNumber= $json_aa[$i]['phoneNumber'];
            echo "<tr>";
            echo "<th scope='row'> $i_name</th>";
            echo "<td>$i_eid</td>";
            echo "<td>$i_salary</td>";
            echo "<td>$i_birth</td>";
            echo "<td>$i_ssn</td>";
            echo "<td>$i_nickname</td>";
            echo "<td>$i_email</td>";
            echo "<td>$i_address</td>";
            echo "<td>$i_phoneNumber</td>";
            echo "</tr>";
          }
          echo "</tbody>";
          echo "</table>";
        }
      }
      ?>
      <br><br>
      <div class="text-center">
        <p>
          Copyright &copy; SEED LABs
        </p>
      </div>
    </div>
    <script type="text/javascript">
    function logout(){
      location.href = "logoff.php";
    }
    </script>
  </body>
  </html>
