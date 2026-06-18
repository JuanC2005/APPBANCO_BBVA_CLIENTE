class NotificacionModel {
  final String id;
  final String tipo;
  final String titulo;
  final String mensaje;
  final bool leida;
  final String createdAt;

  NotificacionModel({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    required this.leida,
    required this.createdAt,
  });

  factory NotificacionModel.fromJson(Map<String, dynamic> json) {
    return NotificacionModel(
      id: json['id'] ?? '',
      tipo: json['tipo'] ?? 'info',
      titulo: json['titulo'] ?? '',
      mensaje: json['mensaje'] ?? '',
      leida: json['leida'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}
