import 'package:proyecto_final/core/database/database_helper.dart';
import 'package:proyecto_final/core/storage/local_storage_service.dart';
import 'package:proyecto_final/features/auth/models/user_model.dart';

class AuthService {
  final LocalStorageService _storageService = LocalStorageService();

  // Valida correo y contraseña contra la base de datos
  Future<bool> login(String email, String password) async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) {
      return false;
    }

    final user = UserModel.fromMap(result.first);
    await _storageService.saveToken(user.localId.toString());
    return true;
  }

  // Crea una cuenta nueva (se usa en register_screen)
  Future<bool> register(String username, String email, String password) async {
    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty) {
      return false;
    }

    final user = UserModel(
      username: username,
      email: email,
      password: password,
    );
    await db.insert('users', user.toMap());
    return true;
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }
}