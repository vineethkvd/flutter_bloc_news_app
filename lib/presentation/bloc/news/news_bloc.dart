import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_news_app/data/model/news_model.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<FetchNewsEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        final newsList = await NewsRepository().fetchNews();
        emit(NewsLoaded(newsList: newsList));
      } catch (e) {
        emit(NewsError());
      }
    });
  }
}
