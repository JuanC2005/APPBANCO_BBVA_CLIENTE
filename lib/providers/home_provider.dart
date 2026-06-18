import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client_provider.dart';
import '../models/cuenta_model.dart';
import '../models/credito_model.dart';
import '../models/tarjeta_model.dart';
import '../models/notificacion_model.dart';
import '../models/movimiento_model.dart';

final homeProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get('/homebanking/dashboard');
  return HomeData.fromJson(response);
});

class HomeData {
  final double saldoTotal;
  final int numCuentas;
  final int numCreditos;
  final int numTarjetas;
  final int notificacionesNoLeidas;
  final List<CuentaConMovimientos> cuentas;
  final List<CreditoModel> creditos;
  final List<TarjetaModel> tarjetasRecientes;
  final List<NotificacionModel> notificacionesRecientes;

  HomeData({
    required this.saldoTotal,
    required this.numCuentas,
    required this.numCreditos,
    required this.numTarjetas,
    required this.notificacionesNoLeidas,
    required this.cuentas,
    required this.creditos,
    required this.tarjetasRecientes,
    required this.notificacionesRecientes,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      saldoTotal: (json['saldo_total'] ?? 0).toDouble(),
      numCuentas: json['num_cuentas'] ?? 0,
      numCreditos: json['num_creditos'] ?? 0,
      numTarjetas: json['num_tarjetas'] ?? 0,
      notificacionesNoLeidas: json['notificaciones_no_leidas'] ?? 0,
      cuentas: (json['cuentas'] as List? ?? [])
          .map((c) => CuentaConMovimientos.fromJson(c as Map<String, dynamic>))
          .toList(),
      creditos: (json['creditos'] as List? ?? [])
          .map((c) => CreditoModel.fromJson(c as Map<String, dynamic>))
          .toList(),
      tarjetasRecientes: (json['tarjetas_recientes'] as List? ?? [])
          .map((t) => TarjetaModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      notificacionesRecientes: (json['notificaciones_recientes'] as List? ?? [])
          .map((n) => NotificacionModel.fromJson(n as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CuentaConMovimientos {
  final CuentaModel cuenta;
  final List<MovimientoModel> ultimosMovimientos;

  CuentaConMovimientos({
    required this.cuenta,
    required this.ultimosMovimientos,
  });

  factory CuentaConMovimientos.fromJson(Map<String, dynamic> json) {
    return CuentaConMovimientos(
      cuenta: CuentaModel.fromJson(json['cuenta'] as Map<String, dynamic>),
      ultimosMovimientos: (json['ultimos_movimientos'] as List? ?? [])
          .map((m) => MovimientoModel.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
