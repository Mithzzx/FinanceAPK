import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Records.dart';
import 'accounts.dart';

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
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Accounts (
        name TEXT PRIMARY KEY,
        currency TEXT,
        balance REAL,
        accountNumber INTEGER,
        accountType TEXT,
        color INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE Records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        accountName TEXT,
        categoryId INTEGER,
        dateTime TEXT,
        label TEXT,
        notes TEXT,
        payee TEXT,
        paymentType TEXT,
        warranty TEXT,
        status TEXT,
        location TEXT,
        photo TEXT,
        FOREIGN KEY (accountName) REFERENCES Accounts (name)
      )
    ''');

    // Insert the sample account
    await db.insert('Accounts', {
      'name': 'Sample Account',
      'currency': 'USD',
      'balance': 1000.0,
      'accountNumber': 123456789,
      'accountType': 'savings',
      'color': 0xFF2196F3,
    });

    // Insert the sample record
    await db.insert('Records', {
      'amount': 0.0,
      'accountName': 'Sample Account',
      'categoryId': 0, // Assuming a default category id
      'dateTime': DateTime.now().toIso8601String(),
      'label': 'Sample label',
      'notes': 'Sample notes',
      'payee': 'Sample payee',
      'paymentType': 'Sample payment type',
      'warranty': 'Sample warranty',
      'status': 'Sample status',
      'location': 'Sample location',
      'photo': 'Sample photo',
    });
  }

  Future<void> insertRecord(Record record) async {
    final db = await database;
    await db.insert('Records', record.toMap());
    await updateRecordsList();
  }

  Future<void> updateRecord(Record record) async {
    final db = await database;
    await db.update('Records', record.toMap(), where: 'id = ?', whereArgs: [record.id]);
    await updateRecordsList();
  }

  Future<void> deleteRecord(int id) async {
    final db = await database;
    await db.delete('Records', where: 'id = ?', whereArgs: [id]);
    await updateRecordsList();
  }

  Future<List<Record>> fetchRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Records');

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Record.fromMap(maps[i]);
    });
  }

  Future<void> updateRecordsList() async {
    Records = await fetchRecords();
  }

  Future<int> insertAccount(Account account) async {
    final db = await database;
    return await db.insert('Accounts', account.toMap());
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Accounts');
    return List.generate(maps.length, (i) {
      return Account.fromMap(maps[i]);
    });
  }

  Future<void> updateAccountsList() async {
    accounts = await getAccounts();
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;
    return await db.update(
      'Accounts',
      account.toMap(),
      where: 'name = ?',
      whereArgs: [account.name],
    );
  }

  Future<int> deleteAccount(String name) async {
    final db = await database;
    return await db.delete(
      'Accounts',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}