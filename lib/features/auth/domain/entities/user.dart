class User {
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String curp;
  final String telefono;
  final String sexo;
  final String correo;
  final String comunidad;
  final String municipio;
  final String estado;
  // final List<String> roles;
  final String token;

  const User({
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.curp,
    required this.telefono,
    required this.sexo,
    required this.correo,
    required this.comunidad,
    required this.municipio,
    required this.estado,
    // required this.roles,
    required this.token,
  });

  /*   bool get isAdmin {
    return roles.contains('admin');
  } */
}
