<?php

require_once __DIR__ . '/../vendor/autoload.php';

use Dotenv\Dotenv;
use App\Config\Database;

$dotenv = Dotenv::createImmutable(__DIR__ . '/..');
$dotenv->load();

header('Content-Type: application/json');

try {
    $database = new Database();

    $connection = $database->getConnection();

    $statement = $connection->query('SELECT COUNT(*) AS total FROM roles');

    $result = $statement->fetch();

    echo json_encode([
        'success' => true,
        'message' => 'Database connection successful',
        'roles_count' => (int) $result['total']
    ]);

} catch (Throwable $e) {

    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}