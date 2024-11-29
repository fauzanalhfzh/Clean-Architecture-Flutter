import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImplementation extends ProfileRepository {
  final ProfileLocalDataSource profileLocalDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final Box box;

  ProfileRepositoryImplementation(
      {required this.profileLocalDataSource,
      required this.profileRemoteDataSource,
      required this.box});

  @override
  Future<Either<Failure, List<Profile>>> getAllUser(int page) async {
    try {
      // Check Internet
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        // no available network
        // data dari local datasource
        List<ProfileModel> result =
            await profileLocalDataSource.getAllUser(page);
        return Right(result);
      } else {
        // available network
        // data dari remote datasource
        // put last data to local storage
        List<ProfileModel> result =
            await profileRemoteDataSource.getAllUser(page);
        box.put('getAllUser', result);
        return Right(result);
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getUserById(int id) async {
    try {
      // Check Internet
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        // no available network
        // data dari local datasource
        ProfileModel result = await profileLocalDataSource.getUserById(id);
        return Right(result);
      } else {
        // available network
        // data dari remote datasource
        // put last data to local storage
        ProfileModel result = await profileRemoteDataSource.getUserById(id);
        box.put('getUserById', result);
        return Right(result);
      }
    } catch (e) {
      return Left(Failure());
    }
  }
}
