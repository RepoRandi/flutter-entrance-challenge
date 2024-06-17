import 'package:dio/dio.dart';

import '../models/response/error_response_model.dart';

class NetworkingUtil {
  static Map<String, dynamic> setupTokenHeader(String? withToken) {
    final headers = <String, dynamic>{
      if (withToken != null) 'Authorization': withToken,
      'Accept': 'application/json',
    };
    return headers;
  }

  static Options setupNetworkOptions(String? withToken, {Options? otherOptions}) {
    if(otherOptions != null) {
      otherOptions.headers = setupTokenHeader(withToken);
      return otherOptions;
    } else {
      return Options(
          contentType: 'application/json',
          headers: setupTokenHeader(withToken));
    }
  }

  static String errorMessage(dynamic error) {
    try {
      ErrorResponseModel? errResponse;
      if (error is DioException) {
        errResponse = ErrorResponseModel.fromJson(error.response?.data);
      }
      if (errResponse != null && errResponse.data != null &&
          errResponse.data!.errorData != null &&
          errResponse.data!.errorData!.isNotEmpty) {
        return errResponse.data!.errorData![errResponse.data!.errorData!.keys
            .first]!.first;
      } else if (errResponse != null && errResponse.message != null) {
        return errResponse.message!;
      } else {
        return 'Unknown Error';
      }
    } catch (err) {
      return 'Unknown Error';
    }
  }
}