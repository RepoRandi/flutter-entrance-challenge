import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/local_data_key.dart';
import '../../../../app/routes/route_name.dart';

class AuthInterceptor extends dio.Interceptor {
  final GetStorage _local;

  AuthInterceptor(this._local);

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      _local.remove(LocalDataKey.token);
      Get.offAllNamed(RouteName.login);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _local.remove(LocalDataKey.token);
      Get.offAllNamed(RouteName.login);
    } else {
      handler.next(err);
    }
  }
}
