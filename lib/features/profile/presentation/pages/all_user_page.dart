import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All User"),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: context.read<ProfileBloc>()..add(ProfileEventGetAllUsers(1)),
        builder: (context, state) {
          if (state is ProfileStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileStateError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileStateLoadedAllUsers) {
            List<Profile> allUsers = state.allUsers;
            return ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  Profile profile = allUsers[index];
                  return ListTile(
                    onTap: () {
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => DetailUserPage()));
                      // context.pushNamed("detail-user");
                      context.pushNamed("detail_user", extra: profile.id);
                    },
                    title: Text(profile.fullName),
                  );
                });
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
