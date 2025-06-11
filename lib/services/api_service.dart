import 'dart:convert';
import 'package:http/http.dart' as http;
import '../presentation/models/article.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      
      if (response.statusCode >= 200 && response.statusCode <=300  ) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Comment>> fetchComments(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/comments?postId=$postId'));
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}