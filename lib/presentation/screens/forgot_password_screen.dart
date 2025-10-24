import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const Color brandGreen = Color(0xFF22A788);
  static const Color cardTint = Color(
    0xE6E6F0C2,
  ); // tono verdoso claro semitransparente

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );

  void _sendCode() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // TODO: Llamar a tu endpoint /auth/forgot-password y navegar a /auth/verify-code
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Te enviamos un código al correo si existe en el sistema.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo cultivo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cultivo.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Botón atrás flotante (como en el mock)
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => context.pop(),
            ),
          ),

          // Tarjeta central
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                decoration: BoxDecoration(
                  color: cardTint,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      SvgPicture.asset('assets/images/logo.svg', height: 78),
                      const SizedBox(height: 12),

                      const Text(
                        'Recuperar contraseña',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDeco('Ingresa tu correo electrónico'),
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Ingresa tu correo';
                          final reg = RegExp(
                            r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$',
                          );
                          if (!reg.hasMatch(v)) return 'Correo inválido';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Introduce tu correo electrónico y te enviaremos un código para que puedas acceder a tu cuenta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 20),

                      // Enviar código
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _sendCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Enviar código',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Cancelar
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
