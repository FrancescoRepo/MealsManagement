part of 'food_bloc.dart';

@immutable
abstract class FoodState {
  const FoodState();

  @override
  List<Object> get props => [];
}

class FoodsLoading extends FoodState {}

class FoodsLoaded extends FoodState {
  final List<Food> foods;
  const FoodsLoaded(this.foods);

  @override
  List<Object> get props => [];
}

class FoodExist extends FoodState{}
class FoodNotExisting extends FoodState{}

class FoodsError extends FoodState {
  final String errorMessage;
  const FoodsError({required this.errorMessage});

  @override
  List<Object> get props => [];
}

