import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:agroconecta/features/products/presentation/screens/screens.dart';

/// Servicio singleton para notificaciones locales.
class NotificationService {
  NotificationService._();
  static final NotificationService I = NotificationService._();

  /// La inyectas en `main.dart` para poder navegar al tocar la notificación.
  GlobalKey<NavigatorState>? navigatorKey;

  final AwesomeNotifications _plugin = AwesomeNotifications();

  static const String _channelKey = 'alerts';
  static const String _channelName = 'Recordatorios';
  static const String _channelGroupKey = 'alerts_group';

  /// Inicializa canales, pide permisos y registra listeners.
  Future<void> initialize() async {
    await _plugin.initialize(
      null, // usa el ícono por defecto de la app
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

    // Android 13+: pide permiso si no está concedido.
    final allowed = await _plugin.isNotificationAllowed();
    if (!allowed) {
      await _plugin.requestPermissionToSendNotifications();
    }

    // Listeners (API 0.10.x)
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
      onDismissActionReceivedMethod: _onDismissReceivedStatic,
      // Si quieres: onNotificationCreatedMethod: _onCreated,
      //             onNotificationDisplayedMethod: _onDisplayed,
    );
  }

  /// En 0.10.x ya no hay streams que cancelar.
  Future<void> dispose() async {}

  // -------- Programación / cancelación --------

  int _idFor(Alerta a) => a.id.hashCode & 0x7fffffff;

  /// Programa una notificación para la fecha/hora del evento.
  Future<void> scheduleForAlert(Alerta a) async {
    await _plugin.createNotification(
      content: NotificationContent(
        id: _idFor(a),
        channelKey: _channelKey,
        title: a.titulo,
        body: a.descripcion ?? 'Recordatorio',
        notificationLayout: NotificationLayout.Default,
        category: NotificationCategory.Reminder,
        wakeUpScreen: true, // despierta pantalla cuando dispare
        payload: {'alertId': a.id, 'route': a.route ?? ''},
      ),
      schedule: NotificationCalendar.fromDate(
        date: a.fecha,
        allowWhileIdle: true, // dispara aun en idle/doze
      ),
    );
  }

  /// Programa varias alertas en lote.
  Future<void> scheduleForMany(Iterable<Alerta> alerts) async {
    for (final a in alerts) {
      await scheduleForAlert(a);
    }
  }

  /// Programa automáticamente las próximas [days] (default 7) días.
  Future<void> scheduleUpcomingWeek({int days = 7}) async {
    await scheduleForMany(getAlertasProximas(maxDias: days));
  }

  Future<void> cancelForAlert(String id) =>
      _plugin.cancel(id.hashCode & 0x7fffffff);

  Future<void> cancelAll() => _plugin.cancelAll();

  /// Notificación inmediata de prueba (para dev).
  Future<void> showInstantTest() async {
    await _plugin.createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
        channelKey: _channelKey,
        title: '🔔 Prueba de notificación',
        body: 'Toca para abrir el calendario',
        wakeUpScreen: true,
        payload: {'route': '/calendario'},
      ),
    );
  }

  // -------- Navegación al tocar la notificación (instancia) --------
  void _onAction(ReceivedAction action) {
    final payload = action.payload ?? const {};
    final payloadRoute = payload['route'];
    final alertId = payload['alertId'];

    String route = '/home';
    if (payloadRoute != null && payloadRoute.isNotEmpty) {
      route = payloadRoute;
    } else if (alertId != null && alertId.isNotEmpty) {
      route = '/alerta/$alertId';
    }

    final ctx = navigatorKey?.currentContext;
    if (ctx == null) return;

    try {
      GoRouter.of(ctx).push(route);
    } catch (_) {
      Navigator.of(ctx).pushNamed(route);
    }
  }

  // -------- Reprogramación al DESCARTAR (instancia) --------
  Future<void> _onDismissReceived(ReceivedAction action) async {
    final payload = action.payload ?? const {};
    final alertId = payload['alertId'];
    if (alertId == null || alertId.isEmpty) return;

    final a = findAlerta(alertId);
    if (a == null) return;

    // Reprograma para 1 día antes (si aún no pasó).
    final dt = a.fecha.subtract(const Duration(days: 1));
    if (dt.isAfter(DateTime.now())) {
      await _plugin.createNotification(
        content: NotificationContent(
          id: _idFor(a), // mismo id para reemplazar
          channelKey: _channelKey,
          title: '⏰ Recordatorio: ${a.titulo}',
          body: a.descripcion ?? 'Faltan 1 día',
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
          payload: {'alertId': a.id, 'route': a.route ?? ''},
        ),
        schedule: NotificationCalendar.fromDate(
          date: dt,
          allowWhileIdle: true,
        ),
      );
    }
  }

  // ======== Callbacks estáticos requeridos por el plugin ========
  static Future<void> _onActionReceived(ReceivedAction action) async {
    I._onAction(action);
  }

  static Future<void> _onDismissReceivedStatic(ReceivedAction action) async {
    await I._onDismissReceived(action);
  }

  // (Opcionales, solo si los habilitas en setListeners)
  static Future<void> _onCreated(ReceivedNotification n) async {}
  static Future<void> _onDisplayed(ReceivedNotification n) async {}
}
