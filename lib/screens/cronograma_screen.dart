import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/creditos_provider.dart';
import '../theme/app_theme.dart';

class CronogramaScreen extends ConsumerWidget {
  final String creditoId;
  const CronogramaScreen({super.key, required this.creditoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cronogramaAsync = ref.watch(cronogramaProvider(creditoId));
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Cronograma de Pagos')),
      body: cronogramaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (cuotas) {
          if (cuotas.isEmpty) return const Center(child: Text('Sin cronograma disponible'));
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ResumenItem(label: 'Total cuotas', value: '${cuotas.length}'),
                    _ResumenItem(label: 'Pagadas', value: '${cuotas.where((c) => c.pagada).length}'),
                    _ResumenItem(label: 'Pendientes', value: '${cuotas.where((c) => !c.pagada).length}'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cuotas.length,
                  itemBuilder: (_, i) {
                    final c = cuotas[i];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Cuota N°${c.nroCuota}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c.pagada
                                        ? AppColors.successGreen.withValues(alpha: 0.1)
                                        : AppColors.warningOrange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    c.pagada ? 'Pagada' : 'Pendiente',
                                    style: TextStyle(
                                      color: c.pagada ? AppColors.successGreen : AppColors.warningOrange,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            _CuotaRow(label: 'Vencimiento', value: c.fechaVencimiento),
                            _CuotaRow(label: 'Capital', value: f.format(c.capital)),
                            _CuotaRow(label: 'Interés', value: f.format(c.interes)),
                            _CuotaRow(label: 'Seguro', value: f.format(c.seguro)),
                            _CuotaRow(label: 'Cuota total', value: f.format(c.cuotaTotal), bold: true),
                            _CuotaRow(label: 'Saldo', value: f.format(c.saldo)),
                            if (c.fechaPago != null) _CuotaRow(label: 'Pagado el', value: c.fechaPago!),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final String label;
  final String value;
  const _ResumenItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.darkGray)),
      ],
    );
  }
}

class _CuotaRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _CuotaRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.darkGray, fontWeight: bold ? FontWeight.w500 : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
