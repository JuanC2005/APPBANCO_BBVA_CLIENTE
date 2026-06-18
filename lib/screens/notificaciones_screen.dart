import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notificaciones_provider.dart';
import '../providers/api_client_provider.dart';
import '../theme/app_theme.dart';

class NotificacionesScreen extends ConsumerWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificacionesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              try {
                final api = ref.read(apiClientProvider);
                await api.put('/homebanking/notificaciones/leer-todas', {});
                ref.invalidate(notificacionesProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todas marcadas como leídas')),
                  );
                }
              } catch (_) {}
            },
          ),
        ],
      ),
      body: notifAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (notificaciones) {
          if (notificaciones.isEmpty) {
            return const Center(child: Text('No tienes notificaciones'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notificaciones.length,
            itemBuilder: (_, i) {
              final n = notificaciones[i];
              return Card(
                color: n.leida ? null : AppColors.primaryBlue.withValues(alpha: 0.03),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorForType(n.tipo).withValues(alpha: 0.1),
                    child: Icon(_iconForType(n.tipo), color: _colorForType(n.tipo), size: 20),
                  ),
                  title: Text(n.titulo, style: TextStyle(fontWeight: n.leida ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.mensaje, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(n.createdAt, style: const TextStyle(fontSize: 11, color: AppColors.darkGray)),
                    ],
                  ),
                  trailing: n.leida ? null : Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onTap: () async {
                    if (!n.leida) {
                      try {
                        final api = ref.read(apiClientProvider);
                        await api.put('/homebanking/notificaciones/${n.id}/leer', {});
                        ref.invalidate(notificacionesProvider);
                      } catch (_) {}
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _colorForType(String tipo) {
    switch (tipo) {
      case 'pago': return AppColors.successGreen;
      case 'alerta': return AppColors.errorRed;
      case 'promocion': return AppColors.accentGold;
      case 'seguridad': return AppColors.warningOrange;
      default: return AppColors.primaryBlue;
    }
  }

  IconData _iconForType(String tipo) {
    switch (tipo) {
      case 'pago': return Icons.payments;
      case 'alerta': return Icons.warning_amber;
      case 'promocion': return Icons.local_offer;
      case 'seguridad': return Icons.security;
      default: return Icons.notifications;
    }
  }
}
