


import 'package:agroconecta/features/auth/domain/datasources/auth_datasource.dart';
import 'package:agroconecta/features/auth/domain/entities/user.dart';

class AuthDataSourceImpl extends AuthDataSource {
  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }
  
}