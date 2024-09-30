import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meals_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Meals (
            MealId TEXT PRIMARY KEY,
            Name TEXT NOT NULL,
            Weight REAL NOT NULL,
            Calories REAL NOT NULL,
            Carbohydrates REAL NOT NULL,
            Fats REAL NOT NULL,
            Proteins REAL NOT NULL
          );
        ''');
      },
    );
  }
}
