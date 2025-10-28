import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String curp, String password);
  Future<User> register({
    required String nombre,
    required String apellidoPaterno,
    String? apellidoMaterno,
    required String curp,
    required String telefono,
    String? correo,
    required String password,
    required String passwordConfirm,
    int? idComunidad,
    int? idRol,
  });
  Future<User> checkAuthStatus(String token);
}
