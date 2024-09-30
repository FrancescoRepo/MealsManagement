part of 'meals_bloc.dart';

@immutable
abstract class MealsEvent {
  const MealsEvent();

  @override
  List<Object> get props => [];
}

class LoadMeals extends MealsEvent{}

class AddMeal extends MealsEvent {
  final Meal meal;
  const AddMeal(this.meal);

  @override
  List<Object> get props => [meal];
}

class UpdateMeal extends MealsEvent {
  final String mealId;
  final Meal meal;
  const UpdateMeal(this.mealId, this.meal);

  @override
  List<Object> get props => [meal];
}

class DeleteMeal extends MealsEvent {
  final String mealId;
  const DeleteMeal(this.mealId);

  @override
  List<Object> get props => [mealId];
}

