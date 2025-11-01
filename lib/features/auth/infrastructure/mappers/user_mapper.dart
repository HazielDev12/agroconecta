import 'package:agroconecta/features/auth/domain/entities/user.dart';

class UserMapper {
  /// Mapea la respuesta **aplanada** de /api/login a la entidad User.
  ///
  /// Espera algo como:
  /// {
  ///   "message": "...",
  ///   "id": 1,
  ///   "idBeneficiario": 1,
  ///   "idRol": 2,
  ///   "email_verified_at": null,
  ///   "created_at": "2025-10-27T23:08:52.000000Z",
  ///   "updated_at": "2025-10-27T23:08:52.000000Z",
  ///   "token": "..."
  /// }
  static User userJsonToEntity(Map<String, dynamic> json) {
    // Normaliza a un mapa plano, aunque venga { user: {...}, token }
    late final Map<String, dynamic> map;

    if (json['user'] is Map) {
      map = Map<String, dynamic>.from(json['user'] as Map);
      if (json.containsKey('token')) {
        map['token'] = json['token'];
      }
    } else {
      map = Map<String, dynamic>.from(json);
    }

    final int? idRol = _toInt(map['idRol']);

    return User(
      id: _toInt(map['id']) ?? 0,
      idBeneficiario: _toInt(map['idBeneficiario']),
      idRol: idRol,
      roleName: _roleNameFromId(idRol),
      emailVerifiedAt: _toDateTime(map['email_verified_at']),
      createdAt: _toDateTime(map['created_at']),
      updatedAt: _toDateTime(map['updated_at']),
      token: _toStr(map['token']),
    );
  }

  // ---------- helpers locales ----------
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  static String? _toStr(dynamic v) => v?.toString();

  static DateTime? _toDateTime(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  static String? _roleNameFromId(int? idRol) {
    switch (idRol) {
      case 1:
        return 'admin';
      case 2:
        return 'beneficiario';
      case 3:
        return 'operador';
      default:
        return null;
    }
  }
}
