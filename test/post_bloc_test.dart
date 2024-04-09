import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_bloc_clean/post.dart';
import 'package:news_bloc_clean/post_bloc.dart';
import 'package:news_bloc_clean/post_event.dart';
import 'package:news_bloc_clean/post_repository.dart';
import 'package:news_bloc_clean/post_state.dart';


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
      expect(postBloc.state, equals(PostInitial()));
    });

    test('emits [PostLoading, PostLoaded] when FetchPosts is added', () {
      final posts = [
        Post(id: 1, title: 'Title 1', body: 'Body 1'),
        Post(id: 2, title: 'Title 2', body: 'Body 2'),
      ];

      when(() => mockPostRepository.fetchPosts()).thenAnswer((_) async => posts);

      final expectedResponse = [
        PostLoading(),
        PostLoaded(posts),
      ];

      expectLater(postBloc.stream, emitsInOrder(expectedResponse));

      postBloc.add(FetchPosts());
    });

    test('emits [PostLoading, PostError] when FetchPosts throws an error', () {
      final exception = Exception('Error fetching posts');

      when(() => mockPostRepository.fetchPosts()).thenThrow(exception);

      final expectedResponse = [
        PostLoading(),
        PostError('Failed to fetch posts'),
      ];

      expectLater(postBloc.stream, emitsInOrder(expectedResponse));

      postBloc.add(FetchPosts());
    });
  });
}
