class SolicitudModel {
  final String id;
  final String? numeroExpediente;
  final String clienteId;
  final String? asesorId;
  final double montoSolicitado;
  final int plazoMeses;
  final double teaReferencial;
  final double cuotaEstimada;
  final String garantia;
  final String? destinoCredito;
  final bool conSeguro;
  final String canal;
  final String estado;
  final double? montoAprobado;
  final String? motivoRechazo;
  final String? condicionAdicional;
  final String createdAt;
  final String updatedAt;

  SolicitudModel({
    required this.id,
    this.numeroExpediente,
    required this.clienteId,
    this.asesorId,
    required this.montoSolicitado,
    required this.plazoMeses,
    required this.teaReferencial,
    required this.cuotaEstimada,
    this.garantia = 'sin_garantia',
    this.destinoCredito,
    this.conSeguro = false,
    this.canal = 'cliente',
    required this.estado,
    this.montoAprobado,
    this.motivoRechazo,
    this.condicionAdicional,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    return SolicitudModel(
      id: json['id'] ?? '',
      numeroExpediente: json['numero_expediente'],
      clienteId: json['cliente_id'] ?? '',
      asesorId: json['asesor_id'],
      montoSolicitado: (json['monto_solicitado'] ?? 0).toDouble(),
      plazoMeses: json['plazo_meses'] ?? 12,
      teaReferencial: (json['tea_referencial'] ?? 0).toDouble(),
      cuotaEstimada: (json['cuota_estimada'] ?? 0).toDouble(),
      garantia: json['garantia'] ?? 'sin_garantia',
      destinoCredito: json['destino_credito'],
      conSeguro: json['con_seguro'] ?? false,
      canal: json['canal'] ?? 'cliente',
      estado: json['estado'] ?? 'borrador',
      montoAprobado: json['monto_aprobado']?.toDouble(),
      motivoRechazo: json['motivo_rechazo'],
      condicionAdicional: json['condicion_adicional'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String get estadoLabel {
    switch (estado) {
      case 'borrador': return 'Borrador';
      case 'enviado': return 'Enviado';
      case 'recibido_comite': return 'En comité';
      case 'en_evaluacion': return 'En evaluación';
      case 'aprobado': return 'Aprobado';
      case 'condicionado': return 'Condicionado';
      case 'rechazado': return 'Rechazado';
      case 'desembolsado': return 'Desembolsado';
      default: return estado;
    }
  }

  String get garantiaLabel {
    switch (garantia) {
      case 'sin_garantia': return 'Sin garantía';
      case 'aval': return 'Aval';
      case 'hipotecaria': return 'Hipotecaria';
      case 'prendaria': return 'Prendaria';
      case 'vehicular': return 'Vehicular';
      default: return garantia;
    }
  }
}
