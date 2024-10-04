import 'package:mealsmanagement/models/food.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/meal.dart';
import '../models/meal_food.dart';
import 'interfaces/IFoodRepository.dart';



class FoodRepository implements IFoodRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Food>> getFoods() async {
    final foods = await supabase.from("Foods").select();

    return List.generate(foods.length, (i) {
      return Food.fromMap(foods[i]);
    });
  }

  @override
  Future<void> addFood(Food food) async {
    await supabase.from('Foods').insert(food.toMap());
  }

  @override
  Future<void> updateFood(String foodId, Food food) async {
    await supabase.from('Foods').update(food.toMap()).eq('FoodId', foodId);
  }

  @override
  Future<void> deleteFood(String foodId) async {
    final food = Food.fromMap((await supabase.from('Foods').select().eq('FoodId', foodId)).first);
    final mealFoods = await supabase.from('MealFood').select().eq('FoodId', foodId);

    final mealIds = mealFoods.map((mf) =>
    MealFood
        .fromMap(mf)
        .mealId).toList();
    for (var mealId in mealIds) {
      final meal = Meal.FromMap(
          (await supabase.from('Meals').select().eq('MealId', mealId)).first);
      final updatedMeal = Meal(
          meal.totalCalories - food.calories,
          meal.totalProteins - food.proteins,
          meal.totalFats - food.fats,
          meal.totalCarbohydrates - food.carbohydrates,
          mealId: meal.mealId,
          name: meal.name
      );
      await supabase.from('Meals').update(updatedMeal.toMap()).eq('MealId', mealId);
    }
    await supabase.from('Foods').delete().eq('FoodId', foodId);
    await supabase.from('MealFood').delete().eq('FoodId', foodId);
  }

  @override
  Future<bool> searchFoodByName(String foodName) async {
    final food = await supabase.from('Foods').select().eq('Name', foodName);
    return food.isNotEmpty;
  }

}