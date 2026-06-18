import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credito_model.dart';
import '../models/cuota_model.dart';
import 'api_client_provider.dart';

final creditosProvider = FutureProvider.autoDispose<List<CreditoModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.getList('/homebanking/creditos');
  return response.map((c) => CreditoModel.fromJson(c as Map<String, dynamic>)).toList();
});

final cronogramaProvider = FutureProvider.autoDispose.family<List<CuotaModel>, String>((ref, creditoId) async {
  final api = ref.read(apiClientProvider);
  final response = await api.getList('/homebanking/creditos/$creditoId/cronograma');
  return response.map((c) => CuotaModel.fromJson(c as Map<String, dynamic>)).toList();
});
