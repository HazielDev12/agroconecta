import 'package:agroconecta/config/config.dart';
import 'package:agroconecta/features/auth/domain/datasources/auth_datasource.dart';
import 'package:agroconecta/features/auth/domain/entities/user.dart';
import 'package:agroconecta/features/auth/infrastructure/infrastructure.dart';
import 'package:dio/dio.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiUrl,
      /*        connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10), */
    ),
  );

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
  }) async {
    try {
      final payload = <String, dynamic>{
        'nombre': nombre.trim().toUpperCase(),
        'apellido_paterno': apellidoPaterno.trim().toUpperCase(),
        if (apellidoMaterno != null && apellidoMaterno.trim().isNotEmpty)
          'apellido_materno': apellidoMaterno.trim().toUpperCase(),
        'CURP': curp.trim().toUpperCase(),
        'telefono': telefono.trim(),
        if (correo != null && correo.trim().isNotEmpty) 'correo': correo.trim(),
        'password': password,
        'password_confirmation': passwordConfirm,
        if (idComunidad != null) 'idComunidad': idComunidad,
        if (idRol != null) 'idRol': idRol, // default 2 en tu API si omites
      };

      final resp = await dio.post('/register', data: payload);

      return UserMapper.userJsonToEntity(Map<String, dynamic>.from(resp.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Propaga detalle de validación para mostrarlo en UI
        throw Exception('Validación: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
