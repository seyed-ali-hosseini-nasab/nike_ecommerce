import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce/data/comment.dart';
import 'package:nike_ecommerce/data/repository/comment_repository.dart';
import 'package:nike_ecommerce/ui/comment/bloc/comment_bloc.dart';

class CommnetScreen extends StatefulWidget {
  final int productId;

  const CommnetScreen({super.key, required this.productId});

  @override
  State<CommnetScreen> createState() => _CommnetScreenState();
}

class _CommnetScreenState extends State<CommnetScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  StreamSubscription<CommentState>? stateSubscription;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ثبت نظر"),
          centerTitle: true,
        ),
        body: BlocProvider<CommentBloc>(
          create: (context) {
            final bloc = CommentBloc(commentRepository);
            stateSubscription = bloc.stream.listen((state) {
              if (state is CommentSuccess) {
                Navigator.pop(context);
              } else if (state is CommentError) {
                _scaffoldKey.currentState?.showSnackBar(
                    SnackBar(content: Text(state.exception.message)));
              }
            });
            return bloc;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(label: Text('عنوان')),
                ),
                const SizedBox(height: 12),
                TextField(
                  maxLines: 8,
                  controller: contentController,
                  decoration: const InputDecoration(label: Text('توضیحات')),
                ),
                const SizedBox(height: 24),
                BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    if (state is CommentLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('لغو'),
                          ),
                          const SizedBox(width: 24),
                          ElevatedButton(
                            onPressed: () {
                              if (titleController.text.isNotEmpty &&
                                  contentController.text.isNotEmpty) {
                                BlocProvider.of<CommentBloc>(context).add(
                                  CommentAdded(
                                    CreateCommentParams(
                                      titleController.text,
                                      contentController.text,
                                      widget.productId,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('لطفا تمامی فیلدها را پر کنید'),
                                  ),
                                );
                              }
                            },
                            child: const Text('ثبت'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
