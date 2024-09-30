import 'package:bloc/bloc.dart';
import 'package:mealsmanagement/repositories/meal_repository.dart';
import 'package:meta/meta.dart';

import '../../models/meal.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _mealRepository;

  MealBloc(this._mealRepository) : super(MealsLoading()) {
    on<LoadMeals>(_onLoadMeals);
    on<AddMeal>(_onAddMeal);
    on<LoadMeal>(_onLoadMeal);
  }

  void _onLoadMeals(LoadMeals event, Emitter<MealState> emit) async {
    try {
      emit(MealsLoading());
      var meals = await _mealRepository.getMeals();
      emit(MealsLoaded(meals));
    }
    catch(e) {
      emit(const MealsError(errorMessage: "Failed to load meals"));
    }
  }

  void _onLoadMeal(LoadMeal event, Emitter<MealState> emit) async {
    try {
      emit(MealLoading());
      var meal = await _mealRepository.getMealWithFoods(event.mealId);
      emit(MealLoaded(meal));
    }
    catch(e) {
      emit(const MealsError(errorMessage: "Failed to load meal"));
    }
  }

  void _onAddMeal(AddMeal event, Emitter<MealState> emit) async {
    try{
        await _mealRepository.addMeal(event.meal);
        add(LoadMeals());
    }
    catch(e) {
      emit(const MealsError(errorMessage: "Failed to create a new meal"));
    }
  }

  void loadMeals() => add(LoadMeals());
}
