import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_bloc_clean/domin/post.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_bloc.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_event.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_state.dart';
import 'package:news_bloc_clean/presentation/screens/post_list_screen.dart';

import 'post_bloc_test.dart';

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}

void main() {
  late MockPostBloc mockPostBloc;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostBloc = MockPostBloc();
    mockPostRepository = MockPostRepository();
  });

  tearDown(() {
    mockPostBloc.close();
  });

  group('PostList Widget Test', () {
    testWidgets('Initial State', (WidgetTester tester) async {
      when(() => mockPostBloc.state).thenReturn(PostInitialState());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostListScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Post List'), findsOneWidget);
      expect(find.text('Tap Refresh to Load'), findsOneWidget);
    });

    testWidgets('Loading State', (WidgetTester tester) async {
      when(() => mockPostBloc.state).thenReturn(PostLoadingState());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostListScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Post List'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Loaded State', (WidgetTester tester) async {
      final posts = [
        Post(id: 1, title: 'Title 1', body: 'Body 1'),
        Post(id: 2, title: 'Title 2', body: 'Body 2'),
      ];
      when(() => mockPostBloc.state).thenReturn(PostLoadedState(posts));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostListScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Post List'), findsOneWidget);
      expect(find.text('Title 1'), findsOneWidget);
      expect(find.text('Body 1'), findsOneWidget);
      expect(find.text('Title 2'), findsOneWidget);
      expect(find.text('Body 2'), findsOneWidget);
    });

    testWidgets('Error State', (WidgetTester tester) async {
      when(() => mockPostBloc.state)
          .thenReturn(PostErrorState('Failed to fetch posts'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostListScreen(),
            ),
          ),
        ),
      );

      expect(find.text('Post List'), findsOneWidget);
      expect(find.text('Failed to fetch posts'), findsOneWidget);
    });

    testWidgets('Refresh Button Tap', (WidgetTester tester) async {
      final posts = [
        Post(id: 1, title: 'Title 1', body: 'Body 1'),
        Post(id: 2, title: 'Title 2', body: 'Body 2'),
      ];
      when(() => mockPostBloc.state).thenReturn(PostLoadingState());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostListScreen(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => mockPostBloc.add(FetchPostsEvent())).called(1);
    });
  });
}
