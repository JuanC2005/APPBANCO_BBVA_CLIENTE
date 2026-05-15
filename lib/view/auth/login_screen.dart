import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../../ui/theme/colors.dart';
import '../../ui/theme/typography.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final TextEditingController dniController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: BBVAColors.white, // Fondo blanco
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'assets/images/bbva_logo.png',
                height: 120,
              ),
              const SizedBox(height: 20),
              Text(
                'BBVA',
                style: BBVATypography.titleLarge.copyWith(
                  color: BBVAColors.primaryBlue, // Azul BBVA para el título
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: dniController,
                decoration: InputDecoration(
                  labelText: 'Usuario/DNI',
                  fillColor: BBVAColors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: BBVAColors.primaryBlue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: BBVAColors.primaryBlue,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  fillColor: BBVAColors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: BBVAColors.primaryBlue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: BBVAColors.primaryBlue,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (authViewModel.isLoading)
                const CircularProgressIndicator(
                  color: BBVAColors.primaryBlue, // Loading azul
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final currentContext = context;
                      bool success = await authViewModel.login(
                        dniController.text,
                        passwordController.text,
                      );
                      if (success && currentContext.mounted) {
                        GoRouter.of(currentContext).push('/dashboard');
                      } else if (currentContext.mounted) {
                        ScaffoldMessenger.of(currentContext).showSnackBar(
                          SnackBar(
                            content: Text(authViewModel.errorMessage),
                            backgroundColor: BBVAColors.errorRed,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          BBVAColors.primaryBlue, // Botón azul BBVA
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Ingresar',
                      style: BBVATypography.button,
                    ),
                  ),
                ),
              if (authViewModel.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    authViewModel.errorMessage,
                    style: const TextStyle(color: BBVAColors.errorRed),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
