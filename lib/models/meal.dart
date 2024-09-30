import 'dart:ffi';

import 'package:flutter_guid/flutter_guid.dart';

class Meal {
  final String mealId;
  final String name;
  final num weight;
  final num calories;
  final num carbohydrates;
  final num fats;
  final num proteins;

  Meal(this.mealId, this.name, this.weight, this.calories, this.carbohydrates, this.fats, this.proteins);

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      map['MealId'],
      map['Name'],
      map['Weight'],
      map['Calories'],
      map['Carbohydrates'],
      map['Fats'],
      map['Proteins'],
    );
  }

  Map<String, dynamic> toMap(String mealId) {
    return {
      'MealId': mealId,
      'Name': name,
      'Weight': weight,
      'Calories': calories,
      'Carbohydrates': carbohydrates,
      'Fats': fats,
      'Proteins': proteins,
    };
  }
}