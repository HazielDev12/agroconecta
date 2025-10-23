import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Colores de marca / UI
  static const Color brandGreen = Color(0xFF22A788);
  static const Color bgGray = Color(0xFFDCE0E0);
  static const Color sectionAccent = Color(0xFFD59C83); // tono salmón del mock

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _curpCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();

  bool _aceptaTerminos = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidosCtrl.dispose();
    _fechaCtrl.dispose();
    _curpCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDeco(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: colorList[2],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Future<void> _pickFecha() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 18, now.month, now.day);
    final first = DateTime(1930);
    final last = now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: 'Selecciona tu fecha de nacimiento',
      locale: const Locale('es', 'MX'),
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null) {
      _fechaCtrl.text = DateFormat('dd/MM/yy').format(picked);
      setState(() {});
    }
  }

  void _registrar() {
    if (!_aceptaTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los Términos y Condiciones.'),
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Integrar con tu API / navegación
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registro enviado ✔')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,
      appBar: AppBar(
        backgroundColor: bgGray,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Crea tu cuenta',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionHeader('Datos Personales'),
                    const SizedBox(height: 10),

                    // Nombre(s)
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: _inputDeco('Nombre (s)', hint: 'Tus nombres'),
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Ingresa tu nombre'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Apellidos
                    TextFormField(
                      controller: _apellidosCtrl,
                      decoration: _inputDeco(
                        'Apellidos',
                        hint: 'Tus apellidos',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Ingresa tus apellidos'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Fecha de nacimiento
                    TextFormField(
                      controller: _fechaCtrl,
                      readOnly: true,
                      decoration: _inputDeco(
                        'Fecha de Nacimiento',
                        hint: 'dd/mm/yy',
                      ),
                      onTap: _pickFecha,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Selecciona tu fecha'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // CURP (MAYÚSCULAS)
                    TextFormField(
                      controller: _curpCtrl,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        LengthLimitingTextInputFormatter(18),
                      ],
                      decoration: _inputDeco(
                        'CURP',
                        hint: 'Clave Única de Registro de Población',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingresa tu CURP';
                        if (v.length != 18) {
                          return 'La CURP debe tener 18 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 22),
                    _SectionHeader('Información de Contacto'),
                    const SizedBox(height: 10),

                    // Teléfono
                    TextFormField(
                      controller: _telefonoCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: _inputDeco(
                        'Número de Teléfono',
                        hint: '10 dígitos',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingresa tu número';
                        if (v.length != 10) return 'Deben ser 10 dígitos';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Correo
                    TextFormField(
                      controller: _correoCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDeco(
                        'Correo Electrónico',
                        hint: 'ejemplo@correo.com',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingresa tu correo';
                        final reg = RegExp(
                          r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
                        );
                        if (!reg.hasMatch(v)) return 'Correo inválido';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Aviso de privacidad (parrafo)
                    const _AvisoPrivacidad(),

                    const SizedBox(height: 8),

                    // Checkbox términos
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _aceptaTerminos,
                          activeColor: brandGreen,
                          onChanged: (v) =>
                              setState(() => _aceptaTerminos = v ?? false),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              'Estoy de acuerdo con los términos y condiciones.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Botón Registrarme
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _registrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Registrarme',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Botón Cancelar
                    SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFB94A48)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Color(0xFFB94A48),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Subtítulo de sección con color y línea inferior sutil
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFDFDFDF))),
      ],
    );
  }
}

/// Aviso de privacidad en texto pequeño (multi-línea)
class _AvisoPrivacidad extends StatelessWidget {
  const _AvisoPrivacidad();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Los datos personales recabados serán utilizados exclusivamente para fines de '
      'identificación, georreferenciación, verificación y validación de apoyo a productores del campo. '
      'No se compartirán con terceros sin consentimiento expreso del titular, salvo requerimiento legal. '
      'Los titulares podrán ejercer sus derechos de acceso, rectificación, cancelación u oposición (ARCO) '
      'conforme a la LFPDPPP, mediante solicitud por los canales oficiales del proyecto.\n'
      'Responsable: AgroConecta Q.Roo – Proyecto de innovación tecnológica para jóvenes del campo.',
      style: TextStyle(fontSize: 12.2, color: Colors.black87, height: 1.25),
      textAlign: TextAlign.justify,
    );
  }
}

/// Formateador para forzar texto en MAYÚSCULAS
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
