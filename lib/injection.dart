import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'features/profile/data/datasources/local_datasource.dart';
import 'features/profile/data/datasources/remote_datasource.dart';
import 'features/profile/data/models/profile_model.dart';
import 'features/profile/data/repositories/profile_repository_implementation.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_all_user.dart';
import 'features/profile/domain/usecases/get_user.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

var myInjection = GetIt.instance; // penampuangan semua dependencies

// Injection all dependencies
Future<void> init() async {
  // HIVE
  Hive.registerAdapter(ProfileModelAdapter());
  var box = await Hive.openBox("profile_box");
  myInjection.registerLazySingleton(() => box);
  myInjection.registerLazySingleton(() => http.Client());

  // Feature - Profile

  // BLOC -
  myInjection.registerFactory(
      () => ProfileBloc(getAllUser: myInjection(), getUser: myInjection()));

  // USE CASE
  myInjection.registerLazySingleton(() => GetAllUser(myInjection()));
  myInjection.registerLazySingleton(() => GetUser(myInjection()));

  // REPOSITORY
  myInjection.registerLazySingleton<ProfileRepository>(() =>
      ProfileRepositoryImplementation(
          profileLocalDataSource: myInjection(),
          profileRemoteDataSource: myInjection(),
          box: myInjection()));

  // DATA SOURCE
  myInjection.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImplementation(box: myInjection()));
  myInjection.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImplementation(client: myInjection()));
}
