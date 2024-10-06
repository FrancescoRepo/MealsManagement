import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:mealsmanagement/bloc/food/food_bloc.dart';
import 'package:mealsmanagement/bloc/network/network_cubit.dart';
import '../models/food.dart';

class FoodFormDialog extends StatefulWidget {
  final Function(Food) onSave; // Callback to send data back
  final Food? food;

  const FoodFormDialog({super.key, required this.onSave, this.food});

  @override
  _FoodFormDialogState createState() => _FoodFormDialogState();
}

class _FoodFormDialogState extends State<FoodFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _fatsController = TextEditingController();
  final _proteinsController = TextEditingController();
  String? _selectedValueFor;
  bool foodExists = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final food = Food(
        widget.food != null ? widget.food!.foodId : Guid.newGuid.toString(),
        _nameController.text,
        _selectedValueFor!,
        num.parse(_caloriesController.text),
        num.parse(_carbohydratesController.text),
        num.parse(_fatsController.text),
        num.parse(_proteinsController.text),
      );

      widget.onSave(food); // Call the callback to pass data back
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      _nameController.text = widget.food!.name;
      _selectedValueFor = widget.food!.valueFor;
      _caloriesController.text = widget.food!.calories.toString();
      _carbohydratesController.text = widget.food!.carbohydrates.toString();
      _fatsController.text = widget.food!.fats.toString();
      _proteinsController.text = widget.food!.proteins.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        if (state is FoodExist) {
          foodExists = true;
        } else {
          foodExists = false;
        }
        return AlertDialog(
          title: Text(widget.food == null ? 'Create a new food' : 'Edit food'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Value for', // Label for the dropdown
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedValueFor,
                    // Current selected value
                    items: <String>['100g', '100ml'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValueFor =
                            newValue; // Update the selected value
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value'; // Validation message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (foodName) {
                      BlocProvider.of<FoodBloc>(context)
                          .add(SearchFoodByName(foodName));
                    },
                  ),
                  if (foodExists)
                    const Text(
                      'Food already exists!',
                      style: TextStyle(color: Colors.red),
                    ),
                  TextFormField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(labelText: 'Calories'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || num.tryParse(value) == null) {
                          return 'Please enter the calories';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: _carbohydratesController,
                      decoration:
                          const InputDecoration(labelText: 'Carbohydrates (g)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || num.tryParse(value) == null) {
                          return 'Please enter the carbohydrates';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: _fatsController,
                      decoration: const InputDecoration(labelText: 'Fats (g)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || num.tryParse(value) == null) {
                          return 'Please enter the fats';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: _proteinsController,
                      decoration:
                          const InputDecoration(labelText: 'Proteins (g)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || num.tryParse(value) == null) {
                          return 'Please enter the proteins';
                        }
                        return null;
                      }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<NetworkCubit, NetworkConnectionState>(
              builder: (context, connectivity) {
                bool isConnected =
                    connectivity.status == ConnectionStatus.connected;
                return ElevatedButton(
                  onPressed: foodExists || !isConnected ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: foodExists || !isConnected
                          ? Colors.grey
                          : Colors.cyan,
                      foregroundColor: Colors.white),
                  child: const Text('Save'),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
