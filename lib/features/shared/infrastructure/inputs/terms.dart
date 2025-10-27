import 'package:formz/formz.dart';

enum TermsError { notAccepted }

class TermsAccepted extends FormzInput<bool, TermsError> {
  const TermsAccepted.pure() : super.pure(false);
  const TermsAccepted.dirty(bool value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == TermsError.notAccepted) {
      return 'Debes aceptar los términos y condiciones';
    }
    return null;
  }

  @override
  TermsError? validator(bool value) {
    return value ? null : TermsError.notAccepted;
  }
}
