import '../../models/meal.dart';

abstract class IMealRepository {
  Future<List<Meal>> getMeals();

  Future<Meal> getMealWithFoods(String mealId);

  Future<bool> searchMealByName(String mealName);

  Future<void> addMeal(Meal meal);

  Future<void> updateMealWithFoods(String mealId, Meal meal);

  Future<void> deleteMeal(String mealId);
}