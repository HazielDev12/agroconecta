import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

enum DobError { empty, format, underAge }

/// Almacena la fecha como String en formato dd/MM/yy y valida >= 18 años.
class DateOfBirth extends FormzInput<String, DobError> {
  const DateOfBirth.pure() : super.pure('');
  const DateOfBirth.dirty(String value) : super.dirty(value);

  static final _fmt = DateFormat('dd/MM/yy');

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == DobError.empty) return 'La fecha es requerida';
    if (displayError == DobError.format) return 'Usa el formato dd/mm/aa';
    if (displayError == DobError.underAge) return 'Debes ser mayor de 18 años';
    return null;
  }

  @override
  DobError? validator(String value) {
    final v = value.trim();
    if (v.isEmpty) return DobError.empty;

    DateTime? dob;
    try {
      dob = _fmt.parseStrict(v);
    } catch (_) {
      return DobError.format;
    }

    final today = DateTime.now();
    final eighteen = DateTime(today.year - 18, today.month, today.day);
    if (dob.isAfter(eighteen)) return DobError.underAge;

    return null;
  }
}
