import 'package:hive/hive.dart';

import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileLocalDataSourceImplementation extends ProfileLocalDataSource {
  final Box box;

  ProfileLocalDataSourceImplementation({required this.box});

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    return box.get("getAllUser");
  }

  @override
  Future<ProfileModel> getUserById(int id) async {
    return box.get("getUserById");
  }
}
