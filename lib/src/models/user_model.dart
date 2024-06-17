class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.countryCode,
    this.profilePicture,
    this.email,
    this.gender,
    this.height,
    this.weight,
    this.dateOfBirth,
  });

  final String id;
  final String name;
  final String phone;
  final String countryCode;
  final String? profilePicture;
  final String? email;
  final String? gender;
  final int? height;
  final int? weight;
  final String? dateOfBirth;


  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone_number'],
        countryCode: json['country_code'],
        profilePicture: json['profile_picture'],
        email: json['email'],
        gender: json['gender'],
        height: json['height'],
        weight: json['weight'],
        dateOfBirth: json['date_of_birth'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone_number': phone,
    'country_code': countryCode,
    'profile_picture': profilePicture,
    'email': email,
    'gender': gender,
    'height': height,
    'weight': weight,
    'date_of_birth': dateOfBirth,
  };
}