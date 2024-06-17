import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/endpoint.dart';
import '../constants/local_data_key.dart';
import '../models/request/product_list_request_model.dart';
import '../models/response/product_detail_response_model.dart';
import '../models/response/product_list_response_model.dart';
import '../models/response/rating_response_model.dart';
import '../utils/networking_util.dart';

class ProductRepository {
  final Dio _client;
  final GetStorage _local;

  ProductRepository({required Dio client, required GetStorage local})
      : _client = client,
        _local = local;

  Future<ProductListResponseModel> getProductList(
      ProductListRequestModel request) async {
    try {
      String endpoint = Endpoint.getProductList;
      final responseJson = await _client.get(
        endpoint,
        data: request,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );
      return ProductListResponseModel.fromJson(responseJson.data);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<ProductDetailResponseModel> getProductDetail(String id) async {
    try {
      String endpoint = '${Endpoint.getProductList}/$id';
      final responseJson = await _client.get(
        endpoint,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );
      return ProductDetailResponseModel.fromJson(responseJson.data);
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<RatingResponseModel> getProductRatings(String productId,
      {int page = 1, int limit = 5}) async {
    try {
      String endpoint = Endpoint.getRatings;
      final responseJson = await _client.get(
        endpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
          'sort_column': 'created_at',
          'sort_order': 'desc',
          'product_id': productId,
        },
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );
      return RatingResponseModel.fromJson(responseJson.data);
    } on DioException catch (_) {
      rethrow;
    }
  }
}
