import 'package:nike_ecommerce/common/http_client.dart';
import 'package:nike_ecommerce/data/comment.dart';
import 'package:nike_ecommerce/data/source/comment_data_source.dart';

final commentRepository =
    CommentRepository(CommentRemoteDataSource(httpClient));

abstract class ICommnetRepository {
  Future<List<CommentEntity>> getAll({required int productId});

  Future<CommentEntity> addComment(CreateCommentParams commentParams);
}

class CommentRepository implements ICommnetRepository {
  final ICommentDataSource dataSource;

  CommentRepository(this.dataSource);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);

  @override
  Future<CommentEntity> addComment(CreateCommentParams commentParams) =>
      dataSource.addComment(commentParams);
}
