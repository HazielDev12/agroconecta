import 'package:agroconecta/features/auth/presentation/providers/auth_provider.dart';
import 'package:agroconecta/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';

// 1.- Stata de este provider
class LoginFormState {
  final bool isPosting;
  final bool isFromPosted;
  final bool isValid;
  // final Email email;
  final Curp curp;
  // final Password password;
  final WeakPassword password;

  LoginFormState({
    this.isPosting = false,
    this.isFromPosted = false,
    this.isValid = false,
    // this.email = const Email.pure(),
    this.curp = const Curp.pure(),
    // this.password = const Password.pure(),
    this.password = const WeakPassword.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFromPosted,
    bool? isValid,
    // Email? email,
    Curp? curp,
    // Password? password,
    WeakPassword? password,
  }) {
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFromPosted: isFromPosted ?? this.isFromPosted,
      isValid: isValid ?? this.isValid,
      // email: email ?? this.email,
      curp: curp ?? this.curp,
      // password: password ?? this.password,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return '''

  LoginFormState:
      isPosting: $isPosting,
      isFromPosted: $isFromPosted,
      isValid: $isValid,
      curp: $curp,
      password: $password,
    ''';
  }
}

// 2.- Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  LoginFormNotifier({required this.loginUserCallback})
    : super(LoginFormState());

  /*   onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  } */
  onCurpChange(String value) {
    final newCurp = Curp.dirty(value.toUpperCase());
    state = state.copyWith(
      curp: newCurp,
      isValid: Formz.validate([newCurp, state.password]),
    );
  }

  onPasswordChange(String value) {
    // final newPassword = Password.dirty(value);
    final newPassword = WeakPassword.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([state.curp, newPassword]),
    );
  }

  // ======= SUBMIT =======
  onFormSubmit() async{
    _touchEveryField();

    if (!state.isValid) return;

    await loginUserCallback(state.curp.value, state.password.value);
  }

  _touchEveryField() {
    // final email = Email.dirty(state.email.value);
    final curp = Curp.dirty(state.curp.value);
    // final password = Password.dirty(state.password.value);
    final password = WeakPassword.dirty(state.password.value);

    state = state.copyWith(
      isFromPosted: true,
      // email: email,
      curp: curp,
      password: password,
      isValid: Formz.validate([curp, password]),
    );
  }
}

// 3.- StateNotifierProvider - Consume afuera
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
      final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

      return LoginFormNotifier(loginUserCallback: loginUserCallback);
    });
