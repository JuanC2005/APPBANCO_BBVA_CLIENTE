import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client_provider.dart';

final transferenciaProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>((ref, data) async {
  final api = ref.read(apiClientProvider);
  final response = await api.post('/homebanking/transferencias', {
    'cuenta_origen_id': data['cuenta_origen_id'],
    'cuenta_destino': data['cuenta_destino'],
    'monto': data['monto'],
    'descripcion': data['descripcion'] ?? '',
  });
  return response;
});

final pagoCuotaProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>((ref, data) async {
  final api = ref.read(apiClientProvider);
  try {
    final response = await api.post('/homebanking/pagos', {
      'credito_id': data['credito_id'],
      'monto': data['monto'],
      'cuenta_origen_id': data['cuenta_origen_id'],
    });
    return response;
  } on HttpException catch (e) {
    return {'error': e.message};
  } catch (e) {
    return {'error': 'Error al procesar el pago'};
  }
});
