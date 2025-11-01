import 'package:agroconecta/config/config.dart';
import 'package:agroconecta/features/auth/domain/datasources/auth_datasource.dart';
import 'package:agroconecta/features/auth/domain/entities/user.dart';
import 'package:agroconecta/features/auth/infrastructure/infrastructure.dart';
import 'package:dio/dio.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiUrl,
    ),
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    print('Entró a checkAuthStatus future');
    try {
      final response = await dio.get(
        '/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String curp, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'CURP': curp, 'password': password},
      );

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 302) {
        throw CustomError('Credenciales incorrectas');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
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
  }) {
    throw UnimplementedError();
  }
}
