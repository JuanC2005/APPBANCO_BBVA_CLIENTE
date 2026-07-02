class UserModel {
  final String id;
  final String numeroDocumento;
  final String tipoDocumento;
  final String nombres;
  final String apellidos;
  final String? email;
  final String? telefono;
  final String? direccion;
  final double? lat;
  final double? lng;

  UserModel({
    required this.id,
    required this.numeroDocumento,
    required this.tipoDocumento,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.telefono,
    this.direccion,
    this.lat,
    this.lng,
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
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  UserModel copyWith({double? lat, double? lng}) {
    return UserModel(
      id: id,
      numeroDocumento: numeroDocumento,
      tipoDocumento: tipoDocumento,
      nombres: nombres,
      apellidos: apellidos,
      email: email,
      telefono: telefono,
      direccion: direccion,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
}
