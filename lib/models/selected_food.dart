import 'food.dart';

class SelectedFood {
  final Food food;
  final num weight;
  final num scaledCalories;
  final num scaledProteins;
  final num scaledCarbohydrates;
  final num scaledFats;

  SelectedFood(this.scaledCalories, this.scaledProteins, this.scaledCarbohydrates,
      this.scaledFats,
      {required this.food, required this.weight});
}