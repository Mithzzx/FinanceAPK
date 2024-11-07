import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'accounts.dart';
import 'records.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables with proper foreign key constraints
    await db.execute('''
      CREATE TABLE Accounts (
        name TEXT PRIMARY KEY,
        currency TEXT NOT NULL,
        balance REAL NOT NULL,
        accountNumber INTEGER NOT NULL,
        accountType TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        accountName TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        dateTime TEXT NOT NULL,
        label TEXT,
        notes TEXT,
        payee TEXT,
        paymentType TEXT,
        FOREIGN KEY (accountName) REFERENCES Accounts (name)
          ON DELETE CASCADE
          ON UPDATE CASCADE
      )
    ''');
  }

  // Account operations
  Future<void> insertAccount(Account account) async {
    final db = await database;
    await db.insert('Accounts', account.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Accounts');
    return List.generate(maps.length, (i) => Account.fromMap(maps[i]));
  }

  // Record operations
  Future<void> insertRecord(Record record) async {
    final db = await database;
    await db.insert('Records', record.toMap());
  }

  Future<List<Record>> getRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Records');
    return List.generate(maps.length, (i) => Record.fromMap(maps[i]));
  }
}

// State Management
class FinanceState extends ChangeNotifier {
  List<Account> _accounts = [];
  List<Record> _records = [];
  final DatabaseHelper _db = DatabaseHelper();

  List<Account> get accounts => _accounts;
  List<Record> get records => _records;

  Future<void> loadData() async {
    _accounts = await _db.getAccounts();
    _records = await _db.getRecords();
    notifyListeners();
  }

  Future<void> addRecord(Record record) async {
    await _db.insertRecord(record);
    await loadData();
  }

  Future<void> addAccount(Account account) async {
    await _db.insertAccount(account);
    await loadData();
  }
}