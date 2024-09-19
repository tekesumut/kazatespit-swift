<?php
$servername = "aiheartech.online";
$username = "adminn";
$password = "1223wewe";
$dbname = "kazatespit";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// get the values from POST
$userId = $_POST['id'];
$tarih = $_POST['Tarih'];
$saat = $_POST['Saat'];
$koordinat = $_POST['Koordinat'];
$durum = $_POST['Durum'];
$tespit = $_POST['Tespit'];

// prepare and bind
$stmt = $conn->prepare("INSERT INTO Bildirimler (id, Tarih, Saat, Koordinat, Durum, Tespit) VALUES (?, ?, ?, ?, ?, ?)");
if (false === $stmt) {
    die('prepare() failed: ' . htmlspecialchars($conn->error));
}

$bind = $stmt->bind_param("issssi", $userId, $tarih, $saat, $koordinat, $durum, $tespit);
if (false === $bind) {
    die('bind_param() failed: ' . htmlspecialchars($stmt->error));
}

$exec = $stmt->execute();
if (false === $exec) {
    die('execute() failed: ' . htmlspecialchars($stmt->error));
} else {
    echo "New record created successfully";
}

$stmt->close();
$conn->close();
?>
