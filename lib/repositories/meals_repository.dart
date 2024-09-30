import 'package:mealsmanagement/models/meal.dart';

import 'database_helper.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();
  Future<void> addMeal(Meal meal);
  Future<void> updateMeal(String mealId, Meal meal);
  Future<void> deleteMeal(String mealId);
}

class MealRepository implements IMealRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> addMeal(Meal meal) async {
    final db = await _databaseHelper.database;
    await db.insert('meals', meal.toMap());
  }

  @override
  Future<List<Meal>> getMeals() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Meals');

    // Convert List<Map<String, dynamic>> to List<Meal>
    return List.generate(maps.length, (i) {
      return Meal.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateMeal(String mealId, Meal meal) async {
    final db = await _databaseHelper.database;
    await db.update('Meals', meal.toMap(), where: 'MealId = ?', whereArgs: [mealId]);
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    final db = await _databaseHelper.database;
    await db.delete('Meals', where: 'MealId = ?', whereArgs: [mealId]);
  }

}