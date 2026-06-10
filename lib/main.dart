import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tablas_primaria/screens/home_screen.dart';
import 'package:tablas_primaria/services/pro_mode_service.dart';
import 'package:tablas_primaria/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProModeService.instance.load();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const TablasApp());
}

/// App educativa de tablas de multiplicar (1-12) para niños de primaria.
class TablasApp extends StatelessWidget {
  const TablasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tablas de Multiplicar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
