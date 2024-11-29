import 'package:hive/hive.dart';

import '../../domain/entities/profile.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 1)
class ProfileModel extends Profile {
  @HiveField(4)
  final String firstName;
  @HiveField(5)
  final String lastName;
  @HiveField(6)
  final String avatar;

  const ProfileModel(
      {required super.id,
      required super.email,
      required this.firstName,
      required this.lastName,
      required this.avatar})
      : super(fullName: '$firstName $lastName', profileImageUrl: avatar);

  // Map -> ProfileModel
  factory ProfileModel.fromJson(Map<String, dynamic> data) {
    return ProfileModel(
        id: data['id'],
        email: data['email'],
        firstName: data['first_name'],
        lastName: data['last_name'],
        avatar: data['avatar']);
  }

  // ProfileModel -> MAP
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar
    };
  }

  // List<Map> -> List<ProfileModel>
  static List<ProfileModel> fromJsonList(List data) {
    if (data.isEmpty) return [];
    return data
        .map((singleDataProfile) => ProfileModel.fromJson(singleDataProfile))
        .toList();
  }
}
