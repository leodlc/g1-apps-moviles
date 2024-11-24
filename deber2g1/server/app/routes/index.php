<?php

require_once __DIR__ . "/users.php"; // Incluir rutas de usuarios

header("Content-Type: application/json");

// Si quieres manejar una ruta principal para verificar que la API está funcionando correctamente
if ($_SERVER["REQUEST_METHOD"] === "GET" && $_SERVER['REQUEST_URI'] === "/") {
    echo json_encode(["message" => "Welcome to the API"]);
    exit();
}

// Redirigir rutas específicas a sus controladores
$path = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

// Aquí puedes manejar diferentes rutas si decides agregar más endpoints más tarde
switch ($path) {
    case "/users":
        require_once __DIR__ . "/users.php";
        break;
    default:
        http_response_code(404);
        echo json_encode(["error" => "Route not found"]);
}
