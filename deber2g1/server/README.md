# Backend - Gestión de Usuarios

Este proyecto es un backend en PHP para la gestión de usuarios. Está configurado para ejecutarse en un servidor local utilizando **XAMPP**. Sigue las instrucciones a continuación para configurarlo y ejecutarlo correctamente.

## Requisitos

- **XAMPP** instalado (con PHP y MySQL configurados).
- Composer instalado [Instrucciones de instalación](https://getcomposer.org/download/).
- Editor de texto (recomendado: VSCode).
- Postman u otra herramienta para probar APIs.

---

## Configuración del proyecto

### 1. Clonar el repositorio
Clona este repositorio en tu máquina local y navega al directorio del proyecto:

git clone <URL_DEL_REPOSITORIO>
cd <NOMBRE_DEL_PROYECTO>

# Instalar dependencias con Composer
composer install

# Mover archivos a la carpeta pública del servidor
# Para que el proyecto sea accesible desde el navegador, copia el contenido de la carpeta public al directorio htdocs de XAMPP.

# Ejemplo:
# Si tu proyecto está en:
# D:\semestre oct24-mar25\moviles\primer parcial\g1-apps-moviles\deber2g1\server
# cambia el httpd.conf con la ruta especificada en BaseDirectory (es importante agregar public al final):

# "D:/semestre oct24-mar25/moviles/primer parcial/g1-apps-moviles/deber2g1/server/public"

# Cambiar el puerto al 8012
# Con esto el servidor ya estará levantando y se podrá usar el API.

# Rutas:
# GET http://localhost:8012/users/
# POST http://localhost:8012/users/
# PUT http://localhost:8012/users/{id}
# DELETE http://localhost:8012/users/{id}

# Generar JWT:
# POST http://localhost:8012/login/

# raw de ejemplo:
# {
#    "username": "leodlc2",
#    "password": "1234567."
# }
# tiene que ser un usuario que exista en la base de datos

# Validar token:
# POST http://localhost:8012/validate-token

# Para probar en Postman, dirigirse a "Authorization", seleccionar "Bearer token" y pegar el token generado.
