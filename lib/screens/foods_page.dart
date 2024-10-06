import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealsmanagement/bloc/food/food_bloc.dart';
import 'package:mealsmanagement/models/food.dart';
import '../widgets/foods_form_dialog.dart';
import '../widgets/no_internet_connectivity.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (BuildContext ctx, FoodState state) {
          if (state is FoodsLoaded) {
            return Column(children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.foods.length,
                  itemBuilder: (context, index) {
                    final food = state.foods[index];
                    return Dismissible(
                      key: Key(food.foodId),
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
                        BlocProvider.of<FoodBloc>(context)
                            .add(DeleteFood(food.foodId));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Food removed'),
                          backgroundColor: Colors.green,
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                        ));
                      },
                      child: _cardItem(context, food),
                    );
                  },
                ),
              ),
            ]);
          } else if (state is FoodsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          } else if (state is NoInternetConnectivity) {
            return const NoInternetWidget();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => FoodFormDialog(
              food: null,
              onSave: (food) {
                BlocProvider.of<FoodBloc>(context).add(AddFood(food));
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _cardItem(BuildContext context, Food food) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: _makeListTile(context, food),
      ),
    );
  }

  Widget _makeListTile(BuildContext context, Food food) {
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
        food.name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(
        spacing: 15.0, // Space between chips
        runSpacing: 0.1, // Space between rows
        children: <Widget>[
          Chip(
            label: Text(
              "Protein: ${food.proteins.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
          Chip(
            label: Text(
              "kCal: ${food.calories.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
          Chip(
            label: Text(
              "Carbs: ${food.carbohydrates.truncate().toString()}",
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.all(0),
            backgroundColor: Colors.cyan,
          ),
          Chip(
            label: Text(
              "Fats: ${food.fats.truncate().toString()}",
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
        showDialog(
          context: context,
          builder: (context) => FoodFormDialog(
            food: food,
            onSave: (food) {
              BlocProvider.of<FoodBloc>(context)
                  .add(UpdateFood(food.foodId, food));
            },
          ),
        );
      },
    );
  }
}
