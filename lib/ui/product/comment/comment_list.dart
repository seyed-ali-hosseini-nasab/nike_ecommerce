import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/repository/comment_repository.dart';
import 'package:nike_ecommerce/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nike_ecommerce/ui/product/comment/comment.dart';
import 'package:nike_ecommerce/ui/widgets/error.dart';

class CommentListScreen extends StatelessWidget {
  final int productId;

  const CommentListScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CommentListBloc(
            repository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CommentItem(
                comment: state.comments[index],
              ),
              childCount: state.comments.length,
            ),
          );
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentListError) {
          return AppErrorWidget(
            exception: state.exception,
            onPressed: () {
              return BlocProvider.of<CommentListBloc>(context)
                  .add(CommentListStarted());
            },
          );
        } else {
          throw Exception('State is not supported');
        }
      }),
    );
  }
}


