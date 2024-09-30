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
    on<UpdateMeal>(_onUpdateMeal);
    on<DeleteMeal>(_onDeleteMeal);
  }

  void _onLoadMeals(LoadMeals event, Emitter<MealsState> emit) async {
    try {
        final meals = await _mealRepository.getMeals();
        emit(MealsLoaded(meals));
    }
    catch(e) {
        emit(const MealError(errorMessage: "Failed to load meals"));
    }
  }

  void _onAddMeal(AddMeal event, Emitter<MealsState> emit) async {
    try {
      await _mealRepository.addMeal(event.meal);
      add(LoadMeals());
    }
    catch(e) {
      emit(const MealError(errorMessage: "Failed to create a new meal"));
    }
  }

  void _onUpdateMeal(UpdateMeal event, Emitter<MealsState> emit) async {
    try{
      await _mealRepository.updateMeal(event.mealId, event.meal);
      add(LoadMeals());
    }
    catch(e) {
      emit(const MealError(errorMessage: "Failed to update the selected meal"));
    }
  }

  void _onDeleteMeal(DeleteMeal event, Emitter<MealsState> emit) async {
    try {
      await _mealRepository.deleteMeal(event.mealId);
      add(LoadMeals());
    }
    catch(e) {
      emit(const MealError(errorMessage: "Failed to delete the selected meal"));
    }
  }

  void loadMeals() => add(LoadMeals());
}
