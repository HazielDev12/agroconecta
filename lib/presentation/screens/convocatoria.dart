import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

class ConvocatoriaPage extends StatefulWidget {
  const ConvocatoriaPage({super.key});

  @override
  State<ConvocatoriaPage> createState() => _ConvocatoriaPageState();
}

class _ConvocatoriaPageState extends State<ConvocatoriaPage> {
  // --- Carrusel "Destacadas" (igual estilo que HomePage) ---
  final PageController _featuredCtrl = PageController(viewportFraction: 0.92);
  int _current = 0;
  Timer? _autoSlide;

  static const _kAutoSlide = Duration(seconds: 5);
  static const _kSlideDur = Duration(milliseconds: 420);
  static const _kCurve = Curves.easeOutCubic;

  final List<_FeaturedItem> _featured = const [
    _FeaturedItem(
      image: 'assets/banners/banner_2.jpg', // antes: assets/imagenes/...
      title: 'Convocatoria Urgente: Riego Eficiente',
      subtitle: 'Subvención para la implementación de sistemas de riego eficientes',
    ),
    _FeaturedItem(
      image: 'assets/banners/banner_2.jpg',
      title: 'Créditos para pequeños productores',
      subtitle: 'Tasas preferenciales para capital de trabajo',
    ),
    _FeaturedItem(
      image: 'assets/banners/banner_3.jpg',
      title: 'Capacitación en agricultura sostenible',
      subtitle: 'Cursos y asesoría técnica certificada',
    ),
  ];

  final List<_CallItem> _calls = const [
    _CallItem(
      image: 'assets/banners/banner_1.jpg',
      title: 'Riego eficiente',
      subtitle: 'Subvención para la implementación de sistemas de riego',
    ),
    _CallItem(
      image: 'assets/banners/banner_2.jpg',
      title: 'Agricultura sostenible',
      subtitle: 'Apoyo financiero para prácticas agrícolas sostenibles',
    ),
    _CallItem(
      image: 'assets/banners/banner_3.jpg',
      title: 'Modernización de maquinaria',
      subtitle: 'Incentivos para modernización de maquinaria agrícola',
    ),
    _CallItem(
      image: 'assets/banners/banner_1.jpg',
      title: 'Jóvenes emprendedores agrícolas',
      subtitle: 'Convocatoria a presentar proyectos innovadores',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _autoSlide = Timer.periodic(_kAutoSlide, (_) {
      if (!mounted || !_featuredCtrl.hasClients) return;
      final next = (_current + 1) % _featured.length;
      _featuredCtrl.animateToPage(next, duration: _kSlideDur, curve: _kCurve);
    });
  }

  @override
  void dispose() {
    _autoSlide?.cancel();
    _featuredCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // final isDark = theme.brightness == Brightness.dark;

    final overlay = SystemUiOverlayStyle(
      statusBarColor: colorList[0],
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: WillPopScope(
        // Maneja el botón físico/gesto de "back"
        onWillPop: () async {
          if (context.canPop()) {
            context.pop(); // vuelve a la página anterior si existe
          } else {
            context.go('/home'); // si no hay historial, ir al Home
          }
          return false; // ya manejamos la navegación
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            backgroundColor: colorList[2],
            elevation: 0,
            foregroundColor: Colors.black,
            centerTitle: true,
            title: const Text(
              'CONVOCATORIAS',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              physics: const ClampingScrollPhysics(),
              children: [
                _SearchField(
                  hint: 'Buscar convocatorias o palabra clave',
                  onChanged: (q) {
                  },
                ),
                const SizedBox(height: 10),
                _FiltersRow(
                  onCategory: () {},
                  onLocation: () {},
                  onDeadline: () {},
                ),
                const SizedBox(height: 16),
                const _SectionTitle(text: 'Destacadas'),
                const SizedBox(height: 10),

                // --- Carrusel de destacadas (Timer + PageController) ---
                SizedBox(
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: PageView.builder(
                      controller: _featuredCtrl,
                      itemCount: _featured.length,
                      padEnds: false,
                      onPageChanged: (i) => setState(() => _current = i),
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _FeaturedCard(item: _featured[i]),
                      ),
                    ),
                  ),
                ),

                // 👉 Indicador DEBAJO del carrusel
                const SizedBox(height: 8),
                Center(
                  child: _CarouselDots(
                    count: _featured.length,
                    index: _current,
                  ),
                ),


                const SizedBox(height: 16),
                const _SectionTitle(text: 'Convocatorias'),
                const SizedBox(height: 10),

                ..._calls.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CallListTile(
                      item: c,
                      onTap: () {
                        // context.go('/convocatorias/detalle');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// Widgets auxiliares
// ------------------------------------------------------------------

class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const _SearchField({required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.search, color: cs.onSurface.withValues(alpha: .6)),
        isDense: true,
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  final VoidCallback onCategory;
  final VoidCallback onLocation;
  final VoidCallback onDeadline;

  const _FiltersRow({
    required this.onCategory,
    required this.onLocation,
    required this.onDeadline,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget chip(String text, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: .85),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down,
                  size: 18, color: cs.onSurface.withValues(alpha: .7)),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip('Categoría', onCategory),
        chip('Ubicación', onLocation),
        chip('Fecha de cierre', onDeadline),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: cs.onSurface.withValues(alpha: .85),
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: .1,
      ),
    );
  }
}

/*BOTONES DEL CARRUSELL DE CONVOCATORIAS */
class _CarouselDots extends StatelessWidget {
  final int count;
  final int index;
  const _CarouselDots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (i) {
            final active = i == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 6), // + espacio
              width: active ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? cs.onSurface.withValues(alpha: .85)
                    : cs.onSurface.withValues(alpha: .35),
                borderRadius: BorderRadius.circular(100),
              ),
            );
          }),
        ),
      ),
    );
  }
}


// ------------------ Destacadas ---------------------

class _FeaturedItem {
  final String image;
  final String title;
  final String subtitle;
  const _FeaturedItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class _FeaturedCard extends StatelessWidget {
  final _FeaturedItem item;
  const _FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.image, fit: BoxFit.cover),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Descripción
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Text(
              item.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: .8),
                fontSize: 12.5,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Lista de convocatorias -------------------------

class _CallItem {
  final String image;
  final String title;
  final String subtitle;
  const _CallItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class _CallListTile extends StatelessWidget {
  final _CallItem item;
  final VoidCallback onTap;
  const _CallListTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.image,
                  width: 62,
                  height: 62,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .8),
                        fontSize: 12.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colorList[0],
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: onTap,
                child: const Text('Ver más'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
