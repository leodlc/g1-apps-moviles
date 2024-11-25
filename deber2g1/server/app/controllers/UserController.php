<?php

require_once __DIR__ . "/../helpers/HandleError.php";
require_once __DIR__ . "/../../config/database.php";
require_once __DIR__ . "/../helpers/JWTHandler.php";

use App\Helpers\JWTHandler;

class UserController {
    private $db;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
    }

    // Método login ya existente
    public function login($data){
        try {
            $query = "SELECT * FROM users WHERE username = :username";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(":username", $data['username']);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user && password_verify($data['password'], $user['password'])) {
                // Credenciales válidas
                $token = JWTHandler::createToken(['id' => $user['id'], 'username' => $user['username']]);
                echo json_encode([
                    'status' => 'success',
                    'message' => "¡Bienvenido, {$user['username']}!",
                    'token' => $token
                ]);
            } else {
                httpError(null, 'Credenciales inválidas', 401);
            }
        } catch (Exception $e) {
            httpError(null, $e->getMessage());
        }
    }

    // Método para obtener todos los usuarios
    public function getAllUsers() {
        try {
            $query = "SELECT * FROM users";
            $stmt = $this->db->prepare($query);
            $stmt->execute();
            $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(["data" => $users]);
        } catch (Exception $e) {
            httpError(null, $e->getMessage());
        }
    }

    // Método para crear un usuario
    public function createUser($data) {
        try {
            $query = "INSERT INTO users (username, email, password) VALUES (:username, :email, :password)";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(":username", $data["username"]);
            $stmt->bindParam(":email", $data["email"]);
            $stmt->bindParam(":password", password_hash($data["password"], PASSWORD_BCRYPT));
            $stmt->execute();
            echo json_encode(["message" => "User created successfully"]);
        } catch (Exception $e) {
            httpError(null, $e->getMessage());
        }
    }

    // Método para eliminar un usuario
    public function deleteUser($id) {
        try {
            $query = "DELETE FROM users WHERE id = :id";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(":id", $id);
            $stmt->execute();
            echo json_encode(["message" => "User deleted successfully"]);
        } catch (Exception $e) {
            httpError(null, $e->getMessage());
        }
    }

    // Método para encontrar un usuario por ID
    public function findByUser($id) {
        try {
            $query = "SELECT * FROM users WHERE id = :id";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(":id", $id);
            $stmt->execute();
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($user) {
                echo json_encode(["data" => $user]);
            } else {
                httpError(null, "Usuario no encontrado", 404);
            }
        } catch (Exception $e) {
            httpError(null, $e->getMessage());
        }
    }

    // Método para actualizar un usuario por ID
    public function update($id, $data) {
        try {
            // Verificar si se proporcionan datos para actualizar
            $query = "UPDATE users SET username = :username, email = :email, password = :password WHERE id = :id";
            $stmt = $this->db->prepare($query);
            $stmt->bindParam(":username", $data["username"]);
            $stmt->bindParam(":email", $data["email"]);
            $stmt->bindParam(":password", password_hash($data["password"], PASSWORD_BCRYPT));
            $stmt->bindParam(":id", $id);
            $stmt->execute();

            if ($stmt->rowCount() > 0) {
                echo json_encode(["message" => "User updated successfully"]);
            } else {
                httpError(null, "No changes made or user not found", 404);
            }
        } catch (Exception $e) {
            httpError(null, $e->getMessage());
        }
    }
}
