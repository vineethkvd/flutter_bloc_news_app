import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/news_repository.dart';
import '../../bloc/news/news_bloc.dart';

class NewsPageWrapper extends StatefulWidget {
  const NewsPageWrapper({super.key});

  @override
  State<NewsPageWrapper> createState() => _NewsPageWrapperState();
}

class _NewsPageWrapperState extends State<NewsPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => NewsBloc(),
      )
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
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial) {
            return _buildInitialUI(context);
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

  Widget _buildInitialUI(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Welcome to the News App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<NewsBloc>(context).add(FetchNewsEvent());
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Fetch News',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
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
        if (news.articles == null) {
          return Container(
            child: Text("Null news articles${news}"),
          ); // Return an empty container if the articles list is null
        }

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (news.articles![index].urlToImage != null) // Add null check here
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "${news.articles![index].urlToImage}",
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300], // Placeholder color
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                )
              else
                Container(
                  height: 200,
                  color: Colors.grey,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${news.articles![index].title}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${news.articles![index].description}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Center(child: Text("${news.articles![index].title}"))
            ],
          ),
        );
      },
    );
  }


  Widget _buildErrorUI() {
    return const Center(child: Text('Failed to fetch news.'));
  }
}
