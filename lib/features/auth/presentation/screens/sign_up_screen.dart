import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Widgets shared (CustomTextFormField, CustomFilledButton, etc.)
import 'package:agroconecta/features/shared/widgets/widgets.dart';

// Provider del formulario de registro
import 'package:agroconecta/features/auth/presentation/providers/sign_up_form_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFDCE0E0),
        body: const SafeArea(child: Center(child: _SignUpCard())),
      ),
    );
  }
}

class _SignUpCard extends StatelessWidget {
  const _SignUpCard();

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
        child: const _SignUpForm(),
      ),
    );
  }
}

class _SignUpForm extends ConsumerWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpFormProvider);
    final notifier = ref.read(signUpFormProvider.notifier);

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
        ref.read(signUpFormProvider.notifier).onDateOfBirthChange(picked);
      }
    }

    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/images/logo_con_texto.svg', height: 160),
          const SizedBox(height: 10),
          const Text(
            'Crea tu cuenta',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),

          // ======= Datos personales =======
          const _SectionHeader('Datos Personales'),
          const SizedBox(height: 10),

          CustomTextFormField(
            label: 'Nombre (s)',
            textInputAction: TextInputAction.next,
            onChanged: notifier.onNameChange,
            errorMessage: state.isFormPosted ? state.name.errorMessage : null,
          ),
          const SizedBox(height: 12),

          CustomTextFormField(
            label: 'Apellidos',
            textInputAction: TextInputAction.next,
            onChanged: notifier.onLastNameChange,
            errorMessage: state.isFormPosted
                ? state.lastName.errorMessage
                : null,
          ),
          const SizedBox(height: 12),

          // Fecha de nacimiento (readOnly + picker)
          CustomTextFormField(
            label: 'Fecha de Nacimiento',
            suffixIcon: Icons.calendar_month_rounded,
            readOnly: true,
            onTap: _pickFecha,
            controller: TextEditingController(text: state.dateOfBirth.value),
          ),
          const SizedBox(height: 12),

          CustomTextFormField(
            label: 'CURP',
            suffixIcon: Icons.fingerprint,
            inputFormatters: [
              UpperCaseTextFormatter(),
              LengthLimitingTextInputFormatter(18),
            ],
            textInputAction: TextInputAction.next,
            onChanged: notifier.onCurpChange,
          ),

          const SizedBox(height: 22),

          // ======= Contacto =======
          const _SectionHeader('Información de Contacto'),
          const SizedBox(height: 10),

          CustomTextFormField(
            label: 'Número de Teléfono',
            keyboardType: TextInputType.number,
            suffixIcon: Icons.phone_outlined,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            onChanged: notifier.onPhoneChange,
            errorMessage: state.isFormPosted
                ? state.phoneNumber.errorMessage
                : null,
          ),
          const SizedBox(height: 12),

          CustomTextFormField(
            label: 'Correo Electrónico',
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icons.email_outlined,
            onChanged: notifier.onEmailChange,
            errorMessage: state.isFormPosted ? state.email.errorMessage : null,
          ),

          const SizedBox(height: 22),

          // ======= Seguridad =======
          const _SectionHeader('Seguridad'),
          const SizedBox(height: 10),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            suffixIcon: Icons.key_outlined,
            onChanged: (v) {
              notifier.onPasswordChange(v);
              notifier.onConfirmPasswordChange(
                state.confirmPassword.value,
              ); // revalida match
            },
            errorMessage: state.isFormPosted
                ? state.password.errorMessage
                : null,
          ),
          const SizedBox(height: 12),

          CustomTextFormField(
            label: 'Confirmar contraseña',
            obscureText: true,
            suffixIcon: Icons.key,
            onChanged: notifier.onConfirmPasswordChange,
            errorMessage: state.isFormPosted
                ? state.confirmPassword.errorMessage
                : null,
          ),

          const SizedBox(height: 16),

          // Términos y condiciones
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: state.termsAccepted.value,
                activeColor: const Color(0xFF22A788),
                onChanged: (v) => notifier.onTermsAcceptedChange(v ?? false),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    state.termsAccepted.isValid
                        ? 'Estoy de acuerdo con los términos y condiciones.'
                        : (state.isFormPosted
                              ? (state.termsAccepted.errorMessage ??
                                    'Debes aceptar los términos.')
                              : 'Estoy de acuerdo con los términos y condiciones.'),
                    style: TextStyle(
                      fontSize: 13,
                      color: state.termsAccepted.isValid
                          ? Colors.black
                          : Colors.red[700],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // CTA
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              text: 'Registrarme',
              onPressed: () => notifier.onFormSubmit(),
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
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
                style: TextStyle(color: Color(0xFFB94A48), fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Ya tienes cuenta? ',
                style: TextStyle(color: Colors.black54),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: const Text(
                  'Inicia sesión',
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

// Auxiliares UI
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

// Forzar MAYÚSCULAS (CURP)
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
