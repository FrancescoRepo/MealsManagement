import 'package:mealsmanagement/models/food.dart';

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
    await db.update('Foods', food.toMap(), where: 'FoodId = ?', whereArgs: [foodId]);
  }

  @override
  Future<void> deleteFood(String foodId) async {
    final db = await _databaseHelper.database;
    await db.delete('Foods', where: 'FoodId = ?', whereArgs: [foodId]);
  }

  @override
  Future<bool> searchFoodByName(String foodName) async{
    final db = await _databaseHelper.database;
    final food = await db.query('Foods', where: 'Name = ?', whereArgs: [foodName]);
    return food.isNotEmpty;
  }

}