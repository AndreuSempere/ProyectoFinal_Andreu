import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  //Creamos la instancia de FirebaseMessaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //Añadimos lo necesario para implementar el patrón singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    await requestPermissions();
    await getToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  //Método que permite solicitar permisos al usuari@
  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Permisos concedidos');
    } else {
      debugPrint('Permisos denegados');
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint(
        "Mensaje recibido en segundo plano: ${message.notification?.title}");
  }

  Future<String?> getToken() async {
    try {
      String? firebaseToken = await _firebaseMessaging.getToken();
      if (firebaseToken != null) {
        debugPrint("firebaseToken de FCM: $firebaseToken");
        return firebaseToken;
      } else {
        debugPrint("No se pudo obtener el firebaseToken.");
        return null;
      }
    } catch (e) {
      debugPrint("Error al obtener el firebaseToken: $e");
      return null;
    }
  }
}
