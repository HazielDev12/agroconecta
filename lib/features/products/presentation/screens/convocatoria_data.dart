import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'convocatoria_model.dart';

/// Fuente única de datos (mock). Sustituye por tu backend cuando esté disponible.
final List<Convocatoria> kConvocatorias = <Convocatoria>[
  // --- Destacadas con metadatos adicionales ---
  Convocatoria(
    id: 'sedarpe-cred-peq-prod',
    titulo: 'Créditos para pequeños productores',
    resumen: 'Tasas preferenciales para capital de trabajo',
    entidad: 'SEDARPE • Quintana Roo',
    fechaCierre: DateTime(2025, 10, 31, 23, 59),
    imagen: 'assets/banners/banner_1.jpg',
    destacada: true,
    categoria: 'Créditos',
    ubicacion: 'Quintana Roo',
    url: 'https://www.youtube.com/watch?v=Gpd85y_iTxY&list=PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l&index=3',
  ),
  Convocatoria(
    id: 'apoyo-insumos-2025',
    titulo: 'Convocatoria SEDARPE',
    resumen: 'Apoyo a insumos 2025',
    entidad: 'SEDARPE • Estatal',
    fechaCierre: DateTime(2025, 10, 31, 23, 59),
    imagen: 'assets/banners/banner_3.jpg',
    destacada: true,
    categoria: 'Apoyos',
    ubicacion: 'Estatal',
    url: 'https://www.youtube.com/watch?v=Gpd85y_iTxY&list=PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l&index=3',
  ),
  Convocatoria(
    id: 'curso-riego-goteo',
    titulo: 'Curso de riego por goteo',
    resumen: 'Jornada de actualización (sábado 9:00 a. m.)',
    entidad: 'SEDARPE • Capacitación',
    fechaCierre: DateTime(2025, 7, 22, 23, 59),
    imagen: 'assets/banners/banner_2.jpg',
    destacada: true,
    categoria: 'Capacitación',
    ubicacion: 'Mérida, Yuc.',
    url: 'https://www.youtube.com/watch?v=Gpd85y_iTxY&list=PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l&index=3',
  ),

  // --- Lista general ---
  Convocatoria(
    id: 'riego-eficiente',
    titulo: 'Riego eficiente',
    resumen: 'Subvención para la implementación de sistemas eficientes',
    entidad: 'SEDARPE',
    fechaCierre: DateTime(2025, 8, 30, 23, 59),
    imagen: 'assets/banners/banner_1.jpg',
    categoria: 'Apoyos',
    ubicacion: 'JMM',
    url: 'https://www.youtube.com/watch?v=Gpd85y_iTxY&list=PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l&index=3',
  ),
  Convocatoria(
    id: 'agricultura-sostenible',
    titulo: 'Agricultura sostenible',
    resumen: 'Apoyo financiero para prácticas agrícolas sostenibles',
    entidad: 'SEDARPE',
    fechaCierre: DateTime(2025, 9, 15, 23, 59),
    imagen: 'assets/banners/banner_3.jpg',
    categoria: 'Apoyos',
    ubicacion: 'FCP',
    url: 'https://www.youtube.com/watch?v=Gpd85y_iTxY&list=PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l&index=3',
  ),
  Convocatoria(
    id: 'modernizacion-equipamiento',
    titulo: 'Modernización de equipamiento',
    resumen: 'Incentivos para maquinaria y tecnología',
    entidad: 'SEDARPE',
    fechaCierre: DateTime(2025, 11, 10, 23, 59),
    imagen: 'assets/banners/banner_2.jpg',
    categoria: 'Apoyos',
    ubicacion: 'Chetumal',
    url: 'https://www.youtube.com/watch?v=Gpd85y_iTxY&list=PLefKpFQ8Pvy5aCLAGHD8Zmzsdljos-t2l&index=3',
  ),
];

/// Convocatorias destacadas (solo lectura).
List<Convocatoria> get featuredConvocatorias =>
    kConvocatorias.where((c) => c.destacada).toList(growable: false);

/// Todas las convocatorias (solo lectura).
List<Convocatoria> get allConvocatorias =>
    List<Convocatoria>.unmodifiable(kConvocatorias);

/// Busca una convocatoria por su ID. Devuelve null si no existe.
Convocatoria? findConvocatoria(String id) {
  try {
    return kConvocatorias.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}
//|/ Abre el enlace externo de la convocatoria, si existe.
Future<void> openConvocatoriaUrl(BuildContext context, Convocatoria c) async {
  final link = c.url;
  if (link == null || link.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Esta convocatoria no tiene enlace.')),
    );
    return;
  }

  final uri = Uri.parse(link);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace.')),
    );
  }
}