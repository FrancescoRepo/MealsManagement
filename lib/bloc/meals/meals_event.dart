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


