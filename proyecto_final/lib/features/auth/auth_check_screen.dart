import 'package:flutter/material.dart';
import 'package:proyecto_final/core/storage/local_storage_service.dart';
import 'package:proyecto_final/features/library/screens/home_screen.dart';
import 'package:proyecto_final/features/library/screens/login_screen.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await _storageService.getToken();

    if (!mounted) {
      return;
    }

    if (token != null && token.isNotEmpty) {
      // home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}