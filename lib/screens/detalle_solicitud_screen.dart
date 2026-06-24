import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/solicitudes_provider.dart';
import '../theme/app_theme.dart';

class DetalleSolicitudScreen extends ConsumerWidget {
  final String solicitudId;
  const DetalleSolicitudScreen({super.key, required this.solicitudId});

  Color _estadoColor(String estado) {
    switch (estado) {
      case 'borrador': return Colors.grey;
      case 'enviado': return AppColors.primaryBlue;
      case 'recibido_comite': return Colors.orange;
      case 'en_evaluacion': return Colors.amber;
      case 'aprobado': return AppColors.successGreen;
      case 'condicionado': return Colors.amber.shade700;
      case 'desembolsado': return AppColors.successGreen;
      case 'rechazado': return AppColors.errorRed;
      default: return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _timeline(String estado) {
    final estados = [
      {'key': 'enviado', 'label': 'Enviado', 'icon': Icons.send},
      {'key': 'recibido_comite', 'label': 'Recibido en comité', 'icon': Icons.inbox},
      {'key': 'en_evaluacion', 'label': 'En evaluación', 'icon': Icons.search},
      {'key': 'aprobado', 'label': 'Decisión final', 'icon': Icons.gavel},
    ];

    return estados;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(solicitudDetalleProvider(solicitudId));
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Solicitud')),
      body: detalleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (s) {
          final estados = _timeline(s.estado);
          final estadoActualIdx = estados.indexWhere((e) {
            final order = ['enviado', 'recibido_comite', 'en_evaluacion', 'aprobado', 'condicionado', 'rechazado', 'desembolsado'];
            return order.indexOf(e['key'] as String) > order.indexOf(s.estado);
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: _estadoColor(s.estado).withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.description, color: _estadoColor(s.estado), size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.estadoLabel,
                                style: TextStyle(
                                    color: _estadoColor(s.estado),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            if (s.numeroExpediente != null)
                              Text('Exp. ${s.numeroExpediente}',
                                  style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Datos de la solicitud',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(),
                      _infoRow('Monto solicitado', f.format(s.montoSolicitado)),
                      _infoRow('Plazo', '${s.plazoMeses} meses'),
                      _infoRow('TEA', '${s.teaReferencial.toStringAsFixed(2)}%'),
                      _infoRow('Cuota mensual', f.format(s.cuotaEstimada)),
                      _infoRow('Garantía', s.garantiaLabel),
                      _infoRow('Destino', s.destinoCredito ?? '-'),
                      _infoRow('Seguro', s.conSeguro ? 'Con seguro' : 'Sin seguro'),
                      if (s.montoAprobado != null)
                        _infoRow('Monto aprobado', f.format(s.montoAprobado!)),
                      if (s.motivoRechazo != null)
                        _infoRow('Motivo rechazo', s.motivoRechazo!, AppColors.errorRed),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estado del trámite',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(),
                      ...estados.map((e) {
                        final isComplete = [
                          'enviado', 'recibido_comite', 'en_evaluacion', 'aprobado',
                          'condicionado', 'rechazado', 'desembolsado'
                        ].indexOf(e['key'] as String) <=
                            ['enviado', 'recibido_comite', 'en_evaluacion', 'aprobado',
                             'condicionado', 'rechazado', 'desembolsado'].indexOf(s.estado);
                        final isFinal = e['key'] == 'aprobado';

                        return Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isComplete ? AppColors.successGreen : Colors.grey,
                                  size: 24,
                                ),
                                if (!isFinal)
                                  Container(
                                    width: 2,
                                    height: 30,
                                    color: isComplete ? AppColors.successGreen : Colors.grey.shade300,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: EdgeInsets.only(bottom: isFinal ? 0 : 22),
                              child: Text(e['label'] as String,
                                  style: TextStyle(
                                    color: isComplete ? Colors.black : Colors.grey,
                                    fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
                                  )),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}
