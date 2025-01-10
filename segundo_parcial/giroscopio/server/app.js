// Importar las librerías necesarias
const WebSocket = require('ws');
const { exec } = require('child_process');

// Crear un servidor WebSocket
const wss = new WebSocket.Server({ port: 8080 });

console.log('Servidor WebSocket escuchando en el puerto 8080');

// Contador de comandos para cada cliente
const commandCounts = new Map(); // Map para rastrear conteos por cliente

wss.on('connection', (ws) => {
    console.log('Cliente conectado');

    // Inicializar contador para este cliente
    commandCounts.set(ws, { open_url: 0, open_app: 0, play_media: 0 });

    // Manejar mensajes recibidos
    ws.on('message', (message) => {
        console.log('Mensaje recibido:', message);

        try {
            // Parsear el mensaje
            const data = JSON.parse(message);

            // Obtener el contador actual para este cliente
            const clientCounts = commandCounts.get(ws);

            if (!clientCounts) {
                ws.send(JSON.stringify({ status: 'error', message: 'Error al rastrear comandos' }));
                return;
            }

            // Manejar el comando
            if (data.action === 'open_url') {
                if (clientCounts.open_url >= 4) {
                    ws.send(JSON.stringify({ status: 'error', message: 'Límite de "open_url" alcanzado' }));
                    return;
                }

                // Incrementar el contador y procesar el comando
                clientCounts.open_url++;
                exec(`start ${data.url}`, (error) => {
                    if (error) {
                        console.error('Error al abrir la URL:', error);
                        ws.send(JSON.stringify({ status: 'error', message: 'No se pudo abrir la URL' }));
                    } else {
                        ws.send(JSON.stringify({ status: 'success', message: 'URL abierta' }));
                    }
                });

            } else if (data.action === 'open_app') {
                if (clientCounts.open_app >= 4) {
                    ws.send(JSON.stringify({ status: 'error', message: 'Límite de "open_app" alcanzado' }));
                    return;
                }

                // Incrementar el contador y procesar el comando
                clientCounts.open_app++;
                exec(data.command, (error) => {
                    if (error) {
                        console.error('Error al abrir la aplicación:', error);
                        ws.send(JSON.stringify({ status: 'error', message: 'No se pudo abrir la aplicación' }));
                    } else {
                        ws.send(JSON.stringify({ status: 'success', message: 'Aplicación abierta' }));
                    }
                });

            } else if (data.action === 'play_media') {
                if (clientCounts.play_media >= 4) {
                    ws.send(JSON.stringify({ status: 'error', message: 'Límite de "play_media" alcanzado' }));
                    return;
                }

                // Incrementar el contador y procesar el comando
                clientCounts.play_media++;
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
        } catch (error) {
            console.error('Error al procesar el mensaje:', error);
            ws.send(JSON.stringify({ status: 'error', message: 'Formato de mensaje inválido' }));
        }
    });

    // Manejar la desconexión
    ws.on('close', () => {
        console.log('Cliente desconectado');
        commandCounts.delete(ws); // Eliminar el registro del cliente
    });
});
