import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryBlue,
            child: Text(
              (user?.nombres.isNotEmpty == true ? user!.nombres[0] : '?') +
                  (user?.apellidos.isNotEmpty == true ? user!.apellidos[0] : ''),
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.nombreCompleto ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _PerfilItem(icon: Icons.badge_outlined, label: 'Documento', value: user?.numeroDocumento ?? ''),
                const Divider(height: 1),
                _PerfilItem(icon: Icons.email_outlined, label: 'Email', value: user?.email ?? '—'),
                const Divider(height: 1),
                _PerfilItem(icon: Icons.phone_outlined, label: 'Teléfono', value: user?.telefono ?? '—'),
                const Divider(height: 1),
                _PerfilItem(icon: Icons.home_outlined, label: 'Dirección', value: user?.direccion ?? '—'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: AppColors.errorRed),
              label: const Text('Cerrar sesión', style: TextStyle(color: AppColors.errorRed)),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PerfilItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PerfilItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(label, style: const TextStyle(color: AppColors.darkGray, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
