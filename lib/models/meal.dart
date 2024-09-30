import 'dart:ffi';

import 'package:flutter_guid/flutter_guid.dart';

class Meal {
  final String mealId;
  final String name;
  final String valueFor;
  final num calories;
  final num carbohydrates;
  final num fats;
  final num proteins;

  Meal(this.mealId, this.name, this.valueFor, this.calories, this.carbohydrates, this.fats, this.proteins);

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      map['MealId'],
      map['Name'],
      map['ValueFor'],
      map['Calories'],
      map['Carbohydrates'],
      map['Fats'],
      map['Proteins'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MealId': mealId,
      'Name': name,
      'ValueFor': valueFor,
      'Calories': calories,
      'Carbohydrates': carbohydrates,
      'Fats': fats,
      'Proteins': proteins,
    };
  }
}