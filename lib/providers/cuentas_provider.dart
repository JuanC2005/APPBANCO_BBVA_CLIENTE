import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cuenta_model.dart';
import '../models/movimiento_model.dart';
import 'api_client_provider.dart';

final cuentasProvider = FutureProvider.autoDispose<List<CuentaModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.getList('/homebanking/cuentas');
  return response.map((c) => CuentaModel.fromJson(c as Map<String, dynamic>)).toList();
});

final movimientosPorCuentaProvider = FutureProvider.autoDispose.family<List<MovimientoModel>, String>((ref, cuentaId) async {
  final api = ref.read(apiClientProvider);
  final response = await api.getList('/homebanking/cuentas/$cuentaId/movimientos?limite=50');
  return response.map((m) => MovimientoModel.fromJson(m as Map<String, dynamic>)).toList();
});
