import 'dart:convert';

class News {
  final String? author;
  final String title;
  final String description;
  final String image;
  final String publishedAt;
  final String content;

  News({
    this.author,
    required this.title,
    required this.description,
    required this.image,
    required this.publishedAt,
    required this.content,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      image: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'urlToImage': image,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}
