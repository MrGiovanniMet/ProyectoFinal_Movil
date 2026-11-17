import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proyecto_final/core/storage/local_storage_service.dart';
import 'package:proyecto_final/features/auth/screens/login_screen.dart';
import 'package:proyecto_final/features/library/models/book_model.dart';
import 'package:proyecto_final/features/library/screens/add_book_screen.dart';
import 'package:proyecto_final/features/library/screens/book_detail_screen.dart';
import 'package:proyecto_final/features/library/services/local_book_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalBookService _dbService = LocalBookService();
  final LocalStorageService _storage = LocalStorageService();

  List<BookModel> _books = [];
  bool _isLoading = false;
  int _userId = 0;

  String _search = '';
  String _statusFilter = 'Todos';
  final List<String> _filters = ['Todos', 'Leído', 'Leyendo', 'Pendiente'];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
    });

    // el "token" guardado es el id del usuario
    final token = await _storage.getToken();
    _userId = int.tryParse(token ?? '') ?? 0;

    final books = await _dbService.getBooks(_userId);

    if (!mounted) return;

    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  // libros que coinciden con el buscador y el filtro de estado
  List<BookModel> get _filteredBooks {
    return _books.where((book) {
      final text = _search.toLowerCase();
      final matchesSearch = book.title.toLowerCase().contains(text) ||
          book.author.toLowerCase().contains(text);
      final matchesStatus =
          _statusFilter == 'Todos' || book.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> _goToAddBook() async {
    final BookModel? newBook = await Navigator.push<BookModel>(
      context,
      MaterialPageRoute(builder: (context) => AddBookScreen(userId: _userId)),
    );

    if (newBook != null) {
      await _dbService.insertBook(newBook);
      _loadBooks();
    }
  }

  Widget _buildCover(BookModel book) {
    if (book.imagePath != null && File(book.imagePath!).existsSync()) {
      return Image.file(
        File(book.imagePath!),
        width: 50,
        height: 70,
        fit: BoxFit.cover,
      );
    }
    return const Icon(Icons.book, size: 40);
  }

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Librería'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Cerrar sesión"),
                  content: Text("¿Estás seguro de que deseas cerrar sesión?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      child: Text("Cerrar sesión"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por título o autor',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DropdownButtonFormField<String>(
              value: _statusFilter,
              items: _filters
                  .map((filter) => DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _statusFilter = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : books.isEmpty
                    ? const Center(child: Text('No tienes libros registrados'))
                    : ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              leading: _buildCover(book),
                              title: Text(
                                book.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('${book.author} - ${book.status}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailScreen(book: book),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddBook,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _logout() async {
    final storage = LocalStorageService();
    await storage.deleteToken();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}