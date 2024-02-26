import 'package:flutter/material.dart';
import 'package:flutter_bloc_news_app/presentation/pages/bloc/news_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsPageWrapper(),
    );
  }
}
