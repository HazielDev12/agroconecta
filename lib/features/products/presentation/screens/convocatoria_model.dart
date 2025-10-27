import 'package:flutter/foundation.dart';

@immutable
class Convocatoria {
  final String id;
  final String titulo;
  final String resumen;
  final String imagen;
  final bool destacada;

  // Metadatos opcionales
  final String? entidad;
  final DateTime? fechaCierre;
  final String? categoria;
  final String? ubicacion;
  final String? url;

  const Convocatoria({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.imagen,
    this.destacada = false,
    this.entidad,
    this.fechaCierre,
    this.categoria,
    this.ubicacion,
    this.url,
  });

  /// True si no hay fecha (vigente por defecto) o si la fecha aún no pasa.
  bool get estaVigente => fechaCierre == null || fechaCierre!.isAfter(DateTime.now());

  /// Ej. 31/OCT. Si no hay fecha, devuelve '-'.
  String get cierreCorto {
    if (fechaCierre == null) return '-';
    const meses = ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];
    final f = fechaCierre!;
    return '${f.day.toString().padLeft(2, '0')}/${meses[f.month - 1]}';
    }
}
