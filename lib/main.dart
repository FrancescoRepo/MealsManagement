import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealsmanagement/bloc/food/food_bloc.dart';
import 'package:mealsmanagement/bloc/meal/meal_bloc.dart';
import 'package:mealsmanagement/repositories/food_repository.dart';
import 'package:mealsmanagement/repositories/meal_repository.dart';
import 'package:mealsmanagement/screens/home_page.dart';
import 'package:mealsmanagement/CustomIcons.dart';
import 'package:mealsmanagement/screens/meals_page.dart';

import 'screens/foods_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => FoodRepository(),
        ),
        RepositoryProvider(
          create: (context) => MealRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  FoodBloc(RepositoryProvider.of<FoodRepository>(context))
                    ..loadFoods()),
          BlocProvider(
              create: (context) =>
                  MealBloc(RepositoryProvider.of<MealRepository>(context))
                    ..loadMeals())
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            primaryColor: const Color.fromRGBO(58, 66, 86, 1.0),
            //useMaterial3: true,
          ),
          home: DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
                  title: const Text(
                    "Meals Management",
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                bottomNavigationBar: const TabBar(
                  automaticIndicatorColorAdjustment: true,
                  indicatorColor: Colors.white,
                  dividerColor: Color.fromRGBO(58, 66, 86, 1.0),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home),
                      text: 'Home',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.fastfood,
                      ),
                      text: 'Foods',
                    ),
                    Tab(
                      icon: Icon(CustomIcons.food),
                      text: 'Meals',
                    ),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                ),
                body: TabBarView(children: [
                  HomePage(key: key),
                  FoodsPage(
                    key: key,
                  ),
                  MealsPage(
                    key: key,
                  )
                ]),
              )),
        ),
      ),
    );
  }
}
