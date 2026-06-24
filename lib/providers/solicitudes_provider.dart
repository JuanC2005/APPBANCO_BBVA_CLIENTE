import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/solicitud_model.dart';
import '../core/api_client.dart';
import 'api_client_provider.dart';

final solicitudesProvider = FutureProvider.autoDispose<List<SolicitudModel>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final data = await api.getList('/homebanking/solicitudes');
  return data.map((e) => SolicitudModel.fromJson(e as Map<String, dynamic>)).toList();
});

final solicitudDetalleProvider = FutureProvider.family.autoDispose<SolicitudModel, String>((ref, id) async {
  final api = ref.watch(apiClientProvider);
  final data = await api.get('/homebanking/solicitudes/$id');
  return SolicitudModel.fromJson(data);
});

final crearSolicitudProvider = FutureProvider.autoDispose.family<SolicitudModel, Map<String, dynamic>>((ref, data) async {
  final api = ref.watch(apiClientProvider);
  final result = await api.post('/homebanking/solicitudes', {
    'monto_solicitado': data['monto'],
    'plazo_meses': data['plazo'],
    'destino_credito': data['destino'],
    'garantia': data['garantia'],
    'con_seguro': data['con_seguro'],
  });
  return SolicitudModel.fromJson(result);
});
