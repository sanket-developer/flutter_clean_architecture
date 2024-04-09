import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_bloc_clean/domin/post.dart';

class PostRepository {
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      List<Post> posts = jsonData.map((e) => Post.fromJson(e)).toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
