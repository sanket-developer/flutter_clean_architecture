import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_bloc_clean/post.dart';
import 'package:news_bloc_clean/post_bloc.dart';
import 'package:news_bloc_clean/post_event.dart';
import 'package:news_bloc_clean/post_list.dart';
import 'package:news_bloc_clean/post_state.dart';

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
      when(() => mockPostBloc.state).thenReturn(PostInitial());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostList(),
            ),
          ),
        ),
      );

      expect(find.text('Post List'), findsOneWidget);
      expect(find.text('Tap Refresh to Load'), findsOneWidget);
    });

    testWidgets('Loading State', (WidgetTester tester) async {
      when(() => mockPostBloc.state).thenReturn(PostLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostList(),
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
      when(() => mockPostBloc.state).thenReturn(PostLoaded(posts));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostList(),
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
      when(() => mockPostBloc.state).thenReturn(PostError('Failed to fetch posts'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostList(),
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
      when(() => mockPostBloc.state).thenReturn(PostLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<PostBloc>(
              create: (context) => mockPostBloc,
              child: PostList(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(() => mockPostBloc.add(FetchPosts())).called(1);
    });
  });
}
