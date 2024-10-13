import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mealsmanagement/bloc/food/food_bloc.dart';
import 'package:mealsmanagement/bloc/meal/meal_bloc.dart';
import 'package:mealsmanagement/bloc/meal/meal_detail_cubit.dart';

import '../models/food.dart';
import '../models/meal.dart';
import '../models/selected_food.dart';

class MealDetailPage extends StatefulWidget {
  final String? mealId;

  const MealDetailPage({super.key, this.mealId});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mealNameController = TextEditingController();
  final TextEditingController _foodSearchController = TextEditingController();
  final TextEditingController _foodWeightController = TextEditingController();
  bool mealExists = false;

  bool get isEdit => widget.mealId != null;
  bool selectedFoodsEmpty = true;
  String? _selectedFoodId;

  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(LoadFoods());
    if (isEdit) {
      context.read<MealBloc>().add(LoadMeal(widget.mealId!));
    } else {
      context.read<MealBloc>().add(CreatingMeal());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: const Text('Meal Details'),
        leading: BackButton(
          onPressed: () {
            context.read<MealDetailCubit>().resetMeal();
            context.read<MealBloc>().add(LoadMeals());
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          if (state is MealLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealLoaded) {
            _mealNameController.text = state.meal.name;
            selectedFoodsEmpty = state.meal.selectedFoods == null;
            context.read<MealDetailCubit>().loadMealFoods(
                selectedFoodsEmpty ? [] : state.meal.selectedFoods!);
          } else if (state is CreateMeal) {
          } else if (state is MealExists) {
            mealExists = true;
          } else if (state is MealNotExisting) {
            mealExists = false;
          }
          return PopScope(
              canPop: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Meal Name
                      TextFormField(
                        controller: _mealNameController,
                        style: const TextStyle(color: Colors.white),
                        // Text input style
                        decoration: const InputDecoration(
                          labelText: 'Meal Name',
                          labelStyle:
                              TextStyle(color: Colors.white70), // Label style
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a meal name';
                          }
                          return null;
                        },
                        onChanged: (mealName) {
                          BlocProvider.of<MealBloc>(context)
                              .add(SearchMealByName(mealName));
                        },
                      ),
                      if (mealExists)
                        const Text(
                          'Meal already exists!',
                          style: TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 10),
                      // Searchable Dropdown for Food Selection
                      buildSearchDropDown(),
                      const SizedBox(height: 10),
                      // Specify Food Weight
                      TextFormField(
                        controller: _foodWeightController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Food Weight (g)',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              num.tryParse(value) == null) {
                            return 'Please enter the weight';
                          }
                          return null;
                        },
                      ),

                      // Add Food Button
                      Center(
                        child: IconButton(
                          onPressed: _addFoodToMeal,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.cyan, // Text color
                          ),
                          icon: const Icon(Icons.add),
                        ),
                      ),

                      selectedFoodsEmpty
                          ? Container()
                          : buildRecapNutritionalValues(),
                      // Display Selected Foods
                      buildSelectedFoodList(),
                    ],
                  ),
                ),
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "saveMealBtn",
        onPressed: mealExists ? null : _saveMeal,
        backgroundColor: mealExists ? Colors.grey : Colors.cyan,
        foregroundColor: Colors.white,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget buildSelectedFoodList() {
    return BlocBuilder<MealDetailCubit, MealDetailState>(
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            itemCount: state.selectedFoods.length,
            itemBuilder: (context, index) {
              final selectedFood = state.selectedFoods[index];
              return Card(
                color: const Color.fromRGBO(75, 85, 100, 1.0),
                child: ListTile(
                  title: Text(
                    '${selectedFood.food.name} - ${selectedFood.weight}g',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Calories: ${selectedFood.scaledCalories.truncate()}, Proteins: ${selectedFood.scaledProteins.truncate()}, Fats: ${selectedFood.scaledFats.truncate()}, Carbs: ${selectedFood.scaledCarbohydrates.truncate()}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeFoodFromMeal(index);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildRecapNutritionalValues() {
    return BlocBuilder<MealDetailCubit, MealDetailState>(
      builder: (context, state) {
        if (state.selectedFoods.isEmpty) {
          return Container();
        }
        return Center(
          child: Card(
            color: const Color.fromRGBO(75, 85, 100, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Nutritional Values:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Calories: ${state.totalCalories.truncate()}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Proteins: ${state.totalProteins.truncate()}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Fats: ${state.totalFats.truncate()}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Carbohydrates: ${state.totalCarbohydrates.truncate()}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchDropDown() {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      if (state is FoodsLoading) {
        return const CircularProgressIndicator();
      } else if (state is FoodsLoaded) {
        return FocusScope(
          child: TypeAheadField<Food>(
            controller: _foodSearchController,
            hideOnUnfocus: false,
            builder: (context, controller, focusNode) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Search Food',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                ),
                validator: (value) {
                  if (_selectedFoodId == null) {
                    return 'Please select a food';
                  }
                  return null;
                },
              );
            },
            suggestionsCallback: (pattern) {
              return state.foods
                  .where((food) =>
                      food.name.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            },
            retainOnLoading: true,
            itemBuilder: (context, Food suggestion) {
              return ListTile(
                title: Text(suggestion.name,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  'Calories: ${suggestion.calories.truncate()}, Proteins: ${suggestion.proteins.truncate()}, Fats: ${suggestion.fats.truncate()}, Carbs: ${suggestion.carbohydrates.truncate()}',
                  style: const TextStyle(color: Colors.white70),
                ),
                tileColor: const Color.fromRGBO(75, 85, 100, 1.0),
              );
            },
            onSelected: (Food suggestion) {
              _selectedFoodId = suggestion.foodId;
              _foodSearchController.text = suggestion.name;
            },
          ),
        );
      }
      return Container();
    });
  }

  void _addFoodToMeal() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      // Find the selected food from the Bloc's state
      final foodsState = context.read<FoodBloc>().state;
      if (foodsState is FoodsLoaded) {
        final selectedFood = foodsState.foods
            .firstWhere((food) => food.foodId == _selectedFoodId);
        final weight = num.parse(_foodWeightController.text);
        final mealDetailState = context.read<MealDetailCubit>().state;

        if (mealDetailState.selectedFoods
            .where((sf) => sf.food.foodId == _selectedFoodId)
            .isEmpty) {
          // Calculate scaled nutritional values based on the weight entered
          final scaledCalories = (selectedFood.calories / 100) * weight;
          final scaledProteins = (selectedFood.proteins / 100) * weight;
          final scaledFats = (selectedFood.fats / 100) * weight;
          final scaledCarbohydrates =
              (selectedFood.carbohydrates / 100) * weight;

          context.read<MealDetailCubit>().addFoodToMeal(SelectedFood(
                scaledCalories,
                scaledProteins,
                scaledCarbohydrates,
                scaledFats,
                food: selectedFood,
                weight: weight,
              ));

          _foodSearchController.clear();
          _foodWeightController.clear();
          _selectedFoodId = null;
          FocusScope.of(context).requestFocus(FocusNode());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Food already added to the list!'),
            backgroundColor: Colors.deepOrangeAccent,
            closeIconColor: Colors.white,
            showCloseIcon: true,
          ));
        }
      }
    }
  }

  void _removeFoodFromMeal(int index) {
    context.read<MealDetailCubit>().removeFoodFromMeal(index);
  }

  void _saveMeal() {
    if (_mealNameController.text.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      var mealDetailState = context.read<MealDetailCubit>().state;

      final meal = Meal(
          mealDetailState.totalCalories,
          mealDetailState.totalProteins,
          mealDetailState.totalFats,
          mealDetailState.totalCarbohydrates,
          mealId: isEdit ? widget.mealId! : Guid.newGuid.toString(),
          name: _mealNameController.text,
          selectedFoods: mealDetailState.selectedFoods);
      if (!isEdit) {
        context.read<MealBloc>().add(AddMeal(meal));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meal added successfully'),
          backgroundColor: Colors.green,
          closeIconColor: Colors.white,
          showCloseIcon: true,
        ));
        Navigator.pop(context);
      } else {
        context.read<MealBloc>().add(UpdateMeal(widget.mealId!, meal));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meal updated successfully'),
          backgroundColor: Colors.green,
          closeIconColor: Colors.white,
          showCloseIcon: true,
        ));
        //_formKey!.currentState!.reset();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please insert at least the name of the meal'),
        backgroundColor: Colors.deepOrangeAccent,
        closeIconColor: Colors.white,
        showCloseIcon: true,
      ));
    }
  }
}
