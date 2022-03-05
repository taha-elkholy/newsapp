import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_news_app/layout/news_layout/cubit/states.dart';
import 'package:my_news_app/shared/bloc_observer.dart';
import 'package:my_news_app/shared/network/local/cache_helper.dart';
import 'package:my_news_app/shared/network/remote/dio_helper.dart';
import 'package:my_news_app/shared/styles/styles.dart';

import 'layout/news_layout/cubit/cubit.dart';
import 'layout/news_layout/news_layout.dart';

void main() async {
  // if use async in main function you must use
  // WidgetsFlutterBinding.ensureInitialized()
  // to make the app ensure to initialize
  // all async methods before run
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the dio here
  DioHelper.init();

  // initialize the dio here
  await CashHelper.init();
  bool? isDark = CashHelper.getBoolean(key: 'isDark');

  // use BlocObserver to look at code
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(isDark));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool? isDark;

  MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NewsCubit()
        ..getBusiness()
        // here we call changeAppMode when the app starts
        // isDark will be null in first time open
        ..changeAppMode(fromShared: isDark),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: NewsCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Directionality(
                textDirection: TextDirection.ltr, child: NewsLayout()),
          );
        },
      ),
    );
  }
}
