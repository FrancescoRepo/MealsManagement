import 'package:mealsmanagement/models/food.dart';

import '../models/meal.dart';
import '../models/meal_food.dart';
import 'database_helper.dart';

abstract class IFoodRepository {
  Future<List<Food>> getFoods();

  Future<bool> searchFoodByName(String foodName);

  Future<void> addFood(Food food);

  Future<void> updateFood(String foodId, Food food);

  Future<void> deleteFood(String foodId);
}

class FoodRepository implements IFoodRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Food>> getFoods() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Foods');

    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  @override
  Future<void> addFood(Food food) async {
    final db = await _databaseHelper.database;
    await db.insert('Foods', food.toMap());
  }

  @override
  Future<void> updateFood(String foodId, Food food) async {
    final db = await _databaseHelper.database;
    await db.update(
        'Foods', food.toMap(), where: 'FoodId = ?', whereArgs: [foodId]);
  }

  @override
  Future<void> deleteFood(String foodId) async {
    final db = await _databaseHelper.database;
    final food = Food.fromMap((await db.query(
        'Foods', where: 'FoodId = ?', whereArgs: [foodId])).first);
    final mealFoods = await db.query(
        'MealFood', where: 'FoodId = ?', whereArgs: [foodId]);
    final mealIds = mealFoods.map((mf) =>
    MealFood
        .fromMap(mf)
        .mealId).toList();
    for (var mealId in mealIds) {
      final meal = Meal.FromMap(
          (await db.query('Meals', where: 'MealId = ?', whereArgs: [mealId]))
              .first);
      final updatedMeal = Meal(
          meal.totalCalories - food.calories,
          meal.totalProteins - food.proteins,
          meal.totalFats - food.fats,
          meal.totalCarbohydrates - food.carbohydrates,
          mealId: meal.mealId,
          name: meal.name
      );
      await db.update('Meals', updatedMeal.toMap(), where: 'MealId = ?', whereArgs: [mealId]);
    }
    await db.delete('Foods', where: 'FoodId = ?', whereArgs: [foodId]);
    await db.delete('MealFood', where: 'FoodId = ?', whereArgs: [foodId]);
  }

  @override
  Future<bool> searchFoodByName(String foodName) async {
    final db = await _databaseHelper.database;
    final food = await db.query(
        'Foods', where: 'Name = ?', whereArgs: [foodName]);
    return food.isNotEmpty;
  }

}