part of 'meal_bloc.dart';

@immutable
abstract class MealState {
  const MealState();

  @override
  List<Object> get props => [];
}

class MealsLoading extends MealState {}
class MealLoading extends MealState{}

class MealsLoaded extends MealState {
  final List<Meal> meals;
  const MealsLoaded(this.meals);

  @override
  List<Object> get props => [meals];
}

class MealLoaded extends MealState {
  final Meal meal;
  const MealLoaded(this.meal);

  @override
  List<Object> get props => [meal];
}

class MealExists extends MealState {}
class MealNotExisting extends MealState{}
class CreateMeal extends MealState {}

class MealsError extends MealState {
  final String errorMessage;
  const MealsError({required this.errorMessage});

  @override
  List<Object> get props => [];
}

class NoInternetConnectivity extends MealState {
  @override
  List<Object> get props => [];
}


