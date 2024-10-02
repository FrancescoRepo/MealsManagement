import 'package:mealsmanagement/models/selected_food.dart';

class Meal {
  final String mealId;
  final String name;
  final num totalCalories;
  final num totalProteins;
  final num totalFats;
  final num totalCarbohydrates;
  final List<SelectedFood>? selectedFoods;

  Meal(
    this.totalCalories,
    this.totalProteins,
    this.totalFats,
    this.totalCarbohydrates, {
    required this.mealId,
    required this.name,
    this.selectedFoods,
  });

  factory Meal.FromMap(Map<String, dynamic> meal) {
    return Meal(meal['TotalCalories'], meal['TotalProteins'], meal['TotalFats'],
        meal['TotalCarbohydrates'],
        mealId: meal['MealId'], name: meal['Name']);
  }

  Map<String, dynamic> toMap() {
    return {
      'MealId': mealId,
      'Name': name,
      'TotalCalories': totalCalories,
      'TotalProteins': totalProteins,
      'TotalFats': totalFats,
      'TotalCarbohydrates': totalCarbohydrates
    };
  }
}
