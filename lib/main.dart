import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigation/routes.dart';
import 'viewmodel/auth_viewmodel.dart';
import 'viewmodel/home_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const MyApp(), // ✅ const
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // ✅ const

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BBVA Home Banking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      routerConfig: router,
    );
  }
}
