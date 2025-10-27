// lib/presentation/screens/parcela_edit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:agroconecta/config/theme/app_theme.dart';

class ParcelaEditPage extends StatefulWidget {
  const ParcelaEditPage({super.key});

  @override
  State<ParcelaEditPage> createState() => _ParcelaEditPageState();
}

class _ParcelaEditPageState extends State<ParcelaEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Estado editable
  final _nombreCtrl = TextEditingController(text: 'Mi Parcela');
  final _superficieCtrl = TextEditingController(text: '10');

  // ID solo lectura (único)
  final String _id = 'AGRO-QR-00123';

  final _cultivoCtrl = TextEditingController(text: 'Maíz');
  String _tipoSuelo = 'Leptosol';
  String _sistemaRiego = 'Temporal';
  DateTime _fechaSiembra = DateTime(2025, 6, 15);

  bool _dirty = false;

  // ---- helper para cerrar teclado en cualquier momento ----
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _cultivoCtrl.dispose();
    _superficieCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFecha() async {
    _dismissKeyboard(); // cerrar teclado antes de abrir el picker
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSiembra,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: 'Selecciona fecha de siembra',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null) {
      setState(() {
        _fechaSiembra = picked;
        _dirty = true;
      });
    }
  }

  String _fechaLegible(DateTime d) {
    const meses = [
      'Enero','Febrero','Marzo','Abril','Mayo','Junio',
      'Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'
    ];
    return '${d.day} de ${meses[d.month - 1]}, ${d.year}';
  }

  Future<bool> _handleSystemBack() async {
    _dismissKeyboard(); // cerrar teclado al intentar volver
    final r = GoRouter.of(context);
    if (_dirty) {
      final salida = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          final cs = Theme.of(ctx).colorScheme;
          return AlertDialog(
            title: const Text('Descartar cambios'),
            content: const Text('Tienes cambios sin guardar. ¿Deseas salir sin guardar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Cancelar', style: TextStyle(color: cs.primary)),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Descartar'),
              ),
            ],
          );
        },
      );
      if (salida != true) return false;
    }

    if (r.canPop()) {
      r.pop();
    } else {
      r.go('/parcela');
    }
    return false; // ya manejamos la navegación
  }

  void _guardar() {
    _dismissKeyboard(); // cerrar teclado al guardar
    if (!_formKey.currentState!.validate()) return;

    // Enviar al backend...
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parcela guardada')),
    );

    _dirty = false;
    final r = GoRouter.of(context);
    if (r.canPop()) {
      r.pop();
    } else {
      r.go('/parcela');
    }
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
      child: WillPopScope(
        onWillPop: _handleSystemBack,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _dismissKeyboard,
          child: Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
              backgroundColor: colorList[2],
              elevation: 0,
              title: const Text(
                'Editar Parcela',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _handleSystemBack,
              ),
            ),
            body: Form(
              key: _formKey,
              onChanged: () => _dirty = true,
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  // ---------- MAPA ----------
                  const _MapCard(),
                  const SizedBox(height: 12),

                  // ---------- DATOS GENERALES ----------
                  const _Section(text: 'Datos de la parcela'),
                  const SizedBox(height: 8),

                  // ID (SOLO LECTURA)
                  _ReadOnlyFieldCard(
                    label: 'ID (único)',
                    value: _id,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 8),

                  _TextFieldCard(
                    label: 'Nombre',
                    controller: _nombreCtrl,
                    hint: 'Ej. Mi Parcela',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),

                  const SizedBox(height: 16),

                  // ---------- CULTIVO / SUPERFICIE ----------
                  const _Section(text: 'Cultivo'),
                  const SizedBox(height: 8),
                  _TextFieldCard(
                    label: 'Cultivo',
                    controller: _cultivoCtrl,
                    hint: 'Ej. Maíz, Papaya, Limón…',
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 8),
                  _TextFieldCard(
                    label: 'Superficie (Hectáreas)',
                    controller: _superficieCtrl,
                    hint: 'Ej. 10',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requerido';
                      final num? n = num.tryParse(v);
                      if (n == null || n <= 0) return 'Ingresa un número válido';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ---------- SUELO / RIEGO ----------
                  const _Section(text: 'Suelo y riego'),
                  const SizedBox(height: 8),
                  _DropdownCard<String>(
                    label: 'Tipo de suelo',
                    value: _tipoSuelo,
                    items: const ['Leptosol','Regosol','Cambisol','Luvisol','Arenoso'],
                    onChanged: (v) {
                      _dismissKeyboard();
                      setState(() => _tipoSuelo = v!);
                    },
                  ),
                  const SizedBox(height: 8),
                  _DropdownCard<String>(
                    label: 'Sistema de riego',
                    value: _sistemaRiego,
                    items: const ['Temporal','Goteo','Aspersión','Gravedad'],
                    onChanged: (v) {
                      _dismissKeyboard();
                      setState(() => _sistemaRiego = v!);
                    },
                  ),

                  const SizedBox(height: 16),

                  // ---------- FECHA ----------
                  const _Section(text: 'Calendario'),
                  const SizedBox(height: 8),
                  _DateFieldCard(
                    label: 'Fecha de siembra',
                    display: _fechaLegible(_fechaSiembra),
                    onTap: _pickFecha,
                  ),

                  const SizedBox(height: 24),

                  // ---------- BOTONES ----------
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: cs.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _handleSystemBack,
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorList[0],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _guardar,
                          child: const Text(
                            'Guardar cambios',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------- Widgets auxiliares ---------------------------

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
                Image.asset('assets/images/cultivo.webp', fit: BoxFit.cover),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String text;
  const _Section({required this.text});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: cs.onSurface.withValues(alpha: .9),
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
    );
  }
}

/// Campo de texto con mejor tipografía y padding.
class _TextFieldCard extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _TextFieldCard({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: .85),
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  letterSpacing: .1,
                )),
            const SizedBox(height: 6),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: cs.onSurface.withValues(alpha: .55),
                  fontSize: 14.5,
                ),
                isDense: true,
                filled: true,
                fillColor: cs.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colorList[0]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Campo solo lectura para mostrar valores (como el ID único).
class _ReadOnlyFieldCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  const _ReadOnlyFieldCard({
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          children: [
            if (icon != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: cs.primary),
              ),
            if (icon != null) const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .75),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
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

/// Dropdown estilizado con cierre de teclado al tocarlo.
class _DropdownCard<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  const _DropdownCard({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: .85),
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  letterSpacing: .1,
                )),
            const SizedBox(height: 6),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: DropdownButtonFormField<T>(
                value: value,
                onChanged: onChanged,
                style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                icon: Icon(Icons.expand_more, color: cs.onSurface.withValues(alpha: .7)),
                dropdownColor: cs.surface,
                items: items
                    .map((e) => DropdownMenuItem<T>(
                          value: e,
                          child: Text(
                            '$e',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: cs.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: colorList[0]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateFieldCard extends StatelessWidget {
  final String label;
  final String display;
  final VoidCallback onTap;
  const _DateFieldCard({
    required this.label,
    required this.display,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            children: [
              Icon(Icons.event, color: cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: .85),
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      display,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: .75),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: cs.onSurface.withValues(alpha: .6)),
            ],
          ),
        ),
      ),
    );
  }
}
