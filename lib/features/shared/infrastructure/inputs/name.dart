import 'package:formz/formz.dart';

enum NameError { empty, length, format }

class Name extends FormzInput<String, NameError> {
  const Name.pure() : super.pure('');
  const Name.dirty(String value) : super.dirty(value);

  // Letras, espacios y acentos comunes en español.
  static final _reg = RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ\s]{2,}$");
  // Posible expresión mejorada o alternativa:
  // Verifica qeu no tenga espacios al principio o al final, y que solo haya un espacio entre nombres
  // static final _reg = RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?:\s[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)*$");

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == NameError.empty) return 'El nombre es requerido';
    if (displayError == NameError.length) return 'Mínimo 2 caracteres';
    if (displayError == NameError.format) return 'Solo letras y espacios';
    return null;
  }

  @override
  NameError? validator(String value) {
    final v = value.trim();
    if (v.isEmpty) return NameError.empty;
    if (v.length < 2) return NameError.length;
    if (!_reg.hasMatch(v)) return NameError.format;
    return null;
  }
}
