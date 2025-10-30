import 'package:formz/formz.dart';

enum LastNameError { empty, length, format }

class LastName extends FormzInput<String, LastNameError> {
  const LastName.pure() : super.pure('');
  const LastName.dirty(String value) : super.dirty(value);

  static final _reg = RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ\s]{2,}$");

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == LastNameError.empty) return 'Los apellidos son requeridos';
    if (displayError == LastNameError.length) return 'Mínimo 2 caracteres';
    if (displayError == LastNameError.format) return 'Solo letras y espacios';
    return null;
  }

  @override
  LastNameError? validator(String value) {
    final v = value.trim();
    if (v.isEmpty) return LastNameError.empty;
    if (v.length < 2) return LastNameError.length;
    if (!_reg.hasMatch(v)) return LastNameError.format;
    return null;
  }
}
