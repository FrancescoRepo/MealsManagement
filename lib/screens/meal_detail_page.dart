import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mealsmanagement/bloc/food/food_bloc.dart';
import 'package:mealsmanagement/bloc/meal/meal_bloc.dart';

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

  bool get isEdit => widget.mealId != null;
  List<SelectedFood> _selectedFoods = [];

  num totalCalories = 0;
  num totalProteins = 0;
  num totalCarbohydrates = 0;
  num totalFats = 0;
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
            BlocProvider.of<MealBloc>(context).add(LoadMeals());
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        foregroundColor: Colors.white,
      ),
      body: PopScope(
        canPop: false,
        child: BlocBuilder<MealBloc, MealState>(
          builder: (context, state) {
            if (state is MealLoading) {
              return const CircularProgressIndicator();
            } else if (state is MealLoaded) {
              _mealNameController.text = state.meal.name;
              _selectedFoods = state.meal.selectedFoods != null
                  ? state.meal.selectedFoods!
                  : [];
              for (var food in _selectedFoods) {
                _calculateTotalValues(food);
              }
            } else if(state is CreateMeal) {

            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    const SizedBox(height: 20),
                    // Searchable Dropdown for Food Selection
                    buildSearchDropDown(),
                    const SizedBox(height: 20),
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
                        if (value == null || value.isEmpty) {
                          return 'Please enter the weight';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Add Food Button
                    ElevatedButton(
                      onPressed: _addFoodToMeal,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.cyan, // Text color
                      ),
                      child: const Text('Add Food to Meal'),
                    ),

                    const SizedBox(height: 20),

                    _selectedFoods.isEmpty
                        ? Container()
                        : buildRecapNutritionalValues(),
                    const SizedBox(height: 20),
                    // Display Selected Foods
                    buildSelectedFoodList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMeal,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        child: const Icon(Icons.save),
      ),
    );
  }

  Expanded buildSelectedFoodList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _selectedFoods.length,
        itemBuilder: (context, index) {
          final selectedFood = _selectedFoods[index];
          return Card(
            color: const Color.fromRGBO(75, 85, 100, 1.0),
            child: ListTile(
              title: Text(
                '${selectedFood.food.name} - ${selectedFood.weight}g',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Calories: ${selectedFood.food.calories}, Proteins: ${selectedFood.food.proteins}, Fats: ${selectedFood.food.fats}, Carbs: ${selectedFood.food.carbohydrates}',
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
  }

  Center buildRecapNutritionalValues() {
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
                'Calories: $totalCalories',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Proteins: $totalProteins',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Fats: $totalFats',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Carbohydrates: $totalCarbohydrates',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<FoodBloc, FoodState> buildSearchDropDown() {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      if (state is FoodsLoading) {
        return const CircularProgressIndicator();
      } else if (state is FoodsLoaded) {
        return TypeAheadField<Food>(
          builder: (context, controller, focusNode) {
            return TextFormField(
              controller: _foodSearchController,
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
          itemBuilder: (context, Food suggestion) {
            return ListTile(
              title: Text(suggestion.name,
                  style: const TextStyle(color: Colors.white)),
              tileColor: const Color.fromRGBO(75, 85, 100, 1.0),
            );
          },
          onSelected: (Food suggestion) {
            setState(() {
              _selectedFoodId = suggestion.foodId;
              _foodSearchController.text =
                  suggestion.name; // Update text with selected food name
            });
          },
        );
      }
      return Container();
    });
  }

  void _addFoodToMeal() {
    if (_formKey.currentState!.validate()) {
      // Find the selected food from the Bloc's state
      final foodsState = context.read<FoodBloc>().state;
      if (foodsState is FoodsLoaded) {
        final selectedFood = foodsState.foods
            .firstWhere((food) => food.foodId == _selectedFoodId);
        final weight = num.parse(_foodWeightController.text);

        // Calculate scaled nutritional values based on the weight entered
        final scaledCalories = (selectedFood.calories / 100) * weight;
        final scaledProteins = (selectedFood.proteins / 100) * weight;
        final scaledFats = (selectedFood.fats / 100) * weight;
        final scaledCarbohydrates = (selectedFood.carbohydrates / 100) * weight;

        setState(() {
          _selectedFoods.add(SelectedFood(
            scaledCalories,
            scaledProteins,
            scaledCarbohydrates,
            scaledFats,
            food: selectedFood,
            weight: weight,
          ));

          // Update total nutritional values for all foods
          totalCalories += scaledCalories;
          totalProteins += scaledProteins;
          totalFats += scaledFats;
          totalCarbohydrates += scaledCarbohydrates;

          _foodSearchController.clear();
          _foodWeightController.clear();
          _selectedFoodId = null;
        });
      }
    }
  }

  void _removeFoodFromMeal(int index) {
    setState(() {
      // Update total nutritional values by subtracting the removed food's values
      totalCalories -= _selectedFoods[index].scaledCalories;
      totalProteins -= _selectedFoods[index].scaledProteins;
      totalFats -= _selectedFoods[index].scaledFats;
      totalCarbohydrates -= _selectedFoods[index].scaledCarbohydrates;

      _selectedFoods.removeAt(index);
    });
  }

  void _saveMeal() {
    if (_mealNameController.text.isNotEmpty && _selectedFoods.isNotEmpty) {
      FocusScope.of(context).requestFocus(FocusNode());
      final meal = Meal(
          mealId: Guid.newGuid.toString(),
          name: _mealNameController.text,
          selectedFoods: _selectedFoods);
      if (!isEdit) {
        BlocProvider.of<MealBloc>(context).add(AddMeal(meal));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meal added successfully'),
          backgroundColor: Colors.green,
          closeIconColor: Colors.white,
          showCloseIcon: true,
        ));
        Navigator.pop(context);
      } else {
        BlocProvider.of<MealBloc>(context)
            .add(UpdateMeal(widget.mealId!, meal));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Meal updated successfully'),
          backgroundColor: Colors.green,
          closeIconColor: Colors.white,
          showCloseIcon: true,
        ));
      }
    }
  }

  void _calculateTotalValues(SelectedFood food) {
    totalCalories += food.scaledCalories;
    totalProteins += food.scaledProteins;
    totalFats += food.scaledFats;
    totalCarbohydrates += food.scaledCarbohydrates;
  }
}
