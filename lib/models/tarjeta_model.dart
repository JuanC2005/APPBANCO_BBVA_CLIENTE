class TarjetaModel {
  final String id;
  final String numeroTarjeta;
  final String tipoTarjeta;
  final String marca;
  final String estado;
  final double limiteCredito;
  final double saldoUtilizado;
  final String fechaVencimiento;

  TarjetaModel({
    required this.id,
    required this.numeroTarjeta,
    required this.tipoTarjeta,
    required this.marca,
    required this.estado,
    required this.limiteCredito,
    required this.saldoUtilizado,
    required this.fechaVencimiento,
  });

  factory TarjetaModel.fromJson(Map<String, dynamic> json) {
    return TarjetaModel(
      id: json['id'] ?? '',
      numeroTarjeta: json['numero_tarjeta'] ?? '',
      tipoTarjeta: json['tipo_tarjeta'] ?? '',
      marca: json['marca'] ?? '',
      estado: json['estado'] ?? '',
      limiteCredito: (json['limite_credito'] ?? 0).toDouble(),
      saldoUtilizado: (json['saldo_utilizado'] ?? 0).toDouble(),
      fechaVencimiento: json['fecha_vencimiento'] ?? '',
    );
  }

  double get disponible => limiteCredito - saldoUtilizado;
}
