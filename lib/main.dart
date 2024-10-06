import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mealsmanagement/bloc/food/food_bloc.dart';
import 'package:mealsmanagement/bloc/meal/meal_bloc.dart';
import 'package:mealsmanagement/bloc/meal/meal_detail_cubit.dart';
import 'package:mealsmanagement/bloc/network/network_cubit.dart';
import 'package:mealsmanagement/repositories/food_repository.dart';
import 'package:mealsmanagement/repositories/meal_repository.dart';
import 'package:mealsmanagement/CustomIcons.dart';
import 'package:mealsmanagement/screens/meals_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/foods_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"]!, anonKey: dotenv.env["SUPABASE_KEY"]!);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
              create: (_) =>
                  NetworkCubit(Connectivity())..checkInitialConnection()),
          BlocProvider(
              create: (context) => FoodBloc(
                  RepositoryProvider.of<FoodRepository>(context),
                  BlocProvider.of<NetworkCubit>(context))),
          BlocProvider(
              create: (context) => MealBloc(
                  RepositoryProvider.of<MealRepository>(context),
                  BlocProvider.of<NetworkCubit>(context))),
          BlocProvider(create: (_) => MealDetailCubit()),
        ],
        child: BlocListener<NetworkCubit, NetworkConnectionState>(
          listener: (context, state) {
            if (state.status == ConnectionStatus.connected) {
              context.read<FoodBloc>().add(LoadFoods());
              context.read<MealBloc>().add(LoadMeals());
            }
          },
          child: MaterialApp(
            title: 'Meals Management',
            theme: ThemeData(
              primaryColor: const Color.fromRGBO(58, 66, 86, 1.0),
              //useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: DefaultTabController(
                length: 2,
                child: Builder(builder: (context) {
                  final TabController controller =
                      DefaultTabController.of(context)!;
                  controller!.addListener(() {
                    if (controller.index == 0) {
                      BlocProvider.of<FoodBloc>(context).add(LoadFoods());
                    } else {
                      BlocProvider.of<MealBloc>(context).add(LoadMeals());
                    }
                  });
                  return Scaffold(
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
                      FoodsPage(
                        key: key,
                      ),
                      MealsPage(
                        key: key,
                      )
                    ]),
                  );
                })),
          ),
        ),
      ),
    );
  }
}
