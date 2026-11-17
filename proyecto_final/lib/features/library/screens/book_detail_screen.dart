import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyecto_final/features/library/models/book_model.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (book.imagePath != null && File(book.imagePath!).existsSync())
            Image.file(File(book.imagePath!), height: 250)
          else
            const Icon(Icons.book, size: 120),
          const SizedBox(height: 20),
          Text(
            book.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Autor: ${book.author}'),
          Text('Estado: ${book.status}'),
          if (book.genre != null) Text('Género: ${book.genre}'),
          if (book.pages != null) Text('Páginas: ${book.pages}'),
          if (book.year != null) Text('Año: ${book.year}'),
          if (book.synopsis != null) ...[
            const SizedBox(height: 16),
            const Text(
              'Sinopsis',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(book.synopsis!),
          ],
        ],
      ),
    );
  }
}