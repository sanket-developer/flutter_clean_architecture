import 'package:equatable/equatable.dart';
import 'package:news_bloc_clean/domin/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostLoadedState extends PostState {
  final List<Post> posts;

  const PostLoadedState(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PostErrorState extends PostState {
  final String message;

  const PostErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
