import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String username, String password);
  // Future<String> register( String username, String lastname, DateTime dateOfBirth, String curp, String password );
  Future<User> checkAuthStatus(String token);
}
