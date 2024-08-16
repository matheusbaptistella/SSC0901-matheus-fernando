<?php
if(isset($_POST['ip'])) {
    $ip = $_POST['ip'];
    $output = shell_exec("ping -c 4 " . $ip);
    echo "<pre>$output</pre>";
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Ping Tool</title>
</head>
<body>
    <h1>Ping a Server</h1>
    <form method="post" action="">
        IP Address: <input type="text" name="ip">
        <input type="submit" value="Ping">
    </form>
</body>
</html>
