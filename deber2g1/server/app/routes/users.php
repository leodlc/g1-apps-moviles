<?php

require_once __DIR__ . "/../controllers/UserController.php";

$userController = new UserController();

$path = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

if (strpos($path, "/users") === 0) {
    switch ($method) {
        case "GET":
            $userController->getAllUsers();
            break;
        case "POST":
            $inputData = json_decode(file_get_contents("php://input"), true);
            $userController->createUser($inputData);
            break;
        case "DELETE":
            $id = basename($path);
            $userController->deleteUser($id);
            break;
        default:
            httpError(null, "Method not allowed", 405);
    }
}
