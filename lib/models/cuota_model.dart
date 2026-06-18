class CuotaModel {
  final String id;
  final int nroCuota;
  final String fechaVencimiento;
  final double capital;
  final double interes;
  final double seguro;
  final double cuotaTotal;
  final double saldo;
  final String estado;
  final String? fechaPago;

  CuotaModel({
    required this.id,
    required this.nroCuota,
    required this.fechaVencimiento,
    required this.capital,
    required this.interes,
    required this.seguro,
    required this.cuotaTotal,
    required this.saldo,
    required this.estado,
    this.fechaPago,
  });

  factory CuotaModel.fromJson(Map<String, dynamic> json) {
    return CuotaModel(
      id: json['id'] ?? '',
      nroCuota: json['nro_cuota'] ?? 0,
      fechaVencimiento: json['fecha_vencimiento'] ?? '',
      capital: (json['capital'] ?? 0).toDouble(),
      interes: (json['interes'] ?? 0).toDouble(),
      seguro: (json['seguro'] ?? 0).toDouble(),
      cuotaTotal: (json['cuota_total'] ?? 0).toDouble(),
      saldo: (json['saldo'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
      fechaPago: json['fecha_pago'],
    );
  }

  bool get pagada => estado == 'pagada';
}
