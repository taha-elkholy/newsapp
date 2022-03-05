import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_news_app/layout/news_layout/cubit/states.dart';
import 'package:my_news_app/models/news_model.dart';
import 'package:my_news_app/modules/business/business_screen.dart';
import 'package:my_news_app/modules/science/science_screen.dart';
import 'package:my_news_app/modules/sports/sports_screen.dart';
import 'package:my_news_app/shared/components/constants.dart';
import 'package:my_news_app/shared/network/local/cache_helper.dart';
import 'package:my_news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  // constructor match super with initial state of app
  NewsCubit() : super(NewsInitialState());

  // a static object from the NewsCubit
  static NewsCubit get(context) => BlocProvider.of(context);

  // bottom nav bar index
  int currentIndex = 0;

  void changeBottomNaveBarIndex(int index) {
    currentIndex = index;
    // get data of the 1 & 2 index here
    if (index == 1) {
      getSports();
    } else if (index == 2) {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  // list of titles of the app
  List<String> titles = [
    'Business',
    'Sports',
    'Science',
  ];

  // list of screens will shown on news layout
  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

// list of BottomNavigationBarItem
  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sports),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.science),
      label: 'Science',
    ),
  ];

  // light & dark mode
  // true because the first time run
  // the fromShared optional value = null
  // and the changeAppMode enter to the else statement
  // and reverse the value of isDark
  bool isDark = true;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      // her we get saved data from shared preferences
      isDark = fromShared;
      emit(NewsChangeModeState());
    } else {
      // her we just toggle between the 2 possibles
      isDark = !isDark;
      // save isDark value in shared preferences after edit the new value
      CashHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(NewsChangeModeState());
      });
    }
  }

  // List of business articles
  List<Article> business = [];

  void getBusiness() {
    //loading
    emit(NewsGetBusinessLoadingState());
    business = [];
    DioHelper.getNews(category: businessEndPoint).then((value) {
      print('business value $value');
      var _model = NewsModel.fromJson(value.data);
      business.addAll(_model.articles);
      print('business length: ${business.length}');
      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      emit(NewsGetBusinessErrorState(error.toString()));
      print('Error is : ${error.toString()}');
    });
  }

  // List of business articles
  List<Article> science = [];

  void getScience() {
    //loading
    emit(NewsGetScienceLoadingState());
    science = [];
    DioHelper.getNews(category: scienceEndPoint).then((value) {
      print('science value: $value');
      var _model = NewsModel.fromJson(value.data);
      science.addAll(_model.articles);
      emit(NewsGetScienceSuccessState());
    }).catchError((error) {
      emit(NewsGetScienceErrorState(error.toString()));
      print('Error is : ${error.toString()}');
    });
  }

  // List of business articles
  List<Article> sports = [];

  void getSports() {
    //loading
    emit(NewsGetSportsLoadingState());
    sports = [];
    DioHelper.getNews(
      category: sportsEndPoint,
    ).then((value) {
      print('sports value: $value');
      var _model = NewsModel.fromJson(value.data);
      sports.addAll(_model.articles);
      emit(NewsGetSportsSuccessState());
    }).catchError((error) {
      emit(NewsGetSportsErrorState(error.toString()));
      print('Error is : ${error.toString()}');
    });
  }

  // List of business articles
  List<Article> search = [];

  void getSearch({required String value}) {
    if (value != '') {
      //loading
      emit(NewsGetSearchLoadingState());
    }

    // make the search list empty
    search = [];

    DioHelper.searchNews(searchValue: value).then((value) {
      var _model = NewsModel.fromJson(value.data);
      search.addAll(_model.articles);
      emit(NewsGetSearchSuccessState());
      print('success ${search.length}');
    }).catchError((error) {
      emit(NewsGetSearchErrorState(error.toString()));
      print('Error is : ${error.toString()}');
    });
  }
}
