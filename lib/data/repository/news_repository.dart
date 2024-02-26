import 'dart:convert';

import 'package:flutter_bloc_news_app/data/model/news_model.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/api_constant.dart';

class NewsRepository {
  final client = http.Client();

  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await client.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=e8c8ab89a94343fdb306149805f02275"));
      if (response.statusCode == 200) {
        final List<dynamic> newsJson = json.decode(response.body);
        final List<NewsModel> newsPosts =
            newsJson.map((json) => NewsModel.fromJson(json)).toList();
        return newsPosts;
      } else {
        // Handle non-200 status codes (e.g., show an error message)
        throw Exception('Failed to fetch posts');
      }
    } catch (e) {
      // Handle any other exceptions (e.g., network issues)
      throw Exception('An error occurred: $e');
    }
  }
}
