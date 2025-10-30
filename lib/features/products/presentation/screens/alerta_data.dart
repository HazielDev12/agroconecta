// lib/features/products/presentation/screens/alerta_data.dart
import 'alerta_model.dart';

DateTime _atDaysFromNow(int days, {int hour = 9, int minute = 0}) {
  final now = DateTime.now();
  final d = now.add(Duration(days: days));
  return DateTime(d.year, d.month, d.day, hour, minute);
}

/// Fuente “mock” de eventos/recordatorios.
final List<Alerta> kAlertasCalendario = <Alerta>[
  Alerta(
    id: 'evt-sanidad',
    titulo: 'Jornada de sanidad agropecuaria',
    descripcion: 'José María Morelos, Q. Roo',
    fecha: _atDaysFromNow(1, hour: 10),
    route: '/calendario',
  ),
  Alerta(
    id: 'conv-sedarpe-insumos',
    titulo: 'Convocatoria SEDARPE — Apoyo a insumos 2025',
    descripcion: 'Cierra en 3 días · Quintana Roo',
    fecha: _atDaysFromNow(3, hour: 17),
    route: '/convocatorias',
  ),
];

/// Próximos eventos entre **ahora** y `maxDias`.
Iterable<Alerta> getAlertasProximas({int maxDias = 7}) {
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);

  final list = kAlertasCalendario.where((a) {
    // Evita pasados (incluye hoy solo si es a futuro en el mismo día)
    if (a.fecha.isBefore(now)) return false;

    final diaEvento = DateTime(a.fecha.year, a.fecha.month, a.fecha.day);
    final difDias = diaEvento.difference(hoy).inDays;
    return difDias >= 0 && difDias <= maxDias;
  }).toList()
    ..sort((a, b) => a.fecha.compareTo(b.fecha));

  return list;
}

/// Búsqueda por id (para /alerta/:id)
Alerta? findAlerta(String id) {
  try {
    return kAlertasCalendario.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
}
