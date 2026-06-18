import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/cuentas_provider.dart';
import '../theme/app_theme.dart';

class CuentasScreen extends ConsumerWidget {
  const CuentasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cuentasAsync = ref.watch(cuentasProvider);
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Cuentas')),
      body: cuentasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: AppColors.darkGray),
              const SizedBox(height: 16),
              Text('Error: $e'),
            ],
          ),
        ),
        data: (cuentas) => cuentas.isEmpty
            ? const Center(child: Text('No tienes cuentas registradas'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cuentas.length,
                itemBuilder: (_, i) {
                  final c = cuentas[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
                        child: const Icon(Icons.account_balance, color: AppColors.primaryBlue),
                      ),
                      title: Text(c.numeroCuenta, style: const TextStyle(fontFamily: 'monospace')),
                      subtitle: Text(c.tipoLabel),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(f.format(c.saldoActual), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(c.moneda, style: const TextStyle(color: AppColors.darkGray, fontSize: 12)),
                        ],
                      ),
                      onTap: () => context.go('/home/cuentas/${c.id}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
