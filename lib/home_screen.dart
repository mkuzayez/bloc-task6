import 'package:bloc_task6/bloc/posts_bloc.dart';
import 'package:bloc_task6/widgets/loading.dart';
import 'package:bloc_task6/widgets/post_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (offset >= maxScroll * 0.9) {
      context.read<PostsBloc>().add(GetPostsEvent());
      print("2");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BloC task 6"),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
        print("1");
        switch (state.status) {
          case AppStatus.loading:
            return const LoadingWidget();

          case AppStatus.success:
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.postsList.length
                  : state.postsList.length + 1,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return index >= state.postsList.length
                    ? const Padding(
                      padding:  EdgeInsets.all(8.0),
                      child:  LoadingWidget(),
                    )
                    : PostListItem(
                        post: state.postsList[index],
                      );
              },
            );

          case AppStatus.error:
            return Center(
              child: Text(state.message),
            );
        }
      }),
    );
  }
}
