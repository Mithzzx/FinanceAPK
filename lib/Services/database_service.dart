import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'accounts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE accounts(id INTEGER PRIMARY KEY, name TEXT, currency TEXT, balance REAL, accountNumber REAL, accountType TEXT, color INTEGER)',
        );
      },
    );
  }

  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    await db.insert('accounts', account, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> fetchAccounts() async {
    final db = await database;
    return await db.query('accounts');
  }
}