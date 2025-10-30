import 'package:flutter/foundation.dart';

/// Modelo base para una alerta/recordatorio de evento.
/// Mantiene lo mínimo y deja otros campos como opcionales
/// para no romper si aún no existen en tu UI.
@immutable
class Alerta {
  final String id;            // Identificador único
  final String titulo;        // Texto principal que verás en Home/Detalle
  final DateTime fecha;       // Momento del evento
  final String? descripcion;  // Texto ampliado (detalle)
  final String? lugar;        // Lugar opcional (si lo manejas en calendario)
  final String? route;        // Ruta interna (ej. '/calendario' o '/alerta/:id')
  final String? url;          // Enlace externo opcional

  const Alerta({
    required this.id,
    required this.titulo,
    required this.fecha,
    this.descripcion,
    this.lugar,
    this.route,
    this.url,
  });

  /// Días restantes desde [now] hasta el día del evento (0 = hoy, 1 = mañana…)
  int daysUntil({DateTime? now}) {
    final n = now ?? DateTime.now();
    final hoy = DateTime(n.year, n.month, n.day);
    final base = DateTime(fecha.year, fecha.month, fecha.day);
    return base.difference(hoy).inDays;
  }

  /// Formato listo para “Recordatorios”:
  /// "Hoy 09:00 — Título (Lugar)" | "Mañana 09:00 — …" | "En 3 días 09:00 — …"
  String formatReminderTitle({DateTime? now}) {
    final d = daysUntil(now: now);
    final pref = (d <= 0) ? 'Hoy' : (d == 1 ? 'Mañana' : 'En $d días');

    String two(int n) => n.toString().padLeft(2, '0');
    final hora = '${two(fecha.hour)}:${two(fecha.minute)}';
    final showLugar = (lugar != null && lugar!.trim().isNotEmpty) ? ' ($lugar)' : '';

    return '$pref $hora — $titulo$showLugar';
  }

  Alerta copyWith({
    String? id,
    String? titulo,
    DateTime? fecha,
    String? descripcion,
    String? lugar,
    String? route,
    String? url,
  }) {
    return Alerta(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      lugar: lugar ?? this.lugar,
      route: route ?? this.route,
      url: url ?? this.url,
    );
  }

  @override
  String toString() =>
      'Alerta(id: $id, titulo: $titulo, fecha: $fecha, lugar: $lugar)';
}
