<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
require_once __DIR__ . "/../controllers/UserController.php";
require_once __DIR__ . "/../helpers/JWTHandler.php";

use App\Helpers\JWTHandler;

$userController = new UserController();

$path = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

function isAuthenticated()
{
    $headers = getallheaders();
    if (isset($headers['Authorization'])) {
        $token = str_replace('Bearer ', '', $headers['Authorization']);
        $decoded = JWTHandler::validateToken($token);
        if ($decoded) {
            return $decoded; // Token válido
        }
    }
    httpError(null, "Acceso no autorizado", 401);
    exit;
}

if (strpos($path, "/users") === 0) {
    switch ($method) {
        case "GET":
            //isAuthenticated(); // Proteger la ruta
            $userController->getAllUsers();
            break;
        case "POST":
            $inputData = json_decode(file_get_contents("php://input"), true);
            $userController->createUser($inputData);
            break;
        case "PUT":
            $id = basename($path);  // Extraemos el ID desde la URL
            $inputData = json_decode(file_get_contents("php://input"), true);  // Datos de la solicitud
            isAuthenticated(); // Aseguramos que el usuario esté autenticado
            $userController->update($id, $inputData);  // Pasamos el ID y los datos
            break;
        case "DELETE":
            $id = basename($path);  // Extraemos el ID desde la URL
            $userController->deleteUser($id);
            break;
        default:
            httpError(null, "Method not allowed", 405);
    }
}

if (strpos($path, "/login") === 0) {
    if ($method === "POST") {
        $inputData = json_decode(file_get_contents("php://input"), true);
        $userController->login($inputData);
    } else {
        httpError(null, "Method not allowed", 405);
    }
}

if (strpos($path, "/validate-token") === 0) {
    if ($method === "POST") {
        $headers = getallheaders();
        if (isset($headers['Authorization'])) {
            $token = str_replace('Bearer ', '', $headers['Authorization']);
            $decoded = JWTHandler::validateToken($token);
            
            if ($decoded) {
                echo json_encode(["message" => "Token válido"]);
            } else {
                httpError(null, "Token inválido", 401);
            }
        } else {
            httpError(null, "No se ha proporcionado el token", 400);
        }
    } else {
        httpError(null, "Método no permitido", 405);
    }
}
