import 'package:flutter_test/flutter_test.dart';
import 'package:news_bloc_clean/domin/post.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_state.dart';

void main() {
  group('PostState', () {
    test('PostInitial state', () {
      expect(PostInitialState(), isA<PostState>());
    });

    test('PostLoading state', () {
      expect(PostLoadingState(), isA<PostState>());
    });

    test('PostLoaded state', () {
      final posts = [
        Post(id: 1, title: 'Title 1', body: 'Body 1'),
        Post(id: 2, title: 'Title 2', body: 'Body 2'),
      ];
      expect(PostLoadedState(posts), isA<PostState>());
    });

    test('PostError state', () {
      expect(const PostErrorState('Error message'), isA<PostState>());
    });
  });
}
