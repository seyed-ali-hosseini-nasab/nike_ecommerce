part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentSuccess extends CommentState {}

class CommentError extends CommentState {
  final AppException exception;

  const CommentError(this.exception);

  @override
  List<Object> get props => [exception];
}
