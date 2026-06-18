import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tarjeta_model.dart';
import 'api_client_provider.dart';

final tarjetasProvider = FutureProvider.autoDispose<List<TarjetaModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.getList('/homebanking/tarjetas');
  return response.map((t) => TarjetaModel.fromJson(t as Map<String, dynamic>)).toList();
});
