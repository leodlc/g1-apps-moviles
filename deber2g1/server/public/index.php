<?php

// Incluir el archivo de rutas
require_once __DIR__ . "/../app/routes/index.php";

// Aquí podrías manejar las rutas o incluir un controlador general si es necesario
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE');
header('Access-Control-Allow-Headers: Content-Type');
