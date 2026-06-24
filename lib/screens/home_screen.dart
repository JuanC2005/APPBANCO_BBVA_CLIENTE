import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final homeAsync = ref.watch(homeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${auth.user?.nombres ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/home/notificaciones'),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: homeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: AppColors.darkGray),
              const SizedBox(height: 16),
              const Text('No se pudieron cargar los datos'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(homeProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(homeProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SaldoCard(saldo: data.saldoTotal),
              const SizedBox(height: 16),
              _QuickActions(onTap: (route) => context.go('/home/$route')),
              const SizedBox(height: 16),
              Text('Cuentas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...data.cuentas.map((c) => _CuentaMiniCard(
                    cuenta: c.cuenta,
                    onTap: () => context.go('/home/cuentas/${c.cuenta.id}'),
                  )),
              if (data.creditos.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Créditos', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...data.creditos.take(3).map((c) => _CreditoMiniCard(
                      credito: c,
                      onTap: () => context.go('/home/creditos/${c.id}/cronograma'),
                    )),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) {
          setState(() => _currentTab = i);
          switch (i) {
            case 0: context.go('/home');
            case 1: context.go('/home/cuentas');
            case 2: context.go('/home/tarjetas');
            case 3: context.go('/home/perfil');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_outlined), label: 'Cuentas'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card_outlined), label: 'Tarjetas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

class _SaldoCard extends StatelessWidget {
  final double saldo;
  const _SaldoCard({required this.saldo});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);
    return Card(
      color: AppColors.primaryBlue,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saldo total disponible', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Text(f.format(saldo), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final Function(String) onTap;
  const _QuickActions({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(icon: Icons.swap_horiz, label: 'Transferir', onTap: () => onTap('transferencia')),
        _ActionButton(icon: Icons.payments_outlined, label: 'Pagar', onTap: () => onTap('pago')),
        _ActionButton(icon: Icons.credit_card_outlined, label: 'Tarjetas', onTap: () => onTap('tarjetas')),
        _ActionButton(icon: Icons.description_outlined, label: 'Créditos', onTap: () => onTap('creditos')),
        _ActionButton(icon: Icons.assignment_outlined, label: 'Solicitudes', onTap: () => onTap('mis-solicitudes')),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBlue),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _CuentaMiniCard extends StatelessWidget {
  final dynamic cuenta;
  final VoidCallback onTap;
  const _CuentaMiniCard({required this.cuenta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
          child: const Icon(Icons.account_balance, color: AppColors.primaryBlue),
        ),
        title: Text(cuenta.numeroCuenta, style: const TextStyle(fontFamily: 'monospace')),
        subtitle: Text(cuenta.tipoLabel),
        trailing: Text(f.format(cuenta.saldoActual), style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}

class _CreditoMiniCard extends StatelessWidget {
  final dynamic credito;
  final VoidCallback onTap;
  const _CreditoMiniCard({required this.credito, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: credito.tieneMora ? AppColors.errorRed.withValues(alpha: 0.1) : AppColors.successGreen.withValues(alpha: 0.1),
          child: Icon(Icons.credit_score, color: credito.tieneMora ? AppColors.errorRed : AppColors.successGreen),
        ),
        title: Text(credito.producto),
        subtitle: Text('Saldo: ${f.format(credito.saldoActual)}'),
        trailing: Text('${credito.cuotasPagadas}/${credito.cuotasTotales}', style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }
}
