import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/endpoint.dart';
import '../constants/local_data_key.dart';
import '../interceptors/auth_interceptor.dart';
import '../models/response/user_response_model.dart';
import '../utils/networking_util.dart';

class UserRepository {
  final Dio _client;
  final GetStorage _local;

  UserRepository({required Dio client, required GetStorage local})
      : _client = client,
        _local = local {
    _client.interceptors.add(AuthInterceptor(_local));
  }

  Future<void> login(String countryCode, String phone, String password) async {
    final response = await _client.post(
      Endpoint.signIn,
      data: {
        'country_code': countryCode,
        'phone_number': phone,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final token = response.data['data']['token'];
      _local.write(LocalDataKey.token, token);
    } else {
      throw Exception('Login failed: ${response.statusMessage}');
    }
  }

  Future<void> logout() async {
    final token = _local.read(LocalDataKey.token);
    final response = await _client.post(
      Endpoint.signOut,
      options: NetworkingUtil.setupNetworkOptions(token),
    );

    if (response.statusCode == 200) {
      await _local.remove(LocalDataKey.token);
    } else {
      throw Exception('Logout failed: ${response.statusMessage}');
    }
  }

  Future<UserResponseModel> getUser() async {
    try {
      final responseJson = await _client.get(
        Endpoint.getUser,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );
      final model = UserResponseModel.fromJson(responseJson.data);
      return model;
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> updateUser({
    required String name,
    required String email,
    required int height,
    required int weight,
    required String gender,
    required String dateOfBirth,
    String? profilePicturePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'height': height.toString(),
        'weight': weight.toString(),
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'profile_picture': profilePicturePath != null
            ? await MultipartFile.fromFile(profilePicturePath,
                filename: profilePicturePath.split('/').last)
            : null,
        '_method': 'PUT',
      });

      final response = await _client.post(
        Endpoint.editProfile,
        data: formData,
        options: NetworkingUtil.setupNetworkOptions(
            'Bearer ${_local.read(LocalDataKey.token)}'),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Unknown error');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

  /*
    This Function is used as challenge tester
    DO NOT modify this function
   */
  Future<void> testUnauthenticated() async {
    try {
      final realToken = _local.read<String?>(LocalDataKey.token);
      await _local.write(
          LocalDataKey.token, '619|kM5YBY5yM15KEuSmSMaEzlfv0lWs83r4cp4oty2T');
      getUser();
      //401 not caught as exception
      await _local.write(LocalDataKey.token, realToken);
    } on DioException catch (_) {
      rethrow;
    }
  }
}
