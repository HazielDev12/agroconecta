import 'package:agroconecta/features/auth/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
    nombre: json['nombre'],
    apellidoPaterno: json['apellido_paterno'],
    apellidoMaterno: json['apellido_materno'],
    curp: json['CURP'],
    telefono: json['telefono'],
    sexo: json['sexo'],
    correo: json['correo'],
    comunidad: json['comunidad'],
    municipio: json['municipio'],
    estado: json['estado'],
    // roles: json['roles'],
    token: json['token'],
  );
}
