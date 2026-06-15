import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app_colors.dart';
import 'app/app_constants.dart';
import 'app/app_theme.dart';
import 'screens/ingredient_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartFridgeApp());
}

class SmartFridgeApp extends StatelessWidget {
  const SmartFridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Fridge',
      theme: buildAppTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: AppConstants.useMockData ? const IngredientScreen() : const _StartupGate(),
    );
  }
}

class _StartupGate extends StatelessWidget {
  const _StartupGate();

  static final Future<void> _startup = _init();

  static Future<void> _init() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _startup,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupLoading();
        }
        if (snapshot.hasError) {
          return const _StartupError();
        }
        return const IngredientScreen();
      },
    );
  }
}

class _StartupLoading extends StatelessWidget {
  const _StartupLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Firebase initialization failed. Please add your Firebase config and retry.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
