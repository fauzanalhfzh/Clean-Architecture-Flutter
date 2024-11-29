import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_all_user.dart';
import '../../domain/usecases/get_user.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetAllUser getAllUser;
  final GetUser getUser;

  ProfileBloc({required this.getAllUser, required this.getUser})
      : super(ProfileStateEmpty()) {
    on<ProfileEventGetAllUsers>((event, emit) async {
      emit(ProfileStateLoading());
      Either<Failure, List<Profile>> resultGetAllUsers =
          await getAllUser.execute(event.page);
      resultGetAllUsers.fold((leftResultGetAllUsers) {
        emit(ProfileStateError("Cannot get all users"));
      }, (rightResultGetAllUsers) {
        emit(ProfileStateLoadedAllUsers(rightResultGetAllUsers));
      });
    });
    on<ProfileEventGetDetailUser>((event, emit) async {
      emit(ProfileStateLoading());
      Either<Failure, Profile> resultGetUser =
          await getUser.execute(event.userId);
      resultGetUser.fold((leftResultGetUser) {
        emit(ProfileStateError("Cannot get detail users"));
      }, (rightResultGetUser) {
        emit(ProfileStateLoadedUser(rightResultGetUser));
      });
    });
  }
}
