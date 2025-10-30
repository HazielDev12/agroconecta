import 'package:formz/formz.dart';

/// Errores posibles para contraseñas simples
enum WeakPasswordError { empty, length }

/// Valida contraseñas simples (sin necesidad de mayúsculas ni símbolos)
///
/// Acepta contraseñas como:
/// - "123456"
/// - "12345678"
/// - "abcdef"
/// Solo valida que tenga al menos 6 caracteres.
class WeakPassword extends FormzInput<String, WeakPasswordError> {
  const WeakPassword.pure() : super.pure('');
  const WeakPassword.dirty(String value) : super.dirty(value);

  /// Mensajes de error personalizados
  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case WeakPasswordError.empty:
        return 'El campo es requerido';
      case WeakPasswordError.length:
        return 'Debe tener al menos 6 caracteres';
      default:
        return null;
    }
  }

  /// Valida que la contraseña no esté vacía y tenga longitud mínima
  @override
  WeakPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return WeakPasswordError.empty;
    }
    if (value.length < 6) {
      return WeakPasswordError.length;
    }
    return null;
  }
}
