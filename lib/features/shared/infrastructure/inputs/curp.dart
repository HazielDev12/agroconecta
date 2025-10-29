import 'package:formz/formz.dart';

enum CurpError { empty, length, format }

class Curp extends FormzInput<String, CurpError> {
  // CURP oficial (mayúsculas), incluye entidades federativas y estructura.
  static final _curpReg = RegExp(r'^[A-Z]{4}\d{6}[HM]{1}[A-Z]{5}[A-Z0-9]{2}$');
  /*   static final _curpReg = RegExp(
    r'^[A-Z][AEIOUX][A-Z]{2}\d{2}'
    r'(0[1-9]|1[0-2])' // mes
    r'(0[1-9]|[12]\d|3[01])' // día
    r'[HM]'
    r'(AS|BC|BS|CC|CL|CM|CS|CH|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS)'
    r'[B-DF-HJ-NP-TV-Z]{3}'
    r'[A-Z0-9]\d$'
    );
 */
  const Curp.pure() : super.pure('');
  const Curp.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == CurpError.empty) {
      return 'La CURP es requerida';
    }
    if (displayError == CurpError.length) {
      return 'La CURP debe tener 18 caracteres';
    }
    if (displayError == CurpError.format) {
      return 'CURP no válida. Verifica tus datos.';
    }
    return null;
  }

  @override
  CurpError? validator(String value) {
    final v = value.trim().toUpperCase();
    if (v.isEmpty) return CurpError.empty;
    if (v.length != 18) return CurpError.length;
    if (!_curpReg.hasMatch(v)) return CurpError.format;
    return null;
  }
}
