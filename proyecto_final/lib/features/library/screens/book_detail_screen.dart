import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del libro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Detalles del libro'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

