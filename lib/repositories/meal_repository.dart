import 'package:mealsmanagement/models/selected_food.dart';
import 'package:mealsmanagement/repositories/database_helper.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../models/meal_food.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();
  Future<Meal> getMealWithFoods(String mealId);
  Future<void> addMeal(Meal meal);
}

class MealRepository implements IMealRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Meal>> getMeals() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Meals');

    return List.generate(maps.length, (i) {
      return Meal.FromMap(maps[i]);
    });
  }

  @override
  Future<Meal> getMealWithFoods(String mealId) async {
    final db = await _databaseHelper.database;
    final mealResult = await db.query(
      'Meals',
      where: 'mealId = ?',
      whereArgs: [mealId],
    );

    final mealData = mealResult.first;

    // Query the meal-food relationships
    final mealFoodResult = await db.query(
      'MealFood',
      where: 'mealId = ?',
      whereArgs: [mealId],
    );

    // Extract foodIds
    final foodIds = mealFoodResult.map((mf) => mf['foodId']).toList();

    // Query all the foods associated with the meal
    final foods = await db.query(
      'Foods',
      where: 'foodId IN (${List.filled(foodIds.length, '?').join(', ')})',
      whereArgs: foodIds,
    );

    // Convert food query result into Food objects
    List<SelectedFood> selectedFoodList = foods.map((f) {
      var mf = MealFood.fromMap(mealFoodResult.where((mf) => mf['foodId'] == f['foodId'] && mf['mealId'] == mealId).first);
      var food = Food.fromMap(f);
      return SelectedFood(
        mf.scaledCalories,
        mf.scaledProteins,
        mf.scaledCarbohydrates,
        mf.scaledFats,
        food: food,
        weight: mf.weight
      );
    }).toList();

    print(selectedFoodList);
    // Return the Meal with the list of foods
    return Meal(
      mealId: mealData['MealId'] as String,
      name: mealData['Name'] as String,
      selectedFoods: selectedFoodList,
    );
  }

  @override
  Future<void> addMeal(Meal meal) async {
    final db = await _databaseHelper.database;

    // Insert the Meal into the Meal table
    await db.insert('Meals', {
      'mealId': meal.mealId,
      'name': meal.name,
    });

    if (meal.selectedFoods != null) {
      for (var selectedFood in meal.selectedFoods!) {
        // Insert the relation into the MealFood table
        await db.insert('MealFood', {
          'mealId': meal.mealId,
          'foodId': selectedFood.food.foodId,
          'weight': selectedFood.weight,
          'scaledCalories': selectedFood.scaledCalories,
          'scaledFats': selectedFood.scaledFats,
          'scaledProteins': selectedFood.scaledProteins,
          'scaledCarbohydrates': selectedFood.scaledCarbohydrates
        });
      }
    }
  }
}
