class MovimientoModel {
  final String id;
  final String tipoMovimiento;
  final double monto;
  final String moneda;
  final String? descripcion;
  final String? referencia;
  final String fechaOperacion;
  final double saldoAnterior;
  final double saldoPosterior;

  MovimientoModel({
    required this.id,
    required this.tipoMovimiento,
    required this.monto,
    required this.moneda,
    this.descripcion,
    this.referencia,
    required this.fechaOperacion,
    required this.saldoAnterior,
    required this.saldoPosterior,
  });

  factory MovimientoModel.fromJson(Map<String, dynamic> json) {
    return MovimientoModel(
      id: json['id'] ?? '',
      tipoMovimiento: json['tipo_movimiento'] ?? '',
      monto: (json['monto'] ?? 0).toDouble(),
      moneda: json['moneda'] ?? 'PEN',
      descripcion: json['descripcion'],
      referencia: json['referencia'],
      fechaOperacion: json['fecha_operacion'] ?? '',
      saldoAnterior: (json['saldo_anterior'] ?? 0).toDouble(),
      saldoPosterior: (json['saldo_posterior'] ?? 0).toDouble(),
    );
  }

  bool get esIngreso {
    return tipoMovimiento == 'deposito' || tipoMovimiento == 'interes';
  }

  String get monedaSimbolo => moneda == 'USD' ? '\$' : 'S/';
}
