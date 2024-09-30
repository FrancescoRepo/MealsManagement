import 'package:flutter_guid/flutter_guid.dart';
import 'package:mealsmanagement/models/meal.dart';

import 'database_helper.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();
  Future<void> addMeal(Meal meal);

}

class MealRepository implements IMealRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> addMeal(Meal meal) async {
    final db = await _databaseHelper.database;
    await db.insert('meals', meal.toMap(Guid.newGuid.toString()));
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

}