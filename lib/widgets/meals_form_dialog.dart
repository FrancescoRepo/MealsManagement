import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import '../models/meal.dart';

class MealFormDialog extends StatefulWidget {
  final Function(Meal) onSave; // Callback to send data back
  final Meal? meal;

  const MealFormDialog({super.key, required this.onSave, this.meal});

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
      final meal = Meal(
        widget.meal != null ? widget.meal!.mealId : Guid.newGuid.toString(),
        _nameController.text,
        _selectedValue!,
        num.parse(_caloriesController.text),
        num.parse(_carbohydratesController.text),
        num.parse(_fatsController.text),
        num.parse(_proteinsController.text),
      );

      widget.onSave(meal); // Call the callback to pass data back
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.meal != null) {
      _nameController.text = widget.meal!.name;
      _selectedValue = widget.meal!.valueFor;
      _caloriesController.text = widget.meal!.calories.toString();
      _carbohydratesController.text = widget.meal!.carbohydrates.toString();
      _fatsController.text = widget.meal!.fats.toString();
      _proteinsController.text = widget.meal!.proteins.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.meal == null ? 'Create a new meal' : 'Edit meal'),
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
                value: _selectedValue,
                // Current selected value
                items: <String>['100g', '100ml'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  print(newValue);
                  setState(() {
                    _selectedValue = newValue; // Update the selected value
                  });

                  print(_selectedValue);
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
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the calories' : null,
              ),
              TextFormField(
                controller: _carbohydratesController,
                decoration:
                    const InputDecoration(labelText: 'Carbohydrates (g)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the carbohydrates' : null,
              ),
              TextFormField(
                controller: _fatsController,
                decoration: const InputDecoration(labelText: 'Fats (g)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the fats' : null,
              ),
              TextFormField(
                controller: _proteinsController,
                decoration: const InputDecoration(labelText: 'Proteins (g)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the proteins' : null,
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
