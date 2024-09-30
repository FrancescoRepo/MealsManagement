part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class LoadFoods extends FoodEvent{}

class AddFood extends FoodEvent {
  final Food food;
  const AddFood(this.food);

  @override
  List<Object> get props => [food];
}

class UpdateFood extends FoodEvent {
  final String foodId;
  final Food food;
  const UpdateFood(this.foodId, this.food);

  @override
  List<Object> get props => [foodId, food];
}

class DeleteFood extends FoodEvent {
  final String foodId;
  const DeleteFood(this.foodId);

  @override
  List<Object> get props => [foodId];
}

