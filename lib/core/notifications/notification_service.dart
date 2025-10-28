import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:agroconecta/features/products/presentation/screens/alerta_model.dart';
import 'package:agroconecta/features/products/presentation/screens/alerta_data.dart';

/// Servicio singleton para notificaciones locales.
class NotificationService {
  NotificationService._();
  static final NotificationService I = NotificationService._();

  /// La inyectamos en GoRouter (app_router.dart) para poder navegar
  /// al tocar la notificación aunque la app esté en background/terminada.
  GlobalKey<NavigatorState>? navigatorKey;

  final AwesomeNotifications _plugin = AwesomeNotifications();

  static const String _channelKey = 'alerts';
  static const String _channelName = 'Recordatorios';
  static const String _channelGroupKey = 'alerts_group';

  /// Inicializa canales, pide permisos y registra listeners.
  Future<void> initialize() async {
    await _plugin.initialize(
      null, // usa icono default de la app
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: _channelName,
          channelDescription: 'Notificaciones de eventos y recordatorios',
          importance: NotificationImportance.Max,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableVibration: true,
          enableLights: true,
          playSound: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: _channelGroupKey,
          channelGroupName: 'Recordatorios',
        ),
      ],
      debug: kDebugMode,
    );

    final allowed = await _plugin.isNotificationAllowed();
    if (!allowed) {
      await _plugin.requestPermissionToSendNotifications();
    }

    // ===== NUEVO en v0.10.x: listeners (reemplaza actionStream) =====
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,            // tap en notificación
      onDismissActionReceivedMethod: _onDismissReceived,    // swipe/dismiss
      onNotificationCreatedMethod: _onCreated,              // opcional
      onNotificationDisplayedMethod: _onDisplayed,          // opcional
    );
  }

  Future<void> dispose() async {
    // No hay stream que cancelar en v0.10.x
  }

  // -------- Programación / cancelación --------

  int _idFor(Alerta a) => a.id.hashCode & 0x7fffffff;

  /// Programa una notificación en la fecha/hora de la alerta.
  Future<void> scheduleForAlert(Alerta a) async {
    await _plugin.createNotification(
      content: NotificationContent(
        id: _idFor(a),
        channelKey: _channelKey,
        title: a.titulo,
        body: a.descripcion ?? 'Recordatorio',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        payload: {
          'alertId': a.id,
          'route': a.route ?? '',
        },
      ),
      schedule: NotificationCalendar.fromDate(
        date: a.fecha,
        allowWhileIdle: true,
        // preciseAlarm: true, // descomenta si quieres alarmas precisas (Android 12+)
      ),
    );
  }

  /// Programa varias alertas en lote.
  Future<void> scheduleForMany(Iterable<Alerta> alerts) async {
    for (final a in alerts) {
      await scheduleForAlert(a);
    }
  }

  /// Programa automáticamente las próximas N (por defecto, 7) días.
  Future<void> scheduleUpcomingWeek({int days = 7}) async {
    await scheduleForMany(getAlertasProximas(maxDias: days));
  }

  Future<void> cancelForAlert(String id) =>
      _plugin.cancel(id.hashCode & 0x7fffffff);

  Future<void> cancelAll() => _plugin.cancelAll();

  /// Notificación inmediata de prueba (la uso en `main.dart` con `assert`).
  Future<void> showInstantTest() async {
    await _plugin.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
        channelKey: _channelKey,
        title: '🔔 Prueba de notificación',
        body: 'Toca para abrir el calendario',
        payload: {'route': '/calendario'},
      ),
    );
  }

  // -------- Listeners estáticos requeridos por el plugin --------

  static Future<void> _onActionReceived(ReceivedAction action) async {
    final payload = action.payload ?? const {};
    final payloadRoute = payload['route'];
    final alertId = payload['alertId'];

    // Decide adónde navegar
    String route = '/home';
    if (payloadRoute != null && payloadRoute.isNotEmpty) {
      route = payloadRoute;
    } else if (alertId != null && alertId.isNotEmpty) {
      route = '/alerta/$alertId';
    }

    final ctx = NotificationService.I.navigatorKey?.currentContext;
    if (ctx == null) return;

    try {
      GoRouter.of(ctx).push(route);
    } catch (_) {
      Navigator.of(ctx).pushNamed(route);
    }
  }

  static Future<void> _onDismissReceived(ReceivedAction action) async {
    // Aquí podrías reprogramar la alerta para 2 días antes, etc.
    // Por ahora, no hacemos nada.
  }

  static Future<void> _onCreated(ReceivedNotification notification) async {}
  static Future<void> _onDisplayed(ReceivedNotification notification) async {}
}
