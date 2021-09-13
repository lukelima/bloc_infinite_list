part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

class PostState {
  const PostState(
      {this.status = PostStatus.initial,
      this.posts = const <Post>[],
      this.hasReachedMaximum = false});

  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMaximum;

  PostState copyWith(
      {PostStatus? status, List<Post>? posts, bool? hasReachedMaximum}) {
    return PostState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        hasReachedMaximum: hasReachedMaximum ?? this.hasReachedMaximum);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMaximum, posts: ${posts.length} }''';
  }
}
