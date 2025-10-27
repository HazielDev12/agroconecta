import 'package:formz/formz.dart';

enum ConfirmedPasswordError { empty, mismatch }

/// Confirmación de contraseña que compara con la contraseña original.
/// Pasa la contraseña original en el constructor.
class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordError> {
  final String original;

  const ConfirmedPassword.pure({this.original = ''}) : super.pure('');
  const ConfirmedPassword.dirty({required this.original, String value = ''})
    : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == ConfirmedPasswordError.empty) {
      return 'Confirma tu contraseña';
    }
    if (displayError == ConfirmedPasswordError.mismatch) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  @override
  ConfirmedPasswordError? validator(String value) {
    if (value.isEmpty) return ConfirmedPasswordError.empty;
    if (value != original) return ConfirmedPasswordError.mismatch;
    return null;
  }

  /// Helper para clonar manteniendo la contraseña original.
  ConfirmedPassword copyWith({String? value, String? original}) =>
      ConfirmedPassword.dirty(
        original: original ?? this.original,
        value: value ?? this.value,
      );
}
