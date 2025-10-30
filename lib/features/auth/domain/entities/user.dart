class User {
  final int id;
  final int? idBeneficiario;
  final int? idRol;

  final String? roleName; // derivado de idRol (opcional)
  final DateTime? emailVerifiedAt; // puede venir null
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Sólo viene al hacer login
  final String? token;

  const User({
    required this.id,
    this.idBeneficiario,
    this.idRol,
    this.roleName,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  bool get isAdmin => idRol == 1 || roleName?.toLowerCase() == 'admin';

  User copyWith({
    int? id,
    int? idBeneficiario,
    int? idRol,
    String? roleName,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      idBeneficiario: idBeneficiario ?? this.idBeneficiario,
      idRol: idRol ?? this.idRol,
      roleName: roleName ?? this.roleName,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }

  /// Login **aplanado**:
  /// {
  ///   "message": "...",
  ///   "id": 1, "idBeneficiario": 1, "idRol": 2,
  ///   "email_verified_at": null,
  ///   "created_at": "2025-10-27T23:08:52.000000Z",
  ///   "updated_at": "2025-10-27T23:08:52.000000Z",
  ///   "token": "...."
  /// }
  factory User.fromFlatLoginJson(Map<String, dynamic> json) {
    final idRol = _toInt(json['idRol']);
    return User(
      id: _toInt(json['id']) ?? 0,
      idBeneficiario: _toInt(json['idBeneficiario']),
      idRol: idRol,
      roleName: _roleNameFromId(idRol),
      emailVerifiedAt: _toDateTime(json['email_verified_at']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      token: _toStr(json['token']),
    );
  }

  // ------- utils -------
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
