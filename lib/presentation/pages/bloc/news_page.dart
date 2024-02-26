import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/news_repository.dart';
import '../bloc/news/news_bloc.dart';

class NewsPageWrapper extends StatelessWidget {
  const NewsPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => NewsBloc(NewsRepository()),
          child: const NewsPage())
    ], child: NewsPage());
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<NewsBloc>(context).add(FetchNewsEvent());
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial) {
            return Text("Waiting for News Post");
            ;
          } else if (state is NewsLoading) {
            return _buildLoadingUI();
          } else if (state is NewsLoaded) {
            return _buildLoadedUI(state);
          } else if (state is NewsError) {
            return _buildErrorUI();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildLoadingUI() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoadedUI(NewsLoaded state) {
    return ListView.builder(
      itemCount: state.newsList.length,
      itemBuilder: (context, index) {
        final news = state.newsList[index];
        print(news);
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Text("${news}")],
          ),
        );
      },
    );
  }

  Widget _buildErrorUI() {
    return const Center(child: Text('Failed to fetch news.'));
  }
}
