import 'dart:ffi';

import 'package:flutter_guid/flutter_guid.dart';

class Food {
  final String foodId;
  final String name;
  final String valueFor;
  final num calories;
  final num carbohydrates;
  final num fats;
  final num proteins;

  Food(this.foodId, this.name, this.valueFor, this.calories, this.carbohydrates, this.fats, this.proteins);

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      map['FoodId'],
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
      'FoodId': foodId,
      'Name': name,
      'ValueFor': valueFor,
      'Calories': calories,
      'Carbohydrates': carbohydrates,
      'Fats': fats,
      'Proteins': proteins,
    };
  }
}