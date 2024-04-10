import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_bloc_clean/presentation/widgets/progress.dart' as Progress;
import 'package:news_bloc_clean/presentation/widgets/centre_text_widget.dart';

import '../../domin/post_bloc/post_bloc.dart';
import '../../domin/post_bloc/post_event.dart';
import '../../domin/post_bloc/post_state.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostBloc postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post List'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoadingState) {
            return const Progress.ProgressIndicator();
          } else if (state is PostLoadedState) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.posts[index].title),
                  subtitle: Text(state.posts[index].body),
                );
              },
            );
          } else if (state is PostErrorState) {
            return CentreTextWidget(state.message);
          } else if (state is PostInitialState) {
            return const CentreTextWidget('Tap Refresh to Load');
          } else {
            return const CentreTextWidget('Something went wrong');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postBloc.add(FetchPostsEvent()); // Add FetchPosts event
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
