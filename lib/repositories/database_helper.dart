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
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Foods (
            FoodId TEXT PRIMARY KEY,
            Name TEXT NOT NULL,
            ValueFor TEXT NOT NULL,
            Calories REAL NOT NULL,
            Carbohydrates REAL NOT NULL,
            Fats REAL NOT NULL,
            Proteins REAL NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE Meals (
            MealId TEXT PRIMARY KEY,
            Name TEXT,
            TotalCalories REAL NULL,
            TotalProteins REAL NULL,
            TotalFats REAL NULL,
            TotalCarbohydrates REAL NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE MealFood (
            MealId TEXT,
            FoodId TEXT,
            Weight REAL NOT NULL,
            ScaledCalories REAL NULL,
            ScaledFats REAL NULL,
            ScaledCarbohydrates REAL NULL,
            ScaledProteins REAL NULL,
            PRIMARY KEY (MealId, FoodId),
            FOREIGN KEY (MealId) REFERENCES Meals(MealId) ON DELETE CASCADE,
            FOREIGN KEY (FoodId) REFERENCES Foods(FoodId) ON DELETE CASCADE
          );
        ''');
      },
    );
  }
}
