class CuentaModel {
  final String id;
  final String numeroCuenta;
  final String tipoCuenta;
  final String moneda;
  final double saldoActual;
  final String estado;
  final String fechaApertura;

  CuentaModel({
    required this.id,
    required this.numeroCuenta,
    required this.tipoCuenta,
    required this.moneda,
    required this.saldoActual,
    required this.estado,
    required this.fechaApertura,
  });

  factory CuentaModel.fromJson(Map<String, dynamic> json) {
    return CuentaModel(
      id: json['id'] ?? '',
      numeroCuenta: json['numero_cuenta'] ?? '',
      tipoCuenta: json['tipo_cuenta'] ?? '',
      moneda: json['moneda'] ?? 'PEN',
      saldoActual: (json['saldo_actual'] ?? 0).toDouble(),
      estado: json['estado'] ?? '',
      fechaApertura: json['fecha_apertura'] ?? '',
    );
  }

  String get tipoLabel {
    switch (tipoCuenta) {
      case 'ahorros': return 'Cuenta de Ahorros';
      case 'corriente': return 'Cuenta Corriente';
      case 'plazo_fijo': return 'Plazo Fijo';
      default: return tipoCuenta;
    }
  }

  String get monedaSimbolo => moneda == 'USD' ? '\$' : 'S/';
}
