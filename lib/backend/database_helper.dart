import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'accounts.dart';
import 'budgets.dart';
import 'goals.dart';
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

        await db.execute('''
      CREATE TABLE Goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        savedAmount REAL NOT NULL,
        deadlineDate TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon INTEGER NOT NULL,
        notes TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE Budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        spentAmount REAL NOT NULL,
        period TEXT NOT NULL,
        categoryIds TEXT NOT NULL,
        accountName TEXT NOT NULL,
        overspendAlert INTEGER NOT NULL,
        alertAt75Percent INTEGER NOT NULL,
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

    Future<void> deleteRecord(int? recordId) async {
        final db = await database;
        await db.delete(
            'Records',
            where: 'id = ?',
            whereArgs: [recordId],
        );
    }

// Goal operations
    Future<void> insertGoal(Goal goal) async {
        final db = await database;
        await db.insert('Goals', goal.toMap());
    }

    Future<List<Goal>> getGoals() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('Goals');
        return List.generate(maps.length, (i) => Goal.fromMap(maps[i]));
    }
// Budget operations
    Future<void> insertBudget(Budget budget) async {
        final db = await database;
        await db.insert('Budgets', budget.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<Budget>> getBudgets() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query('Budgets');
        return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
    }

    Future<void> updateBudgetSpentAmount(int budgetId, double newAmount) async {
        final db = await database;
        await db.update(
            'Budgets',
            {'spentAmount': newAmount},
            where: 'id = ?',
            whereArgs: [budgetId],
        );
    }
}

// State Management
class FinanceState extends ChangeNotifier {
    List<Account> _accounts = [];
    List<Record> _records = [];
    List<Goal> _goals = [];
    List<Budget> _budgets = [];
    final DatabaseHelper _db = DatabaseHelper();

    List<Account> get accounts => _accounts;
    List<Record> get records => _records;
    List<Goal> get goals => _goals;
    List<Budget> get budgets => _budgets;

    Future<void> loadData() async {
        _accounts = await _db.getAccounts();
        _records = await _db.getRecords();
        _goals = await _db.getGoals();
        _budgets = await _db.getBudgets();
        await _updateAllBudgetSpentAmounts();
        notifyListeners();
    }

    Future<void> addRecord(Record record) async {
        await _db.insertRecord(record);
        _records.add(record);
        await _updateAllBudgetSpentAmounts();
        notifyListeners();
    }

    Future<void> deleteRecord(int? recordId) async {
        await _db.deleteRecord(recordId);
        _records.removeWhere((record) => record.id == recordId);
        await _updateAllBudgetSpentAmounts();
        notifyListeners();
    }

    Future<void> addAccount(Account account) async {
        await _db.insertAccount(account);
        await loadData();
    }

    Future<void> addGoal(Goal goal) async {
        await _db.insertGoal(goal);
        await loadData();
    }

    Future<void> updateGoal(Goal goal) async {
        final db = await _db.database;
        await db.update(
            'Goals',
            goal.toMap(),
            where: 'id = ?',
            whereArgs: [goal.id],
        );
        await loadData();
    }

    Future<void> updateGoalSavedAmount(int goalId, double newAmount) async {
        final db = await _db.database;
        await db.update(
            'Goals',
            {'savedAmount': newAmount},
            where: 'id = ?',
            whereArgs: [goalId],
        );
        await loadData();
    }

    Future<void> deleteGoal(int goalId) async {
        final db = await _db.database;
        await db.delete(
            'Goals',
            where: 'id = ?',
            whereArgs: [goalId],
        );
        await loadData();
    }

    Future<List<Budget>> getBudgets() async {
        return _budgets;
    }

    Future<List<Record>> getRecords() async {
        return _records;
    }

    Future<void> addBudget(Budget budget) async {
        await _db.insertBudget(budget);
        await loadData();
    }

    double _calculateBudgetSpentAmount(Budget budget, List<Record> records) {
        return records
            .where((record) => budget.matchesRecord(record))
            .fold(0.0, (sum, record) {
            if (record.amount < 0) {
                return sum + record.amount.abs();
            }
            return sum;
        });
    }

    Future<void> _updateAllBudgetSpentAmounts() async {
        for (var budget in _budgets) {
            double spentAmount = _calculateBudgetSpentAmount(budget, _records);
            if (spentAmount != budget.spentAmount) {
                await _db.updateBudgetSpentAmount(budget.id!, spentAmount);
                budget.spentAmount = spentAmount;
            }
        }
        notifyListeners();
    }

    Future<void> updateBudgetSpentAmount(int budgetId, double newAmount) async {
        await _db.updateBudgetSpentAmount(budgetId, newAmount);
        await loadData();  // Reload all data to refresh the state
    }

    Future<void> updateBudgets() async {
        final budgets = await getBudgets();
        final records = await getRecords();

        for (var budget in budgets) {
            double spentAmount = 0.0;
            final DateTime now = DateTime.now();

            for (var record in records) {
                if (!budget.categoryIds.contains(record.categoryId)) continue;
                if (budget.accountName != record.accountName) continue;

                final recordDate = DateTime.parse(record.dateTime as String);
                bool shouldCount = false;

                switch (budget.period) {
                    case 'weekly':
                        shouldCount = recordDate.isAfter(now.subtract(const Duration(days: 7)));
                        break;
                    case 'monthly':
                        shouldCount = recordDate.year == now.year &&
                            recordDate.month == now.month;
                        break;
                    case 'yearly':
                        shouldCount = recordDate.year == now.year;
                        break;
                    case 'onetime':
                        shouldCount = true;
                        break;
                }

                if (shouldCount) {
                    spentAmount += record.amount;
                }
            }

            await updateBudgetSpentAmount(budget.id!, spentAmount);
        }
    }
}