import 'dart:convert';

import 'package:flutter_bloc_news_app/data/model/news_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=6842c385dc5e467eac91d810f147b54a"));

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final articles = jsonBody['articles'] as List;
        return articles.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
