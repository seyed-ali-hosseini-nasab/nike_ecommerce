import 'package:dio/dio.dart';
import 'package:nike_ecommerce/data/banner.dart';
import 'package:nike_ecommerce/data/common/http_response_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('/banner/slider');
    validateResponse(response);
    final List<BannerEntity> banners = [];
    for (var element in response.data) {
      banners.add(BannerEntity.fromJson(element));
    }
    return banners;
  }
}
