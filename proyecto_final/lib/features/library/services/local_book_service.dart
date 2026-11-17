import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/features/library/models/book_model.dart';

class LocalBookService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertBook(BookModel book) async {
    final db = await dbHelper.database;
    return await db.insert('books', book.toMap());
  }

  // lectura de los libros del usuario con ese id 
  Future<List<BookModel>> getBooks(int userId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return BookModel.fromMap(maps[i]);
    });
  }
}