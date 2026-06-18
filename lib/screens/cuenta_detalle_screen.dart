import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cuentas_provider.dart';
import '../theme/app_theme.dart';

class CuentaDetalleScreen extends ConsumerWidget {
  final String cuentaId;
  const CuentaDetalleScreen({super.key, required this.cuentaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuentasAsync = ref.watch(cuentasProvider);
    final movsAsync = ref.watch(movimientosPorCuentaProvider(cuentaId));
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return cuentasAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (cuentas) {
        final cuenta = cuentas.firstWhere((c) => c.id == cuentaId);
        return Scaffold(
          appBar: AppBar(title: Text(cuenta.tipoLabel)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: AppColors.primaryBlue,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo actual', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(f.format(cuenta.saldoActual),
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(cuenta.numeroCuenta,
                          style: const TextStyle(color: Colors.white70, fontFamily: 'monospace')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Últimos movimientos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              movsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (movs) => movs.isEmpty
                    ? const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Sin movimientos recientes')))
                    : Column(children: movs.map((m) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: m.esIngreso
                                  ? AppColors.successGreen.withValues(alpha: 0.1)
                                  : AppColors.errorRed.withValues(alpha: 0.1),
                              child: Icon(
                                m.esIngreso ? Icons.arrow_downward : Icons.arrow_upward,
                                color: m.esIngreso ? AppColors.successGreen : AppColors.errorRed,
                                size: 20,
                              ),
                            ),
                            title: Text(m.descripcion ?? m.tipoMovimiento, style: const TextStyle(fontSize: 14)),
                            subtitle: Text(m.fechaOperacion, style: const TextStyle(fontSize: 12)),
                            trailing: Text(
                              '${m.esIngreso ? '+' : '-'}${f.format(m.monto)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: m.esIngreso ? AppColors.successGreen : AppColors.errorRed,
                              ),
                            ),
                          ),
                        )).toList()),
              ),
            ],
          ),
        );
      },
    );
  }
}
