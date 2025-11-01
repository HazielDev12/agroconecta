import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agroconecta/features/auth/presentation/providers/auth_provider.dart';
import 'package:agroconecta/features/shared/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: const Scaffold(
        backgroundColor: Colors.white, // fondo blanco
        body: SafeArea(child: Center(child: _ProfileCard())),
        bottomNavigationBar: BottomNavBarAgro(),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // card blanca para ahora
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: const _ProfileBody(),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brand = const Color(0xFF22A788); // paleta del home
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final nombre = _UserUi.safeFullName(user);
    final subtitle = _UserUi.safeSubtitle(user);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: brand.withValues(alpha: 0.12),
              child: Icon(Icons.person, color: brand, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Mi Actividad (placeholders por ahora)
        Text(
          'Mi Actividad',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: _StatBox(value: '12', label: 'Programas'),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatBox(value: '8', label: 'Conexiones'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _StatBox(value: '5', label: 'Publicaciones'),
        const SizedBox(height: 24),

        // Mi Cuenta
        Text(
          'Mi Cuenta',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        _ActionTile(
          icon: Icons.person_rounded,
          title: 'Editar Perfil',
          onTap: () => context.push('/edit-profile'),
        ),
        _ActionTile(
          icon: Icons.privacy_tip_rounded,
          title: 'Seguridad y Privacidad',
          onTap: () => context.push('/privacy'),
        ),
        _ActionTile(
          icon: Icons.notifications_active_rounded,
          title: 'Notificaciones',
          onTap: () => context.push('/notifications'),
        ),
        const SizedBox(height: 24),

        // Ayuda
        Text(
          'Ayuda',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        _ActionTile(
          icon: Icons.help_center_rounded,
          title: 'Preguntas Frecuentes',
          onTap: () => context.push('/faq'),
        ),
        _ActionTile(
          icon: Icons.support_agent_rounded,
          title: 'Contactar Soporte',
          onTap: () => context.push('/support'),
        ),
        const SizedBox(height: 24),

        // Cerrar sesión
        SizedBox(
          width: double.infinity,
          child: CustomFilledButton(
            text: 'Cerrar Sesión',
            // backgroundColor: const Color(0xFFE8735B),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ),
      ],
    );
  }
}

/* -------------------------- Widgets internos -------------------------- */

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final brand = const Color(0xFF22A788);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: brand.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: brand,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brand = const Color(0xFF22A788);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: brand.withValues(alpha: 0.12)),
      ),
      child: ListTile(
        leading: Icon(icon, color: brand),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

/* ------------------------- Helpers de UI seguras ----------------------- */
class _UserUi {
  static String safeFullName(dynamic u) {
    try {
      final n = (u?.nombre ?? '').toString().trim();
      final ap = (u?.apellidoPaterno ?? '').toString().trim();
      final am = (u?.apellidoMaterno ?? '').toString().trim();
      final full = [n, ap, am].where((e) => e.isNotEmpty).join(' ');
      return full.isEmpty ? 'Usuario' : full;
    } catch (_) {
      return 'Usuario';
    }
  }

  static String safeSubtitle(dynamic u) {
    try {
      final rol = (u?.rolNombre ?? '').toString().trim();
      final muni = (u?.municipioNombre ?? '').toString().trim();
      if (rol.isEmpty && muni.isEmpty) return 'Quintana Roo';
      if (rol.isEmpty) return muni;
      if (muni.isEmpty) return rol;
      return '$rol • $muni';
    } catch (_) {
      return 'Quintana Roo';
    }
  }
}
