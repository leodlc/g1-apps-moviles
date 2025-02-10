import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'vistas/pantalla_login.dart';

// Configuración de Notificaciones Locales en Android
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Función para manejar mensajes en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Notificación en segundo plano: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar Notificaciones Locales en Android
  if (!kIsWeb) {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Configurar el manejador de mensajes en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicación de Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaLogin(),
    );
  }
}

/// **Configura Firebase Cloud Messaging (FCM) en Android**
Future<void> configurarFCMAndroid(
    BuildContext context, String username, String serverIp) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print(
      'Permisos de notificaciones (Android/iOS): ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print("Token FCM obtenido en Android: $token");

  if (token != null) {
    await registrarTokenEnServidor(serverIp, username, token);
  }

  // Manejar notificaciones en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Notificación en PRIMER PLANO:");
    print("Título: ${message.notification?.title}");
    print("Cuerpo: ${message.notification?.body}");

    // Mostrar notificación local en Android
    if (!kIsWeb) {
      mostrarNotificacionLocal(message);
    }

    // Mostrar un SnackBar con la notificación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "${message.notification?.title} - ${message.notification?.body}"),
        duration: Duration(seconds: 3),
      ),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notificación abierta:");
    print("Título: ${message.notification?.title}");
    print("Cuerpo: ${message.notification?.body}");
  });
}

/// **Configura Firebase Cloud Messaging (FCM) en Web**
Future<void> configurarFCMWeb(
    BuildContext context, String username, String serverIp) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();
  String? token = await messaging.getToken();
  print("Token FCM obtenido en Web: $token");

  if (token != null) {
    await registrarTokenEnServidor(serverIp, username, token);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Notificación en PRIMER PLANO (Web): ${message.notification?.title}");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "${message.notification?.title} - ${message.notification?.body}"),
        duration: Duration(seconds: 3),
      ),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Notificación abierta en Web: ${message.notification?.title}");
  });
}

/// **Registra el token FCM en el servidor**
Future<void> registrarTokenEnServidor(
    String serverIp, String username, String token) async {
  try {
    final response = await http.post(
      Uri.parse(
          'http://$serverIp:3000/register-token'), // Usamos la IP ingresada
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "token": token}),
    );

    if (response.statusCode == 200) {
      print("✅ Token registrado en el servidor correctamente.");
    } else {
      print("❌ Error al registrar token en el servidor: ${response.body}");
    }
  } catch (e) {
    print("⚠️ Error de conexión al registrar token: $e");
  }
}

/// **Muestra una notificación local en Android**
void mostrarNotificacionLocal(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'default_channel_id', // ID del canal
    'Mensajes', // Nombre del canal
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // ID de la notificación
    message.notification?.title ?? "Nuevo mensaje",
    message.notification?.body ?? "Tienes un nuevo mensaje",
    platformChannelSpecifics,
  );
}
