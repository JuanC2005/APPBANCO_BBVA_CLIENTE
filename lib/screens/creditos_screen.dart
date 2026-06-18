import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/creditos_provider.dart';
import '../theme/app_theme.dart';

class CreditosScreen extends ConsumerWidget {
  const CreditosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditosAsync = ref.watch(creditosProvider);
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Créditos')),
      body: creditosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (creditos) {
          if (creditos.isEmpty) {
            return const Center(child: Text('No tienes créditos activos'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: creditos.length,
            itemBuilder: (_, i) {
              final c = creditos[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(c.producto, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          _EstadoBadge(estado: c.estado),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(label: 'Monto desembolsado', value: f.format(c.montoDesembolsado)),
                      _InfoRow(label: 'Saldo actual', value: f.format(c.saldoActual)),
                      _InfoRow(label: 'Plazo', value: '${c.plazoMeses} meses'),
                      _InfoRow(label: 'TEA', value: '${c.tea.toStringAsFixed(1)}%'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: c.progreso,
                                backgroundColor: Colors.grey[200],
                                color: c.tieneMora ? AppColors.errorRed : AppColors.successGreen,
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${c.cuotasPagadas}/${c.cuotasTotales}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_month, size: 18),
                          label: const Text('Ver cronograma'),
                          onPressed: () => context.go('/home/creditos/${c.id}/cronograma'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final String estado;
  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (estado) {
      case 'vigente': color = AppColors.successGreen; break;
      case 'vencido': color = AppColors.errorRed; break;
      case 'pagado': color = AppColors.darkGray; break;
      default: color = AppColors.warningOrange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(estado, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.darkGray)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
