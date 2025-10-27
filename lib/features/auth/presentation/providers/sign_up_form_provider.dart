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

  final Name nombre;
  final LastName apellidos;
  final DateOfBirth fechaNacimiento;
  final Curp curp;
  final Phone telefono;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmPassword;
  final TermsAccepted aceptaTerminos;

  SignUpFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.nombre = const Name.pure(),
    this.apellidos = const LastName.pure(),
    this.fechaNacimiento = const DateOfBirth.pure(),
    this.curp = const Curp.pure(),
    this.telefono = const Phone.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmedPassword.pure(),
    this.aceptaTerminos = const TermsAccepted.pure(),
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
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      curp: curp ?? this.curp,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      aceptaTerminos: aceptaTerminos ?? this.aceptaTerminos,
    );
  }

  @override
  String toString() {
    return '''
    SignUpFormState:
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      nombre: $nombre,
      apellidos: $apellidos,
      fechaNacimiento: $fechaNacimiento,
      curp: $curp,
      telefono: $telefono,
      email: $email,
      password: $password,
      confirmPassword: $confirmPassword,
      aceptaTerminos: $aceptaTerminos,
    ''';
  }
}

// --- NOTIFIER ---
class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  SignUpFormNotifier() : super(SignUpFormState());

  // ======= ON CHANGE METHODS =======
  void onNombreChange(String value) {
    final newValue = Name.dirty(value);
    _updateState(nombre: newValue);
  }

  void onApellidosChange(String value) {
    final newValue = LastName.dirty(value);
    _updateState(apellidos: newValue);
  }

  void onFechaNacimientoChange(DateTime date) {
    final formatted = DateFormat('dd/MM/yy').format(date);
    final newValue = DateOfBirth.dirty(formatted);
    _updateState(fechaNacimiento: newValue);
  }

  void onCurpChange(String value) {
    final newValue = Curp.dirty(value.toUpperCase());
    _updateState(curp: newValue);
  }

  void onTelefonoChange(String value) {
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

  void onAceptarTerminosChange(bool value) {
    final newValue = TermsAccepted.dirty(value);
    _updateState(aceptaTerminos: newValue);
  }

  // ======= SUBMIT =======
  void onFormSubmit() {
    _touchEveryField();

    if (!state.isValid) return;

    debugPrint('Registro válido:\n${state.toString()}');
    // Aquí puedes llamar a tu API o backend
  }

  // ======= HELPERS =======
  void _touchEveryField() {
    final nombre = Name.dirty(state.nombre.value);
    final apellidos = LastName.dirty(state.apellidos.value);
    final fechaNacimiento = DateOfBirth.dirty(state.fechaNacimiento.value);
    final curp = Curp.dirty(state.curp.value);
    final telefono = Phone.dirty(state.telefono.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmedPassword.dirty(
      original: password.value,
      value: state.confirmPassword.value,
    );
    final aceptaTerminos = TermsAccepted.dirty(state.aceptaTerminos.value);

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
      nombre: nombre ?? state.nombre,
      apellidos: apellidos ?? state.apellidos,
      fechaNacimiento: fechaNacimiento ?? state.fechaNacimiento,
      curp: curp ?? state.curp,
      telefono: telefono ?? state.telefono,
      email: email ?? state.email,
      password: password ?? state.password,
      confirmPassword: confirmPassword ?? state.confirmPassword,
      aceptaTerminos: aceptaTerminos ?? state.aceptaTerminos,
      isValid: Formz.validate([
        nombre ?? state.nombre,
        apellidos ?? state.apellidos,
        fechaNacimiento ?? state.fechaNacimiento,
        curp ?? state.curp,
        telefono ?? state.telefono,
        email ?? state.email,
        password ?? state.password,
        confirmPassword ?? state.confirmPassword,
        aceptaTerminos ?? state.aceptaTerminos,
      ]),
    );
  }
}

// --- PROVIDER ---
final signUpFormProvider =
    StateNotifierProvider<SignUpFormNotifier, SignUpFormState>((ref) {
      return SignUpFormNotifier();
    });
