import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Records.dart';

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
    String path = join(await getDatabasesPath(), 'records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER,
        account TEXT,
        category TEXT,
        dateTime TEXT,
        label TEXT,
        notes TEXT,
        payee TEXT,
        paymentType TEXT,
        warranty TEXT,
        status TEXT,
        location TEXT,
        photo TEXT
      )
    ''');
  }

  Future<void> insertRecord(Record record) async {
    final db = await database;
    await db.insert(
      'records',
      {
        'amount': record.amount ? 1 : 0,
        'account': record.account.name, // Assuming Account has a name attribute
        'category': record.category.name,
        'dateTime': record.dateTime.toIso8601String(),
        'label': record.label.name,
        'notes': record.notes,
        'payee': record.payee,
        'paymentType': record.paymentType,
        'warranty': record.warranty,
        'status': record.status,
        'location': record.location,
        'photo': record.photo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}