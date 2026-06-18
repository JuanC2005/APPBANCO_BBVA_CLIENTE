import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notificacion_model.dart';
import 'api_client_provider.dart';

final notificacionesProvider = FutureProvider.autoDispose<List<NotificacionModel>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.getList('/homebanking/notificaciones');
  return response.map((n) => NotificacionModel.fromJson(n as Map<String, dynamic>)).toList();
});

final marcarNotificacionLeidaProvider = FutureProvider.autoDispose.family<void, String>((ref, id) async {
  final api = ref.read(apiClientProvider);
  await api.put('/homebanking/notificaciones/$id/leer', {});
});

final marcarTodasLeidasProvider = FutureProvider.autoDispose<void>((ref) async {
  final api = ref.read(apiClientProvider);
  await api.put('/homebanking/notificaciones/leer-todas', {});
});
