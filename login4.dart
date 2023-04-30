<?php
define('HOST', '192.168.100.100:6607');
define('USER', 'pqr');
define('PASS', 'Pensi2021');
define('DB', 'db_application1');
$connect = mysqli_connect(HOST, USER, PASS, DB) or die('Not Connect');
?>


<?php
//For Running
$username = $_POST['username'];
$password = $_POST['password'];

//For Testing
//$username = '081122334455';
//$password = '123456';

$queryResult=$connect->query("SELECT * FROM t_user_belajar
WHERE username='".$username."' and password='".$password."'");
$result=array();

while($fetchData=$queryResult->fetch_assoc()) {
	$result[]=$fetchData;
}

//Send back data to Flutter
    if($result){
        echo json_encode($result);
    }else{
        echo json_encode('');
    }
?>
