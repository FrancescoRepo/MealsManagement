import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealsmanagement/bloc/meals/meals_bloc.dart';
import 'package:mealsmanagement/models/meal.dart';
import '../widgets/meals_form_dialog.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      body: BlocBuilder<MealsBloc, MealsState>(
        builder: (BuildContext ctx, MealsState state) {
          if (state is MealsLoaded) {
            return Column(children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.meals.length,
                  itemBuilder: (context, index) {
                    final meal = state.meals[index];
                    return Dismissible(
                      key: Key(meal.mealId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.center,
                        color: Colors.redAccent,
                        child: const Row(
                          // Wrap with a row here
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        BlocProvider.of<MealsBloc>(context)
                            .add(DeleteMeal(meal.mealId));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Meal removed')));
                      },
                      child: _cardItem(context, meal),
                    );
                  },
                ),
              ),
            ]);
          } else if (state is MealError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Show the Meal Form Dialog
          showDialog(
            context: context,
            builder: (context) => MealFormDialog(
              meal: null,
              onSave: (meal) {
                // Dispatch the AddItem event to the BLoC when a new meal is created
                BlocProvider.of<MealsBloc>(context).add(AddMeal(meal));
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _cardItem(BuildContext context, Meal meal) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: _makeListTile(context, meal),
      ),
    );
  }

  Widget _makeListTile(BuildContext context, Meal meal) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Colors.white24),
          ),
        ),
        child: const Icon(
          Icons.fastfood,
          color: Colors.white,
          size: 40,
        ),
      ),
      title: Text(
        meal.name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(
        spacing: 3.0, // Space between chips
        runSpacing: 0.1, // Space between rows
        children: <Widget>[
          Chip(
            label: Text("Protein: ${meal.proteins.toString()}"),
            padding: const EdgeInsets.all(0),
          ),
          Chip(
            label: Text("kCal: ${meal.calories.toString()}"),
            padding: const EdgeInsets.all(0),
          ),
          Chip(
            label: Text("Carbs: ${meal.carbohydrates.toString()}"),
            padding: const EdgeInsets.all(0),
          ),
          Chip(
            label: Text("Fats: ${meal.fats.toString()}"),
            padding: const EdgeInsets.all(0),
          ),
        ],
      ),
      trailing: const Icon(Icons.keyboard_arrow_right,
          color: Colors.white, size: 30.0),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => MealFormDialog(
            meal: meal,
            onSave: (meal) {
              // Dispatch the AddItem event to the BLoC when a new meal is created
              BlocProvider.of<MealsBloc>(context)
                  .add(UpdateMeal(meal.mealId, meal));
            },
          ),
        );
      },
    );
  }
}
