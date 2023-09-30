import 'package:dio/dio.dart';
import 'package:nike_ecommerce/data/comment.dart';
import 'package:nike_ecommerce/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});

  Future<CommentEntity> addComment(CreateCommentParams commentParams);
}

class CommentRemoteDataSource with HttpResponseValidator implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);

  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get(
        '/comment/list?product_id=$productId');
    validateResponse(response);
    final List<CommentEntity> comments = [];
    for (var element in response.data){
      comments.add(CommentEntity.fromJson(element));
    }
    return comments;
  }

  @override
  Future<CommentEntity> addComment(CreateCommentParams commentParams) async{
    final response = await httpClient.post('/comment/add', data: {
      "title": commentParams.title,
      "content": commentParams.content,
      "product_id": commentParams.productId
    });
    validateResponse(response);
    return CommentEntity.fromJson(response.data);
  }
}
