class CreditoModel {
  final String id;
  final String producto;
  final double montoDesembolsado;
  final int plazoMeses;
  final double tea;
  final double saldoActual;
  final String estado;
  final int cuotasTotales;
  final int cuotasPagadas;
  final int cuotasMora;
  final String? fechaDesembolso;
  final String? fechaVencimiento;

  CreditoModel({
    required this.id,
    required this.producto,
    required this.montoDesembolsado,
    required this.plazoMeses,
    required this.tea,
    required this.saldoActual,
    required this.estado,
    required this.cuotasTotales,
    required this.cuotasPagadas,
    required this.cuotasMora,
    this.fechaDesembolso,
    this.fechaVencimiento,
  });

  factory CreditoModel.fromJson(Map<String, dynamic> json) {
    return CreditoModel(
      id: json['id'] ?? '',
      producto: json['producto'] ?? '',
      montoDesembolsado: (json['monto_desembolsado'] ?? 0).toDouble(),
      plazoMeses: json['plazo_meses'] ?? 0,
      tea: (json['tea'] ?? 0).toDouble(),
      saldoActual: (json['saldo_actual'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
      cuotasTotales: json['cuotas_totales'] ?? 0,
      cuotasPagadas: json['cuotas_pagadas'] ?? 0,
      cuotasMora: json['cuotas_mora'] ?? 0,
      fechaDesembolso: json['fecha_desembolso'],
      fechaVencimiento: json['fecha_vencimiento'],
    );
  }

  double get progreso => cuotasTotales > 0 ? cuotasPagadas / cuotasTotales : 0;

  bool get tieneMora => cuotasMora > 0;
}
