import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'alerta_model.dart';

class AlertaDetailPage extends StatelessWidget {
  final Alerta alerta;
  const AlertaDetailPage({super.key, required this.alerta});

  // ---- helpers de texto ----
  String _relativo(DateTime dt) {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);
    final base = DateTime(dt.year, dt.month, dt.day);
    final d = base.difference(hoy).inDays;

    if (d <= 0) return 'Hoy';
    if (d == 1) return 'Mañana';
    return 'En $d días';
  }

  String _hhmm(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}';
  }

  String _fechaLarga(DateTime dt) {
    const meses = [
      'enero','febrero','marzo','abril','mayo','junio',
      'julio','agosto','septiembre','octubre','noviembre','diciembre'
    ];
    const dias = [
      'lunes','martes','miércoles','jueves','viernes','sábado','domingo'
    ];
    final dow = dias[dt.weekday - 1];
    final mes = meses[dt.month - 1];
    return '$dow ${dt.day} de $mes de ${dt.year} • ${_hhmm(dt)}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final relativo = _relativo(alerta.fecha);
    final hora = _hhmm(alerta.fecha);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de alerta'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // Chip relativo
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: cs.primary.withOpacity(.3)),
              ),
              child: Text(
                '$relativo • $hora',
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Título
          Text(
            alerta.titulo,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          // Descripción (si existe)
          if ((alerta.descripcion ?? '').isNotEmpty)
            Text(
              alerta.descripcion!,
              style: TextStyle(
                color: cs.onSurface.withOpacity(.85),
                fontSize: 15,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),

          const SizedBox(height: 18),
          const Divider(height: 1),

          // Bloque info
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.event, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _fechaLarga(alerta.fecha),
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(.88),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.info_outline, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ID: ${alerta.id}',
                  style: TextStyle(color: cs.onSurface.withOpacity(.75)),
                ),
              ),
            ],
          ),
          if ((alerta.route ?? '').isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.link, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ruta vinculada: ${alerta.route}',
                    style: TextStyle(color: cs.onSurface.withOpacity(.75)),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Acciones
          Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => context.pop(),
                  child: const Text('Listo'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final route = alerta.route;
                    if (route != null && route.isNotEmpty) {
                      context.push(route);
                    } else {
                      // Fallback: abre calendario
                      context.push('/calendario');
                    }
                  },
                  child: const Text('Abrir sección'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
