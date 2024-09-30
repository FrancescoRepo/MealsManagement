part of 'meal_bloc.dart';

@immutable
abstract class MealEvent {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadMeals extends MealEvent{}

class LoadMeal extends MealEvent {
  final String mealId;
  const LoadMeal(this.mealId);

  @override
  List<Object> get props => [mealId];
}
class AddMeal extends MealEvent {
  final Meal meal;
  const AddMeal(this.meal);

  @override
  List<Object> get props => [meal];
}
