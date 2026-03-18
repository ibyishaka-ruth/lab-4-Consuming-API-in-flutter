import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class PostApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  /// Fetch all posts
  Future<List<Post>> getAllPosts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ApiException('Request timeout. Please check your internet connection.'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((post) => Post.fromJson(post as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load posts', statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Fetch a single post by ID
  Future<Post> getPostById(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$postId')).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ApiException('Request timeout. Please check your internet connection.'),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw ApiException('Post not found', statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Create a new post
  Future<Post> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ApiException('Request timeout. Please check your internet connection.'),
      );

      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to create post', statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Update an existing post
  Future<Post> updatePost(int postId, Post post) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$postId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(post.toJson()),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ApiException('Request timeout. Please check your internet connection.'),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw ApiException('Failed to update post', statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Delete a post
  Future<void> deletePost(int postId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$postId')).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw ApiException('Request timeout. Please check your internet connection.'),
      );

      if (response.statusCode != 200) {
        throw ApiException('Failed to delete post', statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}
