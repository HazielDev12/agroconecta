import 'package:agroconecta/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

// --- STATE ---
class SignUpFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  final Name name;
  final LastName lastName;
  final DateOfBirth dateOfBirth;
  final Curp curp;
  final Phone phoneNumber;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmPassword;
  final TermsAccepted termsAccepted;

  const SignUpFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
    this.lastName = const LastName.pure(),
    this.dateOfBirth = const DateOfBirth.pure(),
    this.curp = const Curp.pure(),
    this.phoneNumber = const Phone.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmedPassword.pure(),
    this.termsAccepted = const TermsAccepted.pure(),
  });

  SignUpFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? nombre,
    LastName? apellidos,
    DateOfBirth? fechaNacimiento,
    Curp? curp,
    Phone? telefono,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmPassword,
    TermsAccepted? aceptaTerminos,
  }) {
    return SignUpFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      name: nombre ?? this.name,
      lastName: apellidos ?? this.lastName,
      dateOfBirth: fechaNacimiento ?? this.dateOfBirth,
      curp: curp ?? this.curp,
      phoneNumber: telefono ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      termsAccepted: aceptaTerminos ?? this.termsAccepted,
    );
  }

  @override
  String toString() {
    return '''
  SignUpFormState:
    isPosting: $isPosting,
    isFormPosted: $isFormPosted,
    isValid: $isValid,
    nombre: $name,
    apellidos: $lastName,
    fechaNacimiento: $dateOfBirth,
    curp: $curp,
    telefono: $phoneNumber,
    email: $email,
    password: $password,
    confirmPassword: $confirmPassword,
    aceptaTerminos: $termsAccepted,
  ''';
  }
}

// --- NOTIFIER ---
class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  SignUpFormNotifier() : super(const SignUpFormState());

  // ======= ON CHANGE METHODS =======
  void onNameChange(String value) {
    final newValue = Name.dirty(value);
    _updateState(nombre: newValue);
  }

  void onLastNameChange(String value) {
    final newValue = LastName.dirty(value);
    _updateState(apellidos: newValue);
  }

  void onDateOfBirthChange(DateTime date) {
    final formatted = DateFormat('dd/MM/yy').format(date);
    final newValue = DateOfBirth.dirty(formatted);
    _updateState(fechaNacimiento: newValue);
  }

  void onCurpChange(String value) {
    final newValue = Curp.dirty(value.toUpperCase());
    _updateState(curp: newValue);
  }

  void onPhoneChange(String value) {
    final newValue = Phone.dirty(value);
    _updateState(telefono: newValue);
  }

  void onEmailChange(String value) {
    final newValue = Email.dirty(value);
    _updateState(email: newValue);
  }

  void onPasswordChange(String value) {
    final pass = Password.dirty(value);
    final confirm = ConfirmedPassword.dirty(
      original: pass.value,
      value: state.confirmPassword.value,
    );
    _updateState(password: pass, confirmPassword: confirm);
  }

  void onConfirmPasswordChange(String value) {
    final confirm = ConfirmedPassword.dirty(
      original: state.password.value,
      value: value,
    );
    _updateState(confirmPassword: confirm);
  }

  void onTermsAcceptedChange(bool value) {
    final newValue = TermsAccepted.dirty(value);
    _updateState(aceptaTerminos: newValue);
  }

  // ======= SUBMIT =======
  Future<void> onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);
    debugPrint('Registro válido:\n${state.toString()}');

    try {
      // TODO: llamar a la API de registro
      // await api.registerUser({
      //   'nombre': state.nombre.value,
      //   'apellidos': state.apellidos.value,
      //   'fecha_nacimiento': state.fechaNacimiento.value,
      //   'curp': state.curp.value,
      //   'telefono': state.telefono.value,
      //   'email': state.email.value,
      //   'password': state.password.value,
      // });

      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Usuario registrado correctamente');
    } catch (e) {
      debugPrint('Error al registrar: $e');
    } finally {
      state = state.copyWith(isPosting: false);
    }
  }

  // ======= HELPERS =======
  void _touchEveryField() {
    final nombre = Name.dirty(state.name.value);
    final apellidos = LastName.dirty(state.lastName.value);
    final fechaNacimiento = DateOfBirth.dirty(state.dateOfBirth.value);
    final curp = Curp.dirty(state.curp.value);
    final telefono = Phone.dirty(state.phoneNumber.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmedPassword.dirty(
      original: password.value,
      value: state.confirmPassword.value,
    );
    final aceptaTerminos = TermsAccepted.dirty(state.termsAccepted.value);

    state = state.copyWith(
      isFormPosted: true,
      nombre: nombre,
      apellidos: apellidos,
      fechaNacimiento: fechaNacimiento,
      curp: curp,
      telefono: telefono,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      aceptaTerminos: aceptaTerminos,
      isValid: Formz.validate([
        nombre,
        apellidos,
        fechaNacimiento,
        curp,
        telefono,
        email,
        password,
        confirmPassword,
        aceptaTerminos,
      ]),
    );
  }

  void _updateState({
    Name? nombre,
    LastName? apellidos,
    DateOfBirth? fechaNacimiento,
    Curp? curp,
    Phone? telefono,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmPassword,
    TermsAccepted? aceptaTerminos,
  }) {
    state = state.copyWith(
      nombre: nombre ?? state.name,
      apellidos: apellidos ?? state.lastName,
      fechaNacimiento: fechaNacimiento ?? state.dateOfBirth,
      curp: curp ?? state.curp,
      telefono: telefono ?? state.phoneNumber,
      email: email ?? state.email,
      password: password ?? state.password,
      confirmPassword: confirmPassword ?? state.confirmPassword,
      aceptaTerminos: aceptaTerminos ?? state.termsAccepted,
      isValid: Formz.validate([
        nombre ?? state.name,
        apellidos ?? state.lastName,
        fechaNacimiento ?? state.dateOfBirth,
        curp ?? state.curp,
        telefono ?? state.phoneNumber,
        email ?? state.email,
        password ?? state.password,
        confirmPassword ?? state.confirmPassword,
        aceptaTerminos ?? state.termsAccepted,
      ]),
    );
  }
}

// --- PROVIDER ---
final signUpFormProvider =
    StateNotifierProvider<SignUpFormNotifier, SignUpFormState>((ref) {
      return SignUpFormNotifier();
    });
