import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:agroconecta/features/auth/presentation/providers/auth_provider.dart';
import 'package:agroconecta/features/auth/presentation/providers/providers.dart';
import 'package:agroconecta/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:agroconecta/features/shared/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cultivo.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(child: Center(child: const _LoginCard())),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            24, //Evita recortes con teclado
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8E8).withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: const _LoginForm(), // contenido del form
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    // final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Form(
      //Contenido Centrado
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/images/logo_con_texto.svg',
            height: 200, // ajusta según tu diseño
          ),
          const SizedBox(height: 16),
          //Texto principal
          const Text(
            'Tecnología que siembra futuro.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 30),

          //Campo de usuario/correo
          CustomTextFormField(
            label: 'CURP',
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icons.fingerprint,
            inputFormatters: [
              _UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(18),
            ],
            onChanged: (value) =>
                ref.read(loginFormProvider.notifier).onCurpChange(value),
            errorMessage: loginForm.isFromPosted
                ? loginForm.curp.errorMessage
                : null,
          ),
          const SizedBox(height: 16),

          //Campo contraseña
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            suffixIcon: Icons.key,
            onChanged: (value) =>
                ref.read(loginFormProvider.notifier).onPasswordChange(value),
            errorMessage: loginForm.isFromPosted
                ? loginForm.password.errorMessage
                : null,
          ),
          const SizedBox(height: 25),

          //Links inferiores
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.push('/forgot-password'),
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: Color(0xFF22A788),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),

          //Boton principal
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              text: 'Iniciar Sesión',
              onPressed: () {
                ref.read(loginFormProvider.notifier).onFormSubmit();
              },
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿No tienes cuenta? ',
                style: TextStyle(color: Colors.black54),
              ),
              GestureDetector(
                onTap: () => context.push('/sign-up'),
                child: const Text(
                  'Regístrate aquí',
                  style: TextStyle(
                    color: Color(0xFF22A788),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Forzar MAYÚSCULAS (CURP)
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
