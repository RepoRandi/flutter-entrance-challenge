import '../user_model.dart';

class UserResponseModel {
  UserResponseModel(
      {required this.status, required this.message, required this.data});

  final int status;
  final String message;
  final UserModel data;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        status: json['status'],
        message: json['message'],
        data: UserModel.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data,
  };
}