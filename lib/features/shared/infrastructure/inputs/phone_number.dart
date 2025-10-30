import 'package:formz/formz.dart';

enum PhoneError { empty, length, format }

class Phone extends FormzInput<String, PhoneError> {
  const Phone.pure() : super.pure('');
  const Phone.dirty(String value) : super.dirty(value);

  static final _digits = RegExp(r'^\d{10}$');

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == PhoneError.empty) return 'El teléfono es requerido';
    if (displayError == PhoneError.length) return 'Debe tener 10 dígitos';
    if (displayError == PhoneError.format) return 'Solo números';
    return null;
  }

  @override
  PhoneError? validator(String value) {
    final v = value.trim();
    if (v.isEmpty) return PhoneError.empty;
    if (v.length != 10) return PhoneError.length;
    if (!_digits.hasMatch(v)) return PhoneError.format;

    return null;
  }
}
