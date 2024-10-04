import '../../models/food.dart';

abstract class IFoodRepository {
  Future<List<Food>> getFoods();

  Future<bool> searchFoodByName(String foodName);

  Future<void> addFood(Food food);

  Future<void> updateFood(String foodId, Food food);

  Future<void> deleteFood(String foodId);
}