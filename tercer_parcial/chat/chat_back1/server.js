const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const admin = require('firebase-admin');

// Cargar las credenciales de Firebase
const serviceAccount = require('./grupo1-4383c-firebase-adminsdk-fbsvc-f77b8e564e');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://grupo1-4383c.firebaseio.com" // Reemplaza con tu ID de proyecto
});

const db = admin.firestore();
const fcm = admin.messaging();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: '*',
        methods: ['GET', 'POST'],
    },
});
app.use(cors());
app.use(express.json());

/** 
 * Endpoint para obtener mensajes desde Firestore 
 */
app.get('/messages', async (req, res) => {
    try {
        const messagesSnapshot = await db.collection('messages').orderBy('timestamp', 'asc').get();
        const messages = messagesSnapshot.docs.map(doc => doc.data());
        res.json(messages);
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener mensajes' });
    }
});

/** 
 * Endpoint para registrar el token de notificaciones push de los usuarios
 */
app.post('/register-token', async (req, res) => {
    const { username, token } = req.body;

    try {
        await db.collection('users').doc(username).set({ token });
        res.json({ message: 'Token registrado exitosamente' });
    } catch (error) {
        res.status(500).json({ error: 'Error al registrar token' });
    }
});

/** 
 * WebSocket con Socket.IO para enviar y recibir mensajes en tiempo real
 */
io.on('connection', (socket) => {
    console.log('Usuario conectado');

    socket.on('sendMessage', async (data) => {
        console.log('📤 Datos recibidos desde Flutter en el servidor:', data);

        const newMessage = {
            username: data.username || data.usuario, 
            message: data.message || data.mensaje,   
            timestamp: new Date().toISOString(), // <-- Enviar un timestamp en formato ISO
        };

        // Verificar que los datos no sean undefined
        if (!newMessage.username || !newMessage.message) {
            console.error('Error: Datos inválidos', newMessage);
            return;
        }

        try {
            await db.collection('messages').add({
                username: newMessage.username,
                message: newMessage.message,
                timestamp: admin.firestore.FieldValue.serverTimestamp(), // <-- Mantener esto en Firestore
            });

            io.emit('receiveMessage', newMessage); // <-- Enviar un timestamp válido a Flutter
        } catch (error) {
            console.error('Error al guardar mensaje:', error);
        }
    });

    socket.on('disconnect', () => {
        console.log('Usuario desconectado');
    });
});



/** 
 * Función para enviar notificaciones push con Firebase Cloud Messaging (FCM)
 */
async function sendPushNotification(username, message) {
    try {
        const userDoc = await db.collection('users').doc(username).get();
        if (!userDoc.exists) return;

        const userToken = userDoc.data().token;
        if (!userToken) return;

        const payload = {
            notification: {
                title: 'Nuevo mensaje',
                body: `${username}: ${message}`,
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            token: userToken,
        };

        await fcm.send(payload);
        console.log('Notificación enviada');
    } catch (error) {
        console.error('Error enviando notificación:', error);
    }
}

// Iniciar servidor en el puerto 3000
server.listen(3000, () => {
    console.log('Servidor corriendo en http://localhost:3000');
});
