class RatingModel {
  final String id;
  final String review;
  final int rating;
  final bool isAnonymous;
  final String userName;
  final String userProfilePicture;
  final String createdAt;

  RatingModel({
    required this.id,
    required this.review,
    required this.rating,
    required this.isAnonymous,
    required this.userName,
    required this.userProfilePicture,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      review: json['review'],
      rating: json['rating'],
      isAnonymous: json['is_anonymous'],
      userName: json['is_anonymous'] ? 'Anonymous' : json['user']['name'],
      userProfilePicture: json['user']['profile_picture'] ?? '',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'review': review,
        'rating': rating,
        'is_anonymous': isAnonymous,
        'user_name': userName,
        'user_profile_picture': userProfilePicture,
        'created_at': createdAt,
      };
}
