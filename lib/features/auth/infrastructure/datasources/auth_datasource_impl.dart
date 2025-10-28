import 'package:agroconecta/config/config.dart';
import 'package:agroconecta/features/auth/domain/datasources/auth_datasource.dart';
import 'package:agroconecta/features/auth/domain/entities/user.dart';
import 'package:agroconecta/features/auth/infrastructure/infrastructure.dart';
import 'package:dio/dio.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String curp, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'curp': curp, 'password': password},
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } catch (e) {
      throw WrongCredentials();
    }
  }
}
