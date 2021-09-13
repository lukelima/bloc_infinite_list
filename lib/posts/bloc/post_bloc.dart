import 'dart:convert';
import 'dart:io';
import 'package:bloc_infinite_list/posts/models/post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 20;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.client}) : super(const PostState());

  final Client client;

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostFetched) {
      yield await _mapPostFetchedToState(state);
    }
  }

  Future<PostState> _mapPostFetchedToState(PostState state) async {
    if (state.hasReachedMaximum) return state;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return state.copyWith(
            status: PostStatus.success, posts: posts, hasReachedMaximum: false);
      }
      final posts = await _fetchPosts();
      return posts.isEmpty
          ? state.copyWith(hasReachedMaximum: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: posts,
              hasReachedMaximum: false);
    } on Exception {
      return state.copyWith(status: PostStatus.failure);
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await client.get(
      Uri.https('jsonplaceholder.typicode.com', '/posts',
          <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'}),
    );
    if (response.statusCode == HttpStatus.ok) {
      final body = json.decode(response.body) as List;
      return body
          .map((dynamic json) =>
              Post(id: json['id'], title: json['title'], body: json['body']))
          .toList();
    }
    throw HttpException("It was not possible to fetch api");
  }
}
