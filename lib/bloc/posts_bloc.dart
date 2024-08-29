import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_task6/API/posts.dart';
import 'package:bloc_task6/models/post.dart';
import 'package:equatable/equatable.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  
  PostsBloc() : super(const PostsState()) {
    on<PostsEvent>(
      transformer: droppable(), // Used to change how events are processed. By default events are processed concurrently.
      (event, emit) async {
        if (state.hasReachedMax) {
          return;
        }
        try {
          if (state.status == AppStatus.loading) {
            final postsList = await PostsApi.getPosts();
            return postsList.isEmpty
                ? emit(
                    state.copyWith(
                      status: AppStatus.success,
                      hasReachedMax: true,
                    ),
                  )
                : emit(
                    state.copyWith(
                      status: AppStatus.success,
                      postsList: postsList,
                      hasReachedMax: false,
                    ),
                  );
          } else {
            final postsList = await PostsApi.getPosts(state.postsList.length);
            postsList.isEmpty
                ? emit(
                    state.copyWith(
                      hasReachedMax: true,
                    ),
                  )
                : emit(
                    state.copyWith(
                      status: AppStatus.success,
                      postsList: List.of(state.postsList)..addAll(postsList),
                    ),
                  );
          }
        } catch (e) {
          emit(state.copyWith(
              status: AppStatus.error, message: "failed to fetch posts"));
        }
      },
    );
  }
}
