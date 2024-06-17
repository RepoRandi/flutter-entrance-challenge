import '../rating_model.dart';

class RatingResponseModel {
  RatingResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<RatingModel> data;

  factory RatingResponseModel.fromJson(Map<String, dynamic> json) {
    var ratingList = json['data'] as List;
    return RatingResponseModel(
      status: json['status'],
      message: json['message'],
      data: ratingList.map((e) => RatingModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}
