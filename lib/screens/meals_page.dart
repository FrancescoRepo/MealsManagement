import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealsmanagement/CustomIcons.dart';
import 'package:mealsmanagement/bloc/meal/meal_bloc.dart';

import '../models/meal.dart';
import 'meal_detail_page.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (BuildContext ctx, MealState state) {
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
                        BlocProvider.of<MealBloc>(context)
                            .add(DeleteMeal(meal.mealId));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Meal removed'),
                          backgroundColor: Colors.green,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                        ));
                      },
                      child: _cardItem(context, meal),
                    );
                  },
                ),
              ),
            ]);
          } else if (state is MealsError) {
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
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MealDetailPage()),
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
          CustomIcons.food,
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
            label: Text(
              "Tot Protein: ${meal.totalProteins.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
          Chip(
            label: Text(
              "Tot kCal: ${meal.totalCalories.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
          Chip(
            label: Text(
              "Tot Carbs: ${meal.totalCarbohydrates.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
          Chip(
            label: Text(
              "Tot Fats: ${meal.totalFats.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
        ],
      ),
      trailing: const Icon(Icons.keyboard_arrow_right,
          color: Colors.white, size: 30.0),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailPage(
              mealId: meal.mealId,
            ),
          ),
        );
      },
    );
  }
}
