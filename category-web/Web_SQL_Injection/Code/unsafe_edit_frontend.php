<!--
SEED Lab: SQL Injection Education Web plateform
Author: Kailiang Ying
Email: kying@syr.edu
-->

<!--
SEED Lab: SQL Injection Education Web plateform
Enhancement Version 1.
Date: 13th April 2018
Developer: Kuber Kohli

Update: Implemented Form class from bootstrap to get a nice UI for edit profile form. The php scripts populates the fields with existing values. The logout button triggers a javascript function to redirect to login page.
-->

<html>
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
      <ul class='navbar-nav mr-auto mt-2 mt-lg-0' style='padding-left: 30px;'>
        <li class='nav-item'>
          <a class='nav-link' href='unsafe_home.php'>Home</a>
        </li>
        <li class='nav-item active'>
          <a class='nav-link' href='unsafe_edit_frontend.php'>Edit Profile</a>
        </li>
      </ul>
      <button onclick='logout()' type='button' id='logoffBtn' class='nav-link my-2 my-lg-0'>Logout</button>
    </div>
  </nav>

  <?php
  session_start();
  $uname = $_SESSION['name'];
  // Function to create a sql connection.
  function getDB() {
    $dbhost="localhost";
    $dbuser="seed";
    $dbpass="dees@9DEES";
    $dbname="sqllab_users";

    // Create a DB connection
    $conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error . "\n");
    }
    return $conn;
  }

  // create a connection
  $conn = getDB();
  // Sql query to authenticate the user
  $sql = "SELECT id, name, eid, salary, birth, ssn, phoneNumber, address, email,nickname,Password
  FROM credential
  WHERE name= '$uname'";
  if (!$result = $conn->query($sql)) {
    die('There was an error running the query [' . $conn->error . ']\n');
  }
  /* convert the select return result into array type */
  $return_arr = array();
  while($row = $result->fetch_assoc()){
    array_push($return_arr,$row);
  }

  /* convert the array type to json format and read out*/
  $json_str = json_encode($return_arr);
  $json_a = json_decode($json_str,true);
  $name = $json_a[0]['name'];
  $eid = $json_a[0]['eid'];
  $phoneNumber = $json_a[0]['phoneNumber'];
  $address = $json_a[0]['address'];
  $email = $json_a[0]['email'];
  $pwd = $json_a[0]['Password'];
  $nickname = $json_a[0]['nickname'];
  ?>

  <div class="container  col-lg-4 col-lg-offset-4 text-center" style="padding-top: 50px; text-align: center;">
    <?php
    session_start();
    $name=$_SESSION["name"];
    echo "<h2><b>$name's Profile Edit</b></h1><hr><br>";
    ?>
    <form action="unsafe_edit_backend.php" method="get">
      <div class="form-group row">
        <label for="NickName" class="col-sm-4 col-form-label">NickName</label>
        <div class="col-sm-8">
          <input type="text" class="form-control" id="NickName" name="NickName" placeholder="NickName" <?php echo "value=$nickname";?> >
        </div>
      </div>
      <div class="form-group row">
        <label for="Email" class="col-sm-4 col-form-label">Email</label>
        <div class="col-sm-8">
          <input type="text" class="form-control" id="Email" name="Email" placeholder="Email" <?php echo "value=$email";?>>
        </div>
      </div>
      <div class="form-group row">
        <label for="Address" class="col-sm-4 col-form-label">Address</label>
        <div class="col-sm-8">
          <input type="text" class="form-control" id="Address" name="Address" placeholder="Address" <?php echo "value=$address";?>>
        </div>
      </div>
      <div class="form-group row">
        <label for="PhoneNumber" class="col-sm-4 col-form-label">Phone Number</label>
        <div class="col-sm-8">
          <input type="text" class="form-control" id="PhoneNumber" name="PhoneNumber" placeholder="PhoneNumber" <?php echo "value=$phoneNumber";?>>
        </div>
      </div>
      <div class="form-group row">
        <label for="Password" class="col-sm-4 col-form-label">Password</label>
        <div class="col-sm-8">
          <input type="password" class="form-control" id="Password" name="Password" placeholder="Password">
        </div>
      </div>
      <br>
      <div class="form-group row">
        <div class="col-sm-12">
          <button type="submit" class="btn btn-success btn-lg btn-block">Save</button>
        </div>
      </div>
    </form>
    <br>
    <p class="text-center">
      Copyright &copy; SEED LABs
    </p>
  </div>
  <script type="text/javascript">
  function logout(){
    location.href = "logoff.php";
  }
  </script>
</body>
</html>
