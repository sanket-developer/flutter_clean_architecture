import 'package:flutter_test/flutter_test.dart';
import 'package:news_bloc_clean/domin/post_bloc/post_event.dart';

void main() {
  group('PostEvent', () {
    test('FetchPosts event', () {
      expect(FetchPostsEvent(), isA<PostEvent>());
    });
  });
}
