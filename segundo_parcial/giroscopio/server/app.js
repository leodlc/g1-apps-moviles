// Importar las librerías necesarias
const WebSocket = require('ws');
const { exec } = require('child_process');

// Crear un servidor WebSocket
const wss = new WebSocket.Server({ port: 8080 });

console.log('Servidor WebSocket escuchando en el puerto 8080');

// Manejar la conexión de clientes
wss.on('connection', (ws) => {
    console.log('Cliente conectado');

    // Manejar mensajes recibidos
    ws.on('message', (message) => {
        console.log('Mensaje recibido:', message);

        // Parsear el mensaje
        const data = JSON.parse(message);

        // Procesar comandos según el tipo de acción
        if (data.action === 'open_url') {
            // Abrir una página web
            exec(`start ${data.url}`, (error) => {
                if (error) {
                    console.error('Error al abrir la URL:', error);
                    ws.send(JSON.stringify({ status: 'error', message: 'No se pudo abrir la URL' }));
                } else {
                    ws.send(JSON.stringify({ status: 'success', message: 'URL abierta' }));
                }
            });
        } else if (data.action === 'open_app') {
            // Abrir una aplicación
            exec(data.command, (error) => {
                if (error) {
                    console.error('Error al abrir la aplicación:', error);
                    ws.send(JSON.stringify({ status: 'error', message: 'No se pudo abrir la aplicación' }));
                } else {
                    ws.send(JSON.stringify({ status: 'success', message: 'Aplicación abierta' }));
                }
            });
        } else if (data.action === 'play_media') {
            // Reproducir contenido multimedia
            exec(`start ${data.file}`, (error) => {
                if (error) {
                    console.error('Error al reproducir el archivo:', error);
                    ws.send(JSON.stringify({ status: 'error', message: 'No se pudo reproducir el archivo' }));
                } else {
                    ws.send(JSON.stringify({ status: 'success', message: 'Archivo reproducido' }));
                }
            });
        } else {
            ws.send(JSON.stringify({ status: 'error', message: 'Acción no reconocida' }));
        }
    });

    // Manejar la desconexión
    ws.on('close', () => {
        console.log('Cliente desconectado');
    });
});
