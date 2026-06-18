import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authProvider.notifier).checkSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
