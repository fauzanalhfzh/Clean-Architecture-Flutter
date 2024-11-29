import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/injection.dart';
import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class DetailUserPage extends StatelessWidget {
  final int userId;
  const DetailUserPage(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail User $userId"),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: myInjection<ProfileBloc>()
          ..add(ProfileEventGetDetailUser(userId)),
        builder: (context, state) {
          if (state is ProfileStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileStateError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileStateLoadedUser) {
            Profile user = state.detailUser;
            return Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                    const SizedBox(height: 20),
                    Text("ID : ${user.id}"),
                    Text("Nama Lengkap : ${user.fullName}"),
                    Text("Email : ${user.email}"),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Empty Users"),
            );
          }
        },
      ),
    );
  }
}
