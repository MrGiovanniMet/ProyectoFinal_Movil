import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final/features/library/models/book_model.dart';


class AddBookScreen extends StatefulWidget {
  final int userId;

  const AddBookScreen({super.key, required this.userId});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();
  final _yearController = TextEditingController();
  final _synopsisController = TextEditingController();

  String _selectedStatus = 'Pendiente';
  final List<String> _statuses = ['Pendiente', 'Leyendo', 'Leído'];

  String? _imagePath;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final newBook = BookModel(
        userId: widget.userId,
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        status: _selectedStatus,
        imagePath: _imagePath,
        genre: _genreController.text.trim().isEmpty
            ? null
            : _genreController.text.trim(),
        pages: int.tryParse(_pagesController.text.trim()),
        year: int.tryParse(_yearController.text.trim()),
        synopsis: _synopsisController.text.trim().isEmpty
            ? null
            : _synopsisController.text.trim(),
      );
      Navigator.pop(context, newBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Libro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_imagePath != null)
                Image.file(File(_imagePath!), height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Galería'),
                  ),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                  ),
                ],
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese un autor';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                items: _statuses
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              TextFormField(
                controller: _genreController,
                decoration:
                    const InputDecoration(labelText: 'Género (opcional)'),
              ),
              TextFormField(
                controller: _pagesController,
                decoration:
                    const InputDecoration(labelText: 'Páginas (opcional)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Año (opcional)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Por favor ingrese un número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _synopsisController,
                decoration:
                    const InputDecoration(labelText: 'Sinopsis (opcional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBook,
                child: const Text('Guardar Libro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}