import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_bloc_clean/domin/post.dart';
import 'package:news_bloc_clean/data/post_repository.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_bloc.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_event.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_state.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late PostBloc postBloc;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    postBloc = PostBloc(repository: mockPostRepository);
  });

  tearDown(() {
    postBloc.close();
  });

  group('PostBloc', () {
    test('initial state is correct', () {
      expect(postBloc.state, equals(PostInitialState()));
    });

    test('emits [PostLoading, PostLoaded] when FetchPosts is added', () {
      final posts = [
        Post(id: 1, title: 'Title 1', body: 'Body 1'),
        Post(id: 2, title: 'Title 2', body: 'Body 2'),
      ];

      when(() => mockPostRepository.fetchPosts())
          .thenAnswer((_) async => posts);

      final expectedResponse = [
        PostLoadingState(),
        PostLoadedState(posts),
      ];

      expectLater(postBloc.stream, emitsInOrder(expectedResponse));

      postBloc.add(FetchPostsEvent());
    });

    test('emits [PostLoading, PostError] when FetchPosts throws an error', () {
      final exception = Exception('Error fetching posts');

      when(() => mockPostRepository.fetchPosts()).thenThrow(exception);

      final expectedResponse = [
        PostLoadingState(),
        PostErrorState('Failed to fetch posts'),
      ];

      expectLater(postBloc.stream, emitsInOrder(expectedResponse));

      postBloc.add(FetchPostsEvent());
    });
  });
}
