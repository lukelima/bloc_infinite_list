import 'package:bloc_infinite_list/posts/bloc/post_bloc.dart';
import 'package:bloc_infinite_list/posts/widgets/bottom_loader.dart';
import 'package:bloc_infinite_list/posts/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();
  late PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = context.read<PostBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      switch (state.status) {
        case PostStatus.failure:
          return Center(
            child: Text("There was an error fetching posts data"),
          );
        case PostStatus.success:
          if (state.posts.isEmpty) {
            return Center(
              child: Text("There are no posts"),
            );
          }
          return ListView.builder(
            itemCount: state.hasReachedMaximum
                ? state.posts.length
                : state.posts.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index >= state.posts.length
                  ? BottomLoader()
                  : PostListItem(post: state.posts[index]);
            },
            controller: _scrollController,
          );
        default:
          return CircularProgressIndicator();
      }
    });
  }

  void _onScroll() {
    if (_isBottom) _postBloc.add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
