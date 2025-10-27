// lib/presentation/screens/parcela_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';
//import 'package:agroconecta/presentation/screens/edit_parcela_page.dart' show ParcelaData;

class ParcelaDetailPage extends StatefulWidget {
  const ParcelaDetailPage({super.key});

  @override
  State<ParcelaDetailPage> createState() => _ParcelaDetailPageState();
}

class _ParcelaDetailPageState extends State<ParcelaDetailPage> {
  // Datos mostrados en la pantalla (inicializa con sample o tus valores reales)
  late ParcelaData _data;

  @override
  void initState() {
    super.initState();
    _data = ParcelaData.sample();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final overlay = SystemUiOverlayStyle(
      statusBarColor: colorList[2],
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: colorList[2],
          elevation: 0,
          title: const Text(
            'Detalles de Parcela',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final r = GoRouter.of(context);
              if (r.canPop()) r.pop(); else r.go('/home');
            },
          ),
          actions: [
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // ---------- MAPA ----------
            _MapCard(),
            const SizedBox(height: 12),

            // ---------- RESUMEN ----------
            _CropSummaryCard(
              crop: _data.crop,
              name: _data.name,
              id: 'AGRO-QR-00123',
            ),

            const SizedBox(height: 12),
            Text(
              'Información Clave',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .9),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            _InfoTile(
              icon: Icons.square_foot_outlined,
              title: 'Superficie',
              value: '${_data.hectares.toStringAsFixed(_data.hectares.truncateToDouble() == _data.hectares ? 0 : 2)} Hectáreas',
            ),
            const SizedBox(height: 8),
            _InfoTile(
              icon: Icons.texture_outlined,
              title: 'Tipo de suelo',
              value: _data.soilType,
            ),
            const SizedBox(height: 8),
            _InfoTile(
              icon: Icons.water_drop_outlined,
              title: 'Sistema de Riego',
              value: _data.irrigation,
            ),
            const SizedBox(height: 8),
            _InfoTile(
              icon: Icons.event_outlined,
              title: 'Fecha de siembra',
              value: '${_data.sowingDate.day.toString().padLeft(2,'0')}/${_data.sowingDate.month.toString().padLeft(2,'0')}/${_data.sowingDate.year}',
            ),

            const SizedBox(height: 16),
            // ---------- SALUD DEL CULTIVO / INDICADORES ----------
            Text(
              'Salud del Cultivo',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .9),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const _MiniMetricsRow(),

            const SizedBox(height: 16),
            // ---------- ACCIONES RÁPIDAS ----------
            Text(
              'Acciones rápidas',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .9),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            _QuickActions(),

            const SizedBox(height: 20),
            // ---------- BOTÓN EDITAR ----------
           FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colorList[0],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              // Enviar los datos actuales a la pantalla de edición y esperar el resultado
              final result = await context.push<ParcelaData>('/parcela/editar', extra: _data);
              if (result != null) {
                // Si el usuario guardó cambios, actualizar la UI
                setState(() => _data = result);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Información actualizada')),
                );
              }
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text(
              'Editar información',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Widgets
// ------------------------------------------------------------

class _MapCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 11,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primary.withValues(alpha: .15),
                        cs.primary.withValues(alpha: .08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(Icons.map_outlined,
                      size: 72, color: cs.onSurface.withValues(alpha: .35)),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: .9),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Row(
                        children: [
                          Icon(Icons.my_location,
                              size: 16, color: cs.onSurface),
                          const SizedBox(width: 6),
                          Text(
                            'Ubicación',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.15, 0.2),
                  child: Icon(Icons.location_pin,
                      size: 36, color: colorList[0]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CropSummaryCard extends StatelessWidget {
  final String crop;
  final String name;
  final String id;
  const _CropSummaryCard({
    required this.crop,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorList[0].withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.eco, color: colorList[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      crop,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID: $id',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: .7),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: cs.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .85),
                        fontWeight: FontWeight.w800,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: .7),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MiniMetricsRow extends StatelessWidget {
  const _MiniMetricsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _MetricCard(
            icon: Icons.spa_outlined,
            title: 'Índice de vigor',
            value: '0.72',
            barFill: .72,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            icon: Icons.water_drop_outlined,
            title: 'Humedad suelo',
            value: '61%',
            barFill: .61,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            icon: Icons.cloudy_snowing,
            title: 'Lluvia (7d)',
            value: '18 mm',
            barFill: .45,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final double barFill;
  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.barFill,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: cs.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: .85),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    Container(color: cs.outlineVariant),
                    FractionallySizedBox(
                      widthFactor: barFill.clamp(0.0, 1.0),
                      child: Container(color: colorList[0]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget item(IconData icon, String label, VoidCallback onTap) {
      return Expanded(
        child: Material(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorList[0].withValues(alpha: .12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: colorList[0]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: .85),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        item(Icons.camera_alt_outlined, 'Agregar\nevidencia', () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Próximamente: agregar evidencia')),
          );
        }),
        const SizedBox(width: 10),
        item(Icons.waves_outlined, 'Registrar\nriego', () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Próximamente: registrar riego')),
          );
        }),
        const SizedBox(width: 10),
        item(Icons.add_task_outlined, 'Añadir\ntarea', () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Próximamente: añadir tarea')),
          );
        }),
      ],
    );
  }
}
