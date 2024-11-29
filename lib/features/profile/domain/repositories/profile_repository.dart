import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<Profile>>> getAllUser(
      int page); // Kemungkinan data yang diterima itu ada 2 hasil Gagal / data berhasil di dapatkan
  Future<Either<Failure, Profile>> getUserById(int id);
}
