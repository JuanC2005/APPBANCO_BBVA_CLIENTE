import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/home_viewmodel.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/typography.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: BBVAColors.white, // Fondo blanco
      appBar: AppBar(
        title: Text(
          'Bienvenido, ${homeViewModel.clientName}',
          style: BBVATypography.titleMedium.copyWith(
            color: BBVAColors.white,
          ),
        ),
        backgroundColor: BBVAColors.primaryBlue, // Barra azul BBVA
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: BBVAColors.white),
            onPressed: () {
              if (context.mounted) {
                GoRouter.of(context).push('/');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Resumen de tus productos',
                style: BBVATypography.titleMedium.copyWith(
                  color: BBVAColors.primaryBlue, // Título azul
                ),
              ),
              const SizedBox(height: 20),
              // Tarjeta de cuenta de ahorros
              Card(
                elevation: 4,
                color: BBVAColors.lightGray, // Fondo gris claro
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: BBVAColors.primaryBlue, // Borde azul
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuenta de Ahorros',
                        style: BBVATypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: BBVAColors.primaryBlue, // Texto azul
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Número: ${homeViewModel.savingsAccount.accountNumber}',
                        style: BBVATypography.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Saldo: S/ ${homeViewModel.savingsAccount.balance.toStringAsFixed(2)}',
                        style: BBVATypography.titleMedium.copyWith(
                          color: BBVAColors
                              .secondaryBlue, // Azul oscuro para el saldo
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tarjeta de crédito
              Card(
                elevation: 4,
                color: BBVAColors.lightGray, // Fondo gris claro
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: BBVAColors.primaryBlue, // Borde azul
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarjeta de Crédito',
                        style: BBVATypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: BBVAColors.primaryBlue, // Texto azul
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Número: ${homeViewModel.activeCredit.creditNumber}',
                        style: BBVATypography.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Monto pendiente: S/ ${homeViewModel.activeCredit.pendingAmount.toStringAsFixed(2)}',
                        style: BBVATypography.titleMedium.copyWith(
                          color: BBVAColors
                              .errorRed, // Rojo para el monto pendiente
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Estado: ${homeViewModel.activeCredit.status}',
                        style: BBVATypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Esta funcionalidad se implementará en S10'),
                backgroundColor: BBVAColors.primaryBlue, // SnackBar azul
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: BBVAColors.primaryBlue),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet,
                color: BBVAColors.primaryBlue),
            label: 'Cuentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card, color: BBVAColors.primaryBlue),
            label: 'Créditos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: BBVAColors.primaryBlue),
            label: 'Perfil',
          ),
        ],
        selectedItemColor:
            BBVAColors.secondaryBlue, // Ícono seleccionado en azul oscuro
        unselectedItemColor: BBVAColors.darkGray,
        backgroundColor: BBVAColors.white, // Fondo blanco para la barra
      ),
    );
  }
}
