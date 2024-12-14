class Users {
  final int id;
  final String nombre;
  final String apellido;
  final String username;
  final String email;
  final String rol;
  final DateTime fechaRegistro;
  final bool estado;

  Users({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.username,
    required this.email,
    required this.rol,
    required this.fechaRegistro,
    required this.estado,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['UsuarioID'],
      nombre: json['Nombre'],
      apellido: json['Apellido'],
      username: json['Username'],
      email: json['Email'],
      rol: json['Rol'],
      fechaRegistro: DateTime.parse(json['FechaRegistro']),
      estado: json['Estado'] == 1,
    );
  }
}
