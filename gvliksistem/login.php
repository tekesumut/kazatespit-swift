<?php

$servername = "aiheartech.online";
$username = "adminn";
$password = "1223wewe";
$dbname = "kazatespit";
$conn = new mysqli($servername, $username, $password, $dbname);

// Veritabanı bağlantı hatası kontrolü
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

$police = $_POST["policyNumber"];
$sifre = $_POST["password"];

// Sadece poliçe numarasına göre kullanıcının bilgilerini çekiyoruz.
$stmt = $conn->prepare("SELECT * FROM Kullanicilar WHERE Police = ?");
$stmt->bind_param("s", $police);
$stmt->execute();

$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();

    // Burada veritabanından alınan hashlenmiş şifre ile kullanıcının girdiği şifreyi karşılaştırıyoruz.
    if (password_verify($sifre, $user['Sifre'])) {
        echo json_encode(['status' => 'success', 'userID' => (int) $user['id']]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid credentials']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid credentials']);
}

$stmt->close();
$conn->close();

?>
