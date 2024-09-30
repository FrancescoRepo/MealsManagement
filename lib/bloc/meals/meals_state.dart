part of 'meals_bloc.dart';

@immutable
abstract class MealsState {
  const MealsState();

  @override
  List<Object> get props => [];
}

class MealsLoading extends MealsState {}

class MealsLoaded extends MealsState {
  final List<Meal> meals;
  const MealsLoaded(this.meals);

  @override
  List<Object> get props => [];
}
