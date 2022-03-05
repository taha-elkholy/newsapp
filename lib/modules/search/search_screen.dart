import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_news_app/layout/news_layout/cubit/cubit.dart';
import 'package:my_news_app/layout/news_layout/cubit/states.dart';
import 'package:my_news_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Search'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultTextFormField(
                    controller: searchController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Search required';
                      }
                    },
                    onChanged: (value) {
                      NewsCubit.get(context).getSearch(value: value);
                    },
                    inputType: TextInputType.text,
                    label: 'Search',
                    prefix: Icons.search),
              ),
              Expanded(
                  child: articleBuilder(NewsCubit.get(context).search,
                      isSearch: true)),
            ],
          ),
        );
      },
    );
  }
}
