class MealFood {
  final String foodId;
  final String mealId;
  final num weight;
  final num scaledCalories;
  final num scaledProteins;
  final num scaledCarbohydrates;
  final num scaledFats;

  MealFood(this.foodId, this.mealId, this.weight, this.scaledCalories, this.scaledProteins, this.scaledCarbohydrates, this.scaledFats);

  factory MealFood.fromMap(Map<String, dynamic> map) {
    return MealFood(
      map['FoodId'],
      map['MealId'],
      map['Weight'],
      map['ScaledCalories'],
      map['scaledProteins'],
      map['ScaledCarbohydrates'],
      map['ScaledFats'],
    );
  }
}