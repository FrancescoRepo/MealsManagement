import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mealsmanagement/bloc/network/network_cubit.dart';
import 'package:mealsmanagement/models/food.dart';
import 'package:mealsmanagement/repositories/food_repository.dart';
import 'package:meta/meta.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository _foodRepository;
  final NetworkCubit _networkCubit;

  FoodBloc(this._foodRepository, this._networkCubit) : super(FoodsLoading()) {
    on<LoadFoods>(_onLoadFoods);
    on<SearchFoodByName>(_onSearchFoodByName);
    on<AddFood>(_onAddFood);
    on<UpdateFood>(_onUpdateFood);
    on<DeleteFood>(_onDeleteFood);
  }

  void _onLoadFoods(LoadFoods event, Emitter<FoodState> emit) async {
    try {
      final isConnected = _networkCubit.state.status == ConnectionStatus.connected;
      if(isConnected) {
        final meals = await _foodRepository.getFoods();
        emit(FoodsLoaded(meals));
      } else {
        emit(NoInternetConnectivity());
      }
    }
    catch(e) {
        emit(const FoodsError(errorMessage: "Failed to load foods"));
    }
  }

  void _onSearchFoodByName(SearchFoodByName event, Emitter<FoodState> emit) async {
    try {
      final foodExists = await _foodRepository.searchFoodByName(event.foodName);
      if(foodExists) {
        emit(FoodExist());
      } else {
        emit(FoodNotExisting());
      }
    }
    catch(e) {
      emit(const FoodsError(errorMessage: "Failed to search the inserted food"));
    }
  }

  void _onAddFood(AddFood event, Emitter<FoodState> emit) async {
    try {
      await _foodRepository.addFood(event.food);
      add(LoadFoods());
    }
    catch(e) {
      emit(const FoodsError(errorMessage: "Failed to create a new food"));
    }
  }

  void _onUpdateFood(UpdateFood event, Emitter<FoodState> emit) async {
    try{
      await _foodRepository.updateFood(event.foodId, event.food);
      add(LoadFoods());
    }
    catch(e) {
      emit(const FoodsError(errorMessage: "Failed to update the selected food"));
    }
  }

  void _onDeleteFood(DeleteFood event, Emitter<FoodState> emit) async {
    try {
      await _foodRepository.deleteFood(event.foodId);
      add(LoadFoods());
    }
    catch(e) {
      emit(const FoodsError(errorMessage: "Failed to delete the selected food"));
    }
  }

  void loadFoods() => add(LoadFoods());
}
