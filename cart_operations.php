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
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Set content type to JSON
header('Content-Type: application/json');

// Handle different operations
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    if (!$data) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid data']);
        exit();
    }
    
    $operation = $data['operation'] ?? '';
    
    switch ($operation) {
        case 'add':
            addToCart($conn, $data);
            break;
        case 'update':
            updateCart($conn, $data);
            break;
        case 'remove':
            removeFromCart($conn, $data);
            break;
        case 'clear':
            clearCart();
            break;
        default:
            echo json_encode(['status' => 'error', 'message' => 'Invalid operation']);
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Get cart items
    getCart($conn);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

// Function to add item to cart
function addToCart($conn, $data) {
    $product_id = $data['product_id'] ?? 0;
    $quantity = $data['quantity'] ?? 1;
    $size = $data['size'] ?? '';
    $color = $data['color'] ?? '';
    
    if (!$product_id) {
        echo json_encode(['status' => 'error', 'message' => 'Product ID is required']);
        return;
    }
    
    // Check if product exists and has stock
    $stmt = $conn->prepare("SELECT p.id, p.name, p.price, p.sale_price, pi.image_path, pa.stock 
                           FROM products p 
                           LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.is_primary = 1
                           LEFT JOIN product_attributes pa ON p.id = pa.product_id AND pa.size = ? AND pa.color = ?
                           WHERE p.id = ?");
    $stmt->bind_param("ssi", $size, $color, $product_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Product not found']);
        return;
    }
    
    $product = $result->fetch_assoc();
    
    // Check stock
    if ($product['stock'] < $quantity) {
        echo json_encode(['status' => 'error', 'message' => 'Not enough stock available']);
        return;
    }
    
    // Initialize cart if it doesn't exist
    if (!isset($_SESSION['cart'])) {
        $_SESSION['cart'] = [];
    }
    
    // Check if product already in cart
    $found = false;
    foreach ($_SESSION['cart'] as &$item) {
        if ($item['product_id'] == $product_id && $item['size'] == $size && $item['color'] == $color) {
            // Update quantity
            $item['quantity'] += $quantity;
            $found = true;
            break;
        }
    }
    
    // Add new item if not found
    if (!$found) {
        $_SESSION['cart'][] = [
            'product_id' => $product_id,
            'name' => $product['name'],
            'price' => $product['sale_price'] ? $product['sale_price'] : $product['price'],
            'image' => $product['image_path'],
            'quantity' => $quantity,
            'size' => $size,
            'color' => $color
        ];
    }
    
    echo json_encode(['status' => 'success', 'message' => 'Product added to cart', 'cart' => $_SESSION['cart']]);
}

// Function to update cart item
function updateCart($conn, $data) {
    $index = $data['index'] ?? -1;
    $quantity = $data['quantity'] ?? 0;
    
    if ($index < 0 || !isset($_SESSION['cart'][$index])) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid cart item']);
        return;
    }
    
    if ($quantity <= 0) {
        // Remove item if quantity is 0 or negative
        array_splice($_SESSION['cart'], $index, 1);
        echo json_encode(['status' => 'success', 'message' => 'Item removed from cart', 'cart' => $_SESSION['cart']]);
        return;
    }
    
    // Get product details to check stock
    $product_id = $_SESSION['cart'][$index]['product_id'];
    $size = $_SESSION['cart'][$index]['size'];
    $color = $_SESSION['cart'][$index]['color'];
    
    $stmt = $conn->prepare("SELECT stock FROM product_attributes WHERE product_id = ? AND size = ? AND color = ?");
    $stmt->bind_param("iss", $product_id, $size, $color);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Product variant not found']);
        return;
    }
    
    $product = $result->fetch_assoc();
    
    // Check stock
    if ($product['stock'] < $quantity) {
        echo json_encode(['status' => 'error', 'message' => 'Not enough stock available']);
        return;
    }
    
    // Update quantity
    $_SESSION['cart'][$index]['quantity'] = $quantity;
    
    echo json_encode(['status' => 'success', 'message' => 'Cart updated', 'cart' => $_SESSION['cart']]);
}

// Function to remove item from cart
function removeFromCart($conn, $data) {
    $index = $data['index'] ?? -1;
    
    if ($index < 0 || !isset($_SESSION['cart'][$index])) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid cart item']);
        return;
    }
    
    // Remove item
    array_splice($_SESSION['cart'], $index, 1);
    
    echo json_encode(['status' => 'success', 'message' => 'Item removed from cart', 'cart' => $_SESSION['cart']]);
}

// Function to clear cart
function clearCart() {
    $_SESSION['cart'] = [];
    echo json_encode(['status' => 'success', 'message' => 'Cart cleared', 'cart' => []]);
}

// Function to get cart items
function getCart($conn) {
    if (!isset($_SESSION['cart'])) {
        $_SESSION['cart'] = [];
    }
    
    echo json_encode(['status' => 'success', 'cart' => $_SESSION['cart']]);
}

$conn->close();
?>