part of 'posts_bloc.dart';

enum AppStatus { loading, success, error }

class PostsState {
  final AppStatus status;
  final List<Post> postsList;
  final bool hasReachedMax;
  final String message;

  const PostsState(
      {this.status = AppStatus.loading,
      this.postsList = const [],
      this.hasReachedMax = false,
      this.message = ""});


  PostsState copyWith({
    AppStatus? status,
    List<Post>? postsList,
    bool? hasReachedMax,
    String? message,
  }) {
    return PostsState(
      status: status ?? this.status,
      postsList: postsList ?? this.postsList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      message: message ?? this.message
    );
  }
}

