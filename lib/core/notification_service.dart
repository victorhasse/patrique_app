import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(iOS: ios),
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );
  }

  Future<void> mostrarNotificacao({
    required int id,
    required String titulo,
    required String corpo,
  }) async {
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id,
      titulo,
      corpo,
      const NotificationDetails(iOS: ios),
    );
  }

  Future<void> agendarLembrete({
    required int hora,
    required int minuto,
  }) async {
    await _plugin.cancelAll();
    await mostrarNotificacao(
      id: 1,
      titulo: '💪 Hora de treinar!',
      corpo: 'Não perca seu streak! Seu treino de hoje está te esperando.',
    );
  }

  Future<void> cancelarTodos() async {
    await _plugin.cancelAll();
  }
}