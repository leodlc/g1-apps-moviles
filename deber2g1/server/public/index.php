<?php

header("Access-Control-Allow-Origin: *"); // Permite solicitudes desde cualquier origen
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE"); // Métodos permitidos
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");

// Manejar la preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
require_once __DIR__ . '/../vendor/autoload.php';


// Cargar variables de entorno
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();

// Mostrar el valor de JWT_SECRET

/* var_dump(file_exists(__DIR__ . '/../.env'));

var_dump(getenv('JWT_SECRET')); */

// Aquí podrías manejar las rutas o incluir un controlador general si es necesario
/* header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE');
header('Access-Control-Allow-Headers: Content-Type'); */

require_once __DIR__ . '/../app/routes/index.php';
