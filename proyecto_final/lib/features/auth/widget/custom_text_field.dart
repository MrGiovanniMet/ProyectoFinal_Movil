import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText && _oculto,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(),

        
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_oculto ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _oculto = !_oculto;
                  });
                },
              )
            : null,
      ),
    );
  }
}