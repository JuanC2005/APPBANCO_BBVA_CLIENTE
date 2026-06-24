import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/solicitudes_provider.dart';
import '../theme/app_theme.dart';

class MisSolicitudesScreen extends ConsumerWidget {
  const MisSolicitudesScreen({super.key});

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

  IconData _estadoIcon(String estado) {
    switch (estado) {
      case 'aprobado': return Icons.check_circle;
      case 'desembolsado': return Icons.account_balance;
      case 'rechazado': return Icons.cancel;
      case 'enviado': return Icons.send;
      default: return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solicitudesAsync = ref.watch(solicitudesProvider);
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Solicitudes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nueva solicitud',
            onPressed: () => context.go('/home/nueva-solicitud'),
          ),
        ],
      ),
      body: solicitudesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: AppColors.darkGray),
              const SizedBox(height: 16),
              Text('Error: $e'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(solicitudesProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (solicitudes) {
          if (solicitudes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined, size: 80, color: AppColors.darkGray),
                  const SizedBox(height: 16),
                  const Text('No tienes solicitudes', style: TextStyle(fontSize: 18, color: AppColors.darkGray)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home/nueva-solicitud'),
                    icon: const Icon(Icons.add),
                    label: const Text('Solicitar crédito'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(solicitudesProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: solicitudes.length,
              itemBuilder: (_, i) {
                final s = solicitudes[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _estadoColor(s.estado).withValues(alpha: 0.2),
                      child: Icon(_estadoIcon(s.estado), color: _estadoColor(s.estado)),
                    ),
                    title: Text(f.format(s.montoSolicitado), style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${s.plazoMeses} meses · ${s.destinoCredito ?? ""}'),
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(s.estadoLabel, style: const TextStyle(color: Colors.white, fontSize: 11)),
                          backgroundColor: _estadoColor(s.estado),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/home/mis-solicitudes/${s.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
