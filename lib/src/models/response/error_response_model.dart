import '../error_model.dart';

class ErrorResponseModel {
  ErrorResponseModel({
    this.status,
    this.message,
    this.data,
  });

  final int? status;
  final String? message;
  final ErrorModel? data;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      ErrorResponseModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? ErrorModel.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
    if (status != null) 'status': status,
    if (message != null) 'message': message,
    if (data != null) 'data': data!.toJson(),
  };
}
