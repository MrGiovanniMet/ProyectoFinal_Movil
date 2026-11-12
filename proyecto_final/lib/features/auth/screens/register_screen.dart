import 'package:flutter/material.dart';
import 'package:proyecto_final/features/auth/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool success = await _authService.register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
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
          const SnackBar(content: Text('Cuenta creada, ya puedes iniciar sesión')),
        );
        // regresa al login
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ese correo ya está registrado'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Nombre de usuario'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese su correo';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor ingrese un correo válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener 8 caracteres o más';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirmar contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su contraseña';
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registrar,
                      child: const Text('Crear cuenta'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}