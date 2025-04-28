<?php
// Start session
session_start();

// Database connection
$servername = "localhost";
$username = "root"; // Change to your database username
$password = ""; // Change to your database password
$dbname = "malecloset"; // Change to your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Process login form
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST["email"];
    $password = $_POST["password"];
    
    // Validate input
    if (empty($email) || empty($password)) {
        echo "Please fill in all fields";
        exit();
    }
    
    // Prepare SQL statement to prevent SQL injection
    $stmt = $conn->prepare("SELECT id, name, email, password FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows == 1) {
        $user = $result->fetch_assoc();
        
        // Verify password
        if (password_verify($password, $user["password"])) {
            // Password is correct, create session
            $_SESSION["user_id"] = $user["id"];
            $_SESSION["user_name"] = $user["name"];
            $_SESSION["user_email"] = $user["email"];
            
            // Redirect to home page
            header("Location: index.html");
            exit();
        } else {
            echo "Invalid email or password";
        }
    } else {
        echo "Invalid email or password";
    }
    
    $stmt->close();
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Male-Closet</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .login-container h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #2c3e50;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .submit-btn:hover {
            background-color: #2980b9;
        }
        
        .login-links {
            text-align: center;
            margin-top: 20px;
        }
        
        .login-links a {
            color: #3498db;
            text-decoration: none;
        }
        
        .login-links a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login to Male-Closet</h2>
        
        <?php
        if ($_SERVER["REQUEST_METHOD"] == "POST") {
            echo '<p class="error-message">Invalid email or password</p>';
        }
        ?>
        
        <form action="login.php" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="submit-btn">Login</button>
        </form>
        
        <div class="login-links">
            <p>Don't have an account? <a href="signup.php">Sign up</a></p>
            <p><a href="forgot-password.php">Forgot password?</a></p>
        </div>
    </div>
</body>
</html>