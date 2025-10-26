/* Desarrollaremos el menú de usuarios basado en el FIGMA de AgroConecta */

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final String userName; 
  final String zoneName;

  const HomePage({
    super.key,
    this.userName = 'David',
    this.zoneName = 'Jose María Morelos',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- Carrusel ---
  final PageController _pageCtrl = PageController(viewportFraction: 1.0);

  final List<_BannerItem> _banners = const <_BannerItem>[
    _BannerItem(
      image: 'assets/banners/banner_1.jpg',
      title: 'Convocatoria SEDARPE',
      subtitle: 'Apoyo a insumos 2025\nCierra 31/OCT',
    ),
    _BannerItem(
      image: 'assets/banners/banner_2.jpg',
      title: 'Feria Agro 2025',
      subtitle: 'Capacitaciones y stands\n15–17/NOV',
    ),
    _BannerItem(
      image: 'assets/banners/banner_3.jpg',
      title: 'Créditos para el campo',
      subtitle: 'Tasas preferenciales\n¡Infórmate!',
    ),
  ];

  int _current = 0;
  Timer? _autoSlide;

  @override
  void initState() {
    super.initState();
    _autoSlide = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageCtrl.hasClients) return;
      final next = (_current + 1) % _banners.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlide?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Tope sólido bajo el centro de notificaciones
    final overlay = SystemUiOverlayStyle(
      statusBarColor: cs.surface, // usa colorList[0] si quieres tu verde
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // iOS
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          top: true,
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            physics: const ClampingScrollPhysics(),
            children: [
              // --- Saludo ---
              _GreetingCard(name: widget.userName, zone: widget.zoneName),

              const SizedBox(height: 12),

              // --- Título sección ---
              const _SectionTitle(text: 'Importantes'),

              const SizedBox(height: 8),

              // --- Carrusel ---
              SizedBox(
                height: 190,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageCtrl,
                        onPageChanged: (i) => setState(() => _current = i),
                        itemCount: _banners.length,
                        itemBuilder: (_, i) => _BannerCard(item: _banners[i]),
                      ),
                      // Dots
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_banners.length, (i) {
                            final isActive = i == _current;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: isActive ? 22 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: isActive ? 1 : .5,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // --- Título sección ---
              const _SectionTitle(text: 'Accesos rápidos'),

              // --- Accesos rápidos (2x2) ---
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.9,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _QuickAction(
                    color: colorList[0],
                    iconPath: 'assets/icons/megafono.png',
                    title: 'Ver Convocatorias',
                    subtitle: 'Actuales',
                    onTap: () => context.go('/convocatorias'),
                  ),
                  _QuickAction(
                    color: colorList[0],
                    iconPath: 'assets/icons/calendario.png',
                    title: 'Ver eventos',
                    subtitle: 'Calendario',
                    onTap: () => context.go('/calendario'),
                  ),
                  _QuickAction(
                    color: colorList[0],
                    iconPath: 'assets/icons/mentor.png',
                    title: 'Buscar mentor',
                    subtitle: 'Por zona',
                    onTap: () => context.go('/login'),
                  ),
                  _QuickAction(
                    color: colorList[0],
                    iconPath: 'assets/icons/campo.png',
                    title: 'Ver mi Parcela',
                    subtitle: 'Detalles',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const _SectionTitle(text: 'Recordatorios'),

              const SizedBox(height: 8),

              // --- Recordatorio ---
              _ReminderCard(
                title: 'Mañana 09:00 — Taller de compostaje (Dziuché)',
                onDismiss: () {},
                onOpen: () {},
              ),
            ],
          ),
        ),

        // --- Bottom Nav (placeholder, opcional si ya tienes tu Shell) ---
                bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/home'); // Inicio
                break;
              case 1:
                context.go('/apoyos'); // Apoyos
                break;  
              case 2:
                context.go('/evidencias'); // Evidencias
                break;
              case 3:
                context.go('/perfil'); // Perfil
                break;
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.volunteer_activism_outlined),
              selectedIcon: Icon(Icons.volunteer_activism),
              label: 'Apoyos',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              selectedIcon: Icon(Icons.photo_library),
              label: 'Evidencias',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Yo',
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Widgets de la pantalla
// ------------------------------------------------------------

class _GreetingCard extends StatelessWidget {
  final String name;
  final String zone;
  const _GreetingCard({required this.name, required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorList[0],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Hola! $name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Zona: $zone',
            style: TextStyle(
              color: Colors.white.withValues(alpha: .9),
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
        fontSize: 13,
        letterSpacing: .2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BannerItem {
  final String image;
  final String title;
  final String subtitle;
  const _BannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerItem item;
  const _BannerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(item.image, fit: BoxFit.cover),
        // Degradado para legibilidad
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Texto
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: cs.onPrimary.withValues(alpha: .95),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final Color color;
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.color,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(6),
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(color: cs.onPrimary, height: 1.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: cs.onPrimary.withValues(alpha: .9),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final String title;
  final VoidCallback onDismiss;
  final VoidCallback onOpen;

  const _ReminderCard({
    required this.title,
    required this.onDismiss,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titular
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Botones
          Row(
            children: [
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: .12),
                  foregroundColor: Colors.red.shade700,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: const StadiumBorder(),
                ),
                onPressed: onDismiss,
                child: const Text('Descartar'),
              ),
              const SizedBox(width: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: const StadiumBorder(),
                ),
                onPressed: onOpen,
                child: const Text('Abrir Evento'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
