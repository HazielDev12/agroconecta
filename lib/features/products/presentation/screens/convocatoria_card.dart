import 'package:flutter/material.dart';
import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'convocatoria_model.dart';

/// Abre la URL de la convocatoria en el navegador del dispositivo.
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

/// Card grande para carruseles de “Destacadas”
class ConvocatoriaHeroCard extends StatelessWidget {
  final Convocatoria c;
  final VoidCallback? onTap;

  const ConvocatoriaHeroCard({super.key, required this.c, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap ?? () => openConvocatoriaUrl(context, c),
      child: Ink(
        height: 220,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: AssetImage(c.imagen),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradiente legible
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha:.55),
                      Colors.black.withValues(alpha:.15),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
              ),
            ),
            // Texto
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    c.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${c.resumen}\nCierra ${c.cierreCorto}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .95),
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

/// Item compacto para listado
class ConvocatoriaListTile extends StatelessWidget {
  final Convocatoria c;
  final VoidCallback? onTap;

  const ConvocatoriaListTile({super.key, required this.c, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap ?? () => openConvocatoriaUrl(context, c),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(c.imagen, width: 64, height: 64, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      c.resumen,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .75),
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.event, size: 16, color: cs.onSurface.withValues(alpha: .6)),
                        const SizedBox(width: 4),
                        Text('Cierra ${c.cierreCorto}',
                            style: TextStyle(
                              color: cs.onSurface.withValues(alpha: .7),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            )),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorList[0],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                onPressed: () => openConvocatoriaUrl(context, c),
                child: const Text('Ver más'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
