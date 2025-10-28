import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String curp, String password);
  // Future<String> register( String username, String lastname, DateTime dateOfBirth, String curp, String password );
  Future<User> checkAuthStatus(String token);
}
