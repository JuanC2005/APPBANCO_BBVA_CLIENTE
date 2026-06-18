import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/tarjetas_provider.dart';
import '../theme/app_theme.dart';

class TarjetasScreen extends ConsumerWidget {
  const TarjetasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarjetasAsync = ref.watch(tarjetasProvider);
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Tarjetas')),
      body: tarjetasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tarjetas) {
          if (tarjetas.isEmpty) {
            return const Center(child: Text('No tienes tarjetas registradas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tarjetas.length,
            itemBuilder: (_, i) {
              final t = tarjetas[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    t.tipoTarjeta == 'credito'
                                        ? Icons.credit_card
                                        : Icons.account_balance_wallet,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(t.marca, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      const SizedBox(height: 2),
                                      Text(t.numeroTarjeta,
                                          style: const TextStyle(fontFamily: 'monospace', fontSize: 16, letterSpacing: 2),
                                          overflow: TextOverflow.ellipsis, maxLines: 1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: t.estado == 'activa'
                                  ? AppColors.successGreen.withValues(alpha: 0.1)
                                  : AppColors.errorRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              t.estado,
                              style: TextStyle(
                                color: t.estado == 'activa' ? AppColors.successGreen : AppColors.errorRed,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Vence: ${t.fechaVencimiento}', style: const TextStyle(color: AppColors.darkGray)),
                      if (t.tipoTarjeta == 'credito') ...[
                        const Divider(),
                        _TarjetaRow(label: 'Límite de crédito', value: f.format(t.limiteCredito)),
                        _TarjetaRow(label: 'Saldo utilizado', value: f.format(t.saldoUtilizado)),
                        _TarjetaRow(label: 'Disponible', value: f.format(t.disponible)),
                      ],
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

class _TarjetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _TarjetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
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
