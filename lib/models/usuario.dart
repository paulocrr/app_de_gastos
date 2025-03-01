class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String email;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
  });

  factory Usuario.fromFirestore(Map<String, dynamic> data) {
    return Usuario(
      id: data['id'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      email: data['correo'],
    );
  }
}
