part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentAdded extends CommentEvent {
  final CreateCommentParams commentParams;

  const CommentAdded(this.commentParams);

  @override
  List<Object> get props => [commentParams];
}
