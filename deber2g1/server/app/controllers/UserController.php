<?php

require_once __DIR__ . "/../helpers/HandleError.php";
require_once __DIR__ . "/../../config/database.php";

class UserController {
    private $db;

    public function __construct() {
        $database = new Database();
        $this->db = $database->getConnection();
    }

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
}
