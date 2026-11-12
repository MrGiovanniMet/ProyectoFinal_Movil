import 'package:proyecto_final/features/auth/screens/register_screen.dart';
import 'package:proyecto_final/features/auth/services/auth_services.dart';
import 'package:proyecto_final/features/auth/widget/custom_text_field.dart';
import 'package:proyecto_final/features/library/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _iniciarSesion() async {
    setState(() {
      _isLoading = true;
    });

    bool success = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inicio de sesión exitoso')),
      );

      // navegación hacia HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correo o contraseña incorrectos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Mi Biblioteca',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                label: 'Correo electrónico',
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                label: 'Contraseña',
                obscureText: true,
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _iniciarSesion,
                      child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                    ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('¿No tienes cuenta? Regístrate'),
              ),
            ]
          ),
        ),
      ),
    );
  }
}