<?php
session_start();
$dbPath = './users.db';
$db = new SQLite3($dbPath);

if (!$db) {
    die("Connection failed: " . $db->lastErrorMsg());
}

$db->exec("CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
)");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    $stmt = $db->prepare("SELECT * FROM users WHERE username = :username");
    $stmt->bindValue(':username', $username, SQLITE3_TEXT);
    $result = $stmt->execute();

    if ($user = $result->fetchArray(SQLITE3_ASSOC)) {
        if (password_verify($password, $user['password'])) {
            session_regenerate_id();
            $_SESSION['loggedin'] = true;
            $_SESSION['username'] = $username;
            $_SESSION['id'] = $user['id'];
            header('Location: /panel/index.php');
            exit;
        } else {
            echo "Invalid username or password.";}
    } else {
        echo "Invalid username or password.";}}?>