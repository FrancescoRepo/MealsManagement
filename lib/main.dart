import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealsmanagement/bloc/meals/meals_bloc.dart';
import 'package:mealsmanagement/repositories/meals_repository.dart';
import 'package:mealsmanagement/screens/home_page.dart';

import 'screens/meals_page.dart';

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
          create: (context) => MealRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  MealsBloc(RepositoryProvider.of<MealRepository>(context))
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
              length: 2,
              child: Scaffold(
                backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text("Meals Management"),
                ),
                bottomNavigationBar: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home),
                      text: 'Home',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.fastfood,
                      ),
                      text: 'Meals',
                    ),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                ),
                body: TabBarView(children: [
                  HomePage(key: key),
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
