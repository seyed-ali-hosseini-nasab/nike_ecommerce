class CommentEntity {
  final int id;
  final String title;
  final String content;
  final String date;
  final String email;

  CommentEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        date = json['date'],
        email = json['author']['email'];
}

class CreateCommentParams {
  final String title;
  final String content;
  final int productId;

  CreateCommentParams(this.title, this.content, this.productId);
}
