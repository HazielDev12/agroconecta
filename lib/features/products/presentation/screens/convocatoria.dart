import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

import 'convocatoria_data.dart';
import 'convocatoria_card.dart';
import 'convocatoria_model.dart';

class ConvocatoriaPage extends StatefulWidget {
  const ConvocatoriaPage({super.key});

  @override
  State<ConvocatoriaPage> createState() => _ConvocatoriaPageState();
}

class _ConvocatoriaPageState extends State<ConvocatoriaPage> {
  final _pageCtrl = PageController(viewportFraction: .92);
  int _pageIndex = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: colorList[2],
        elevation: 0,
        title: const Text('Convocatorias', style: TextStyle(fontWeight: FontWeight.w800)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final r = GoRouter.of(context);
            if (r.canPop()) r.pop(); else r.go('/home');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          // ====== Destacadas ======
          Text('Destacadas',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .9),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              )),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageCtrl,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              itemCount: featuredConvocatorias.length,
              itemBuilder: (_, i) {
                final c = featuredConvocatorias[i];
                return Padding(
                  padding: EdgeInsets.only(right: i == featuredConvocatorias.length - 1 ? 0 : 10),
                  child: ConvocatoriaHeroCard(
                    c: c,
                    onTap: () {
                      // Aquí podrías navegar a detalle si existiera
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // indicadores
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(featuredConvocatorias.length, (i) {
              final active = i == _pageIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? colorList[0] : cs.outlineVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),

          // ====== Lista general ======
          Text('Convocatorias',
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .9),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              )),
          const SizedBox(height: 8),
          ...allConvocatorias.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ConvocatoriaListTile(
                  c: c,
                  onTap: () {
                    // Detalle si lo agregas; por ahora nada.
                  },
                ),
              )),
        ],
      ),
    );
  }
}
