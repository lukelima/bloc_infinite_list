import 'package:bloc_infinite_list/posts/bloc/post_bloc.dart';
import 'package:bloc_infinite_list/posts/views/posts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
        body: BlocProvider(
            create: (_) => PostBloc(client: Client())..add(PostFetched()),
            child: const PostsList()));
  }
}
