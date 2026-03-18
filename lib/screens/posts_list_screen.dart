import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_api_service.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';
import 'edit_post_screen.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({Key? key}) : super(key: key);

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  late Future<List<Post>> _postsFuture;
  final PostApiService _apiService = PostApiService();

  @override
  void initState() {
    super.initState();
    _postsFuture = _apiService.getAllPosts();
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _apiService.getAllPosts();
    });
  }

  void _deletePost(int postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _apiService.deletePost(postId).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post deleted successfully')),
                );
                _refreshPosts();
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $error')),
                );
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Manager'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPosts,
            tooltip: 'Refresh posts',
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Data loaded state
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('View'),
                          onTap: () => Future.delayed(
                            const Duration(milliseconds: 200),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailScreen(post: post),
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: const Text('Edit'),
                          onTap: () => Future.delayed(
                            const Duration(milliseconds: 200),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPostScreen(post: post),
                              ),
                            ).then((_) => _refreshPosts()),
                          ),
                        ),
                        PopupMenuItem(
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          onTap: () => _deletePost(post.id),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(post: post),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // Empty state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No posts available',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreatePostScreen(),
          ),
        ).then((_) => _refreshPosts()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
