import 'alerta_model.dart';

/// Utilidad para construir una fecha "hoy + [days]" a la hora/minuto indicados.
DateTime _atDaysFromNow(int days, {int hour = 9, int minute = 0}) {
  final now = DateTime.now();
  final base = DateTime(now.year, now.month, now.day).add(Duration(days: days));
  return DateTime(base.year, base.month, base.day, hour, minute);
}

/// Fuente única mock de alertas/eventos (puedes reemplazar por backend más adelante).
final List<Alerta> kAlertasCalendario = <Alerta>[
  Alerta(
    id: 'evt-sanidad',
    titulo: 'Jornada de sanidad agropecuaria',
    descripcion: 'Capacitación técnica para productores.',
    fecha: _atDaysFromNow(1, hour: 10, minute: 0), // Mañana 10:00
    lugar: 'José María Morelos, Q. Roo',
    route: '/calendario',
  ),
  Alerta(
    id: 'conv-sedarpe-insumos',
    titulo: 'Convocatoria SEDARPE | Apoyo a insumos 2025',
    descripcion: 'Cierre de registro de apoyos.',
    fecha: _atDaysFromNow(3, hour: 17, minute: 0), // En 3 días 17:00
    lugar: 'Quintana Roo',
    route: '/calendario',
  ),
  Alerta(
    id: 'curso-riego-goteo',
    titulo: 'Curso de riego por goteo',
    descripcion: 'Jornada de actualización.',
    fecha: _atDaysFromNow(5, hour: 9, minute: 0), // En 5 días 09:00
    lugar: 'Mérida, Yucatán',
    route: '/calendario',
  ),
  Alerta(
    id: 'feria-innovacion-chetumal',
    titulo: 'Feria de innovación agrícola',
    descripcion: 'Expositores y stands especializados.',
    fecha: _atDaysFromNow(10, hour: 10, minute: 0), // En 10 días 10:00
    lugar: 'Chetumal, Q. Roo',
    route: '/calendario',
  ),
];

/// Alias por compatibilidad si en tu código usabas `kAlertas`.
List<Alerta> get kAlertas => List<Alerta>.unmodifiable(kAlertasCalendario);

/// Busca una alerta por ID. Devuelve null si no existe.
Alerta? findAlerta(String id) {
  try {
    return kAlertasCalendario.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
}

/// Devuelve las alertas entre hoy y `maxDias` (incluidos), ordenadas por fecha.
List<Alerta> getAlertasProximas({int maxDias = 7, DateTime? now}) {
  final n = now ?? DateTime.now();
  final hoy = DateTime(n.year, n.month, n.day);

  final res = kAlertasCalendario.where((a) {
    final base = DateTime(a.fecha.year, a.fecha.month, a.fecha.day);
    final diffDias = base.difference(hoy).inDays;
    return diffDias >= 0 && diffDias <= maxDias;
  }).toList();

  res.sort((a, b) => a.fecha.compareTo(b.fecha));
  return res;
}
