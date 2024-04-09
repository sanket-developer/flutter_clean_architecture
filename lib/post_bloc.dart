import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_bloc_clean/post_repository.dart';
import 'post.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
       await _mapFetchPostsToState();
    });
  }

  // @override
  // Stream<PostState> mapEventToState(PostEvent event) async* {
  //   if (event is FetchPosts) {
  //     yield* _mapFetchPostsToState();
  //   }
  // }



  Future<void> _mapFetchPostsToState() async {
    emit(PostLoading());
    try {
      List<Post> posts = await repository.fetchPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(const PostError("Failed to fetch posts"));
    }
  }
}
