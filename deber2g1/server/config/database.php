<?php
class Database {
    private $host = "localhost";
    private $db_name = "users-flutter";
    private $username = "root";
    private $password = ""; // Sin contraseña por defecto para root
    public $conn;

    public function __construct() {
        // Configurar los valores según tu configuración
        $this->host = "localhost";
        $this->db_name = "users-flutter";
        $this->username = "root";
        $this->password = ""; // Coloca la contraseña si la tienes configurada
    }

    public function getConnection() {
        $this->conn = null;
        try {
            // Ahora indicamos el puerto 3307 en la URL de conexión
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";port=3307;dbname=" . $this->db_name,
                $this->username,
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $exception) {
            echo "Database connection error: " . $exception->getMessage();
        }
        return $this->conn;
    }
}
