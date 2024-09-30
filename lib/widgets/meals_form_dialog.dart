import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealFormDialog extends StatefulWidget {
  final Function(Meal) onMealCreated; // Callback to send data back

  const MealFormDialog({super.key, required this.onMealCreated});

  @override
  _MealFormDialogState createState() => _MealFormDialogState();
}

class _MealFormDialogState extends State<MealFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mealIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbohydratesController = TextEditingController();
  final _fatsController = TextEditingController();
  final _proteinsController = TextEditingController();
  String? _selectedValue;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create a Meal object from the input
      final meal = Meal(
        _mealIdController.text,
        _nameController.text,
        num.parse(_selectedValue!.replaceAll("g", "").replaceAll("ml", "")),
        num.parse(_caloriesController.text),
        num.parse(_carbohydratesController.text),
        num.parse(_fatsController.text),
        num.parse(_proteinsController.text),
      );

      widget.onMealCreated(meal); // Call the callback to pass data back
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a New Meal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Value for', // Label for the dropdown
                  border: OutlineInputBorder(),
                ),
                value: _selectedValue, // Current selected value
                items: <String>['100g', '100ml'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue; // Update the selected value
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a value'; // Validation message
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the calories' : null,
              ),
              TextFormField(
                controller: _carbohydratesController,
                decoration: const InputDecoration(labelText: 'Carbohydrates (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the carbohydrates' : null,
              ),
              TextFormField(
                controller: _fatsController,
                decoration: const InputDecoration(labelText: 'Fats (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the fats' : null,
              ),
              TextFormField(
                controller: _proteinsController,
                decoration: const InputDecoration(labelText: 'Proteins (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the proteins' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
