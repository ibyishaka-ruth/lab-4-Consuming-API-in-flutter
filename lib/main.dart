import 'package:flutter/material.dart';
import 'screens/posts_list_screen.dart';

void main() {
  runApp(const PostsManagerApp());
}

class PostsManagerApp extends StatelessWidget {
  const PostsManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PostsListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
