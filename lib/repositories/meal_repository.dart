import 'package:mealsmanagement/models/selected_food.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../models/meal_food.dart';
import 'interfaces/IMealRepository.dart';

class MealRepository implements IMealRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Meal>> getMeals() async {
    final meals = await supabase.from('Meals').select();
    return List.generate(meals.length, (i) {
      return Meal.FromMap(meals[i]);
    });
  }

  @override
  Future<Meal> getMealWithFoods(String mealId) async {
    final mealData = Meal.FromMap(
        (await supabase.from('Meals').select().eq('MealId', mealId)).first);

    final mealFoods = await supabase
        .from('MealFood')
        .select()
        .eq('MealId', mealId);

    // Extract foodIds
    final foodIds = mealFoods.map((mf) => mf['FoodId']).toList();

    // Query all the foods associated with the meal
    final foods =
        await supabase.from('Foods').select().inFilter('FoodId', foodIds);

    // Convert food query result into Food objects
    List<SelectedFood> selectedFoodList = foods.map((f) {
      var mf = MealFood.fromMap(mealFoods
          .where((mf) => mf['FoodId'] == f['FoodId'] && mf['MealId'] == mealId)
          .first);
      var food = Food.fromMap(f);
      return SelectedFood(mf.scaledCalories, mf.scaledProteins,
          mf.scaledCarbohydrates, mf.scaledFats,
          food: food, weight: mf.weight);
    }).toList();

    // Return the Meal with the list of foods
    return Meal(
      mealData.totalCalories,
      mealData.totalProteins,
      mealData.totalFats,
      mealData.totalCarbohydrates,
      mealId: mealData.mealId,
      name: mealData.name,
      selectedFoods: selectedFoodList,
    );
  }

  @override
  Future<bool> searchMealByName(String mealName) async {
    final meal = await supabase.from('Meals').select();
    return meal.isNotEmpty;
  }

  @override
  Future<void> addMeal(Meal meal) async {
    await supabase.from('Meals').insert(meal.toMap());

    if (meal.selectedFoods != null) {
      for (var selectedFood in meal.selectedFoods!) {
        // Insert the relation into the MealFood table
        await supabase.from('MealFood').insert({
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

  @override
  Future<void> updateMealWithFoods(String mealId, Meal meal) async {
    await supabase.from('Meals').update(meal.toMap()).eq('MealId', mealId);
    await supabase.from('MealFood').delete().eq('MealId', mealId);
    if (meal.selectedFoods != null) {
      for (var selectedFood in meal.selectedFoods!) {
        await supabase.from('MealFood').insert({
          'MealId': meal.mealId,
          'FoodId': selectedFood.food.foodId,
          'Weight': selectedFood.weight,
          'ScaledCalories': selectedFood.scaledCalories,
          'ScaledFats': selectedFood.scaledFats,
          'ScaledProteins': selectedFood.scaledProteins,
          'ScaledCarbohydrates': selectedFood.scaledCarbohydrates
        });
      }
    }
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    await supabase.from('Meals').delete().eq('MealId', mealId);
  }
}
