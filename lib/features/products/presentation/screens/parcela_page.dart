// lib/presentation/screens/parcela_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

class ParcelaDetailPage extends StatelessWidget {
  const ParcelaDetailPage({super.key});

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
              if (r.canPop()) {
                r.pop();
              } else {
                r.go('/home');
              }
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: const [
            // ---------- MAPA ----------
            _MapCard(),
            SizedBox(height: 12),

            // ---------- RESUMEN ----------
            _CropSummaryCard(
              crop: 'Maíz',
              name: 'Mi Parcela',
              id: 'AGRO-QR-00123',
            ),

            SizedBox(height: 12),
            _SectionHeader(text: 'Información Clave'),
            SizedBox(height: 8),

            _InfoTile(
              icon: Icons.square_foot_outlined,
              title: 'Superficie',
              value: '10 Hectáreas',
            ),
            SizedBox(height: 8),
            _InfoTile(
              icon: Icons.texture_outlined,
              title: 'Tipo de suelo',
              value: 'Leptosol',
            ),
            SizedBox(height: 8),
            _InfoTile(
              icon: Icons.water_drop_outlined,
              title: 'Sistema de Riego',
              value: 'Temporal',
            ),
            SizedBox(height: 8),
            _InfoTile(
              icon: Icons.event_outlined,
              title: 'Fecha de siembra',
              value: '15 de Junio, 2025',
            ),

            SizedBox(height: 16),
            _SectionHeader(text: 'Salud del Cultivo'),
            SizedBox(height: 8),
            _MiniMetricsRow(),

            SizedBox(height: 20),
            _EditButton(),
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
  const _MapCard();

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
                // Imagen de cultivo / mapa
                Image.asset('assets/images/cultivo.webp', fit: BoxFit.cover),

                // Capa de gradiente suave (sin icono, sin chip y sin pin)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primary.withValues(alpha: .12),
                        cs.primary.withValues(alpha: .06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // 🔻 Se eliminaron:
                // - Positioned con el chip "Ubicación"
                // - Align con el pin (Icons.location_pin)
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
            // Ícono de cultivo
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
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chip de cultivo
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
                  Text(
                    title,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: .85),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
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
            // barra simple
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

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: colorList[0],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => context.go('/editar'),
      icon: const Icon(Icons.edit_outlined),
      label: const Text(
        'Editar información',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: cs.onSurface.withValues(alpha: .9),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}