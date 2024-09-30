import 'package:mealsmanagement/models/selected_food.dart';

class Meal {
  final String mealId;
  final String name;
  final List<SelectedFood>? selectedFoods;

  Meal({
    required this.mealId,
    required this.name,
    this.selectedFoods,
  });

  factory Meal.FromMap(Map<String, dynamic> meals) => Meal(
      mealId: meals['MealId'],
      name: meals['Name']
    );
}