import 'dart:convert';

import 'package:flutter_bloc_news_app/data/model/news_model.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/api_constant.dart';

class NewsRepository {
  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=6842c385dc5e467eac91d810f147b54a"));

      if (response.statusCode == 200) {
        final List<dynamic> newsJson = jsonDecode(response.body);
        final List<NewsModel> NewsList =
            newsJson.map((json) => NewsModel.fromJson(json)).toList();
        return NewsList;
      } else {
        throw Exception(
            'Failed to fetch news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
