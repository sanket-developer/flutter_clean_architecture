import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_bloc_clean/data/post_repository.dart';
import 'package:news_bloc_clean/domin/post.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitialState()) {
    on<FetchPostsEvent>((event, emit) async {
      await _mapFetchPostsToState();
    });
  }

  Future<void> _mapFetchPostsToState() async {
    emit(PostLoadingState());
    try {
      List<Post> posts = await repository.fetchPosts();
      emit(PostLoadedState(posts));
    } catch (e) {
      emit(const PostErrorState("Failed to fetch posts"));
    }
  }
}
