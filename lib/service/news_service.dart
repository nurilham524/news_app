import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {

   static Future<List<News>> getArticle() async {
    try {
      const baseUrl = 'https://saurav.tech/NewsAPI/everything/cnn.json';
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final news = data['articles'] as List; // Extract articles list
        final newsList = news.map((articleData) => News.fromJson(articleData)).toList();
        return newsList;
      } else {
        throw Exception('Failed to load articles. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}
