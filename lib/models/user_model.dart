class UserModel {
  final String id;
  final String numeroDocumento;
  final String tipoDocumento;
  final String nombres;
  final String apellidos;
  final String? email;
  final String? telefono;
  final String? direccion;

  UserModel({
    required this.id,
    required this.numeroDocumento,
    required this.tipoDocumento,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.telefono,
    this.direccion,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      numeroDocumento: json['numero_documento'] ?? '',
      tipoDocumento: json['tipo_documento'] ?? 'DNI',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      email: json['email'],
      telefono: json['telefono'],
      direccion: json['direccion'],
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
}
