import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/selected_food.dart';

class MealDetailCubit extends Cubit<MealDetailState> {
  MealDetailCubit()
      : super(MealDetailState(
    selectedFoods: [],
    totalCalories: 0,
    totalProteins: 0,
    totalFats: 0,
    totalCarbohydrates: 0,
  ));

  // Add food to meal and update the total values
  void addFoodToMeal(SelectedFood food) {
    final updatedFoods = List<SelectedFood>.from(state.selectedFoods)..add(food);

    final updatedState = state.copyWith(
      selectedFoods: updatedFoods,
      totalCalories: state.totalCalories + food.scaledCalories,
      totalProteins: state.totalProteins + food.scaledProteins,
      totalFats: state.totalFats + food.scaledFats,
      totalCarbohydrates: state.totalCarbohydrates + food.scaledCarbohydrates,
    );
    emit(updatedState);
  }

  // Remove food from meal and update the total values
  void removeFoodFromMeal(int index) {
    final updatedFoods = List<SelectedFood>.from(state.selectedFoods)..removeAt(index);
    final removedFood = state.selectedFoods[index];

    final updatedState = state.copyWith(
      selectedFoods: updatedFoods,
      totalCalories: state.totalCalories - removedFood.scaledCalories,
      totalProteins: state.totalProteins - removedFood.scaledProteins,
      totalFats: state.totalFats - removedFood.scaledFats,
      totalCarbohydrates: state.totalCarbohydrates - removedFood.scaledCarbohydrates,
    );
    emit(updatedState);
  }

  // Update the meal foods when loading an existing meal
  void loadMealFoods(List<SelectedFood> foods) {
    num totalCalories = 0;
    num totalProteins = 0;
    num totalFats = 0;
    num totalCarbohydrates = 0;

    for (var food in foods) {
      totalCalories += food.scaledCalories;
      totalProteins += food.scaledProteins;
      totalFats += food.scaledFats;
      totalCarbohydrates += food.scaledCarbohydrates;
    }

    emit(MealDetailState(
      selectedFoods: foods,
      totalCalories: totalCalories,
      totalProteins: totalProteins,
      totalFats: totalFats,
      totalCarbohydrates: totalCarbohydrates,
    ));
  }

  // Reset the state when starting a new meal
  void resetMeal() {
    emit(MealDetailState(
      selectedFoods: [],
      totalCalories: 0,
      totalProteins: 0,
      totalFats: 0,
      totalCarbohydrates: 0,
    ));
  }
}

class MealDetailState {
  final List<SelectedFood> selectedFoods;
  final num totalCalories;
  final num totalProteins;
  final num totalFats;
  final num totalCarbohydrates;

  MealDetailState({
    required this.selectedFoods,
    required this.totalCalories,
    required this.totalProteins,
    required this.totalFats,
    required this.totalCarbohydrates,
  });

  MealDetailState copyWith({
    List<SelectedFood>? selectedFoods,
    num? totalCalories,
    num? totalProteins,
    num? totalFats,
    num? totalCarbohydrates,
  }) {
    return MealDetailState(
      selectedFoods: selectedFoods ?? this.selectedFoods,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteins: totalProteins ?? this.totalProteins,
      totalFats: totalFats ?? this.totalFats,
      totalCarbohydrates: totalCarbohydrates ?? this.totalCarbohydrates,
    );
  }
}
