import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();

  static Database? _database;

  DatabaseHelper.init();

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        localId INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE books(
        localId INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        status TEXT NOT NULL,
        imagePath TEXT,
        genre TEXT,
        pages INTEGER,
        year INTEGER,
        synopsis TEXT
      )
    ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('biblioteca_local.db');
    return _database!;
  }
}