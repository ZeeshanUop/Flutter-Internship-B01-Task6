import 'package:flutter/material.dart';
import 'package:neuroapp_task6/Provider/UserProvider.dart';
import 'package:neuroapp_task6/model/PostModel.dart';
import 'package:neuroapp_task6/service/ApiServices.dart';
import 'package:neuroapp_task6/views/PostView.dart';
import 'package:provider/provider.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final ApiService apiService = ApiService();

  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final data = await apiService.fetchPosts();
    setState(() => posts = data);
  }

  Future<void> deletePost(int id) async {
    await apiService.deletePost(id);

    setState(() {
      posts.removeWhere((e) => e.id == id);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Posts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostFormPage()),
          );

          if (result == true) loadPosts();
        },
        child: const Icon(Icons.add),
      ),

      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchUsers,
            child: ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
