import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mealsmanagement/models/meal.dart';
import 'package:mealsmanagement/repositories/meals_repository.dart';
import 'package:meta/meta.dart';

part 'meals_event.dart';
part 'meals_state.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealRepository _mealRepository;

  MealsBloc(this._mealRepository) : super(MealsLoading()) {
    on<LoadMeals>(_onLoadMeals);
    on<AddMeal>(_onAddMeal);
  }

  void _onLoadMeals(LoadMeals event, Emitter<MealsState> emit) async {
    try {
        final meals = await _mealRepository.getMeals();
        emit(MealsLoaded(meals));
    }
    catch(e) {

    }
  }

  void _onAddMeal(AddMeal event, Emitter<MealsState> emit) async {
      await _mealRepository.addMeal(event.meal);
      add(LoadMeals());
  }

  void loadMeals() => add(LoadMeals());
}
