import 'package:flutter_test/flutter_test.dart';
import 'package:news_bloc_clean/post_event.dart';

void main() {
  group('PostEvent', () {
    test('FetchPosts event', () {
      expect(FetchPosts(), isA<PostEvent>());
    });
  });
}
