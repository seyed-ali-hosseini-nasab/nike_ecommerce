import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce/common/exceptions.dart';
import 'package:nike_ecommerce/data/comment.dart';
import 'package:nike_ecommerce/data/repository/comment_repository.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ICommnetRepository repository;

  CommentBloc(this.repository) : super(CommentInitial()) {
    on<CommentEvent>((event, emit) async {
      if (event is CommentAdded) {
        try {
          emit(CommentLoading());
          await repository.addComment(event.commentParams);
          emit(CommentSuccess());
        } catch (e) {
          emit(CommentError(AppException()));
        }
      }
    });
  }
}
