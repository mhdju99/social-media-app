// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media_app/core/injection_container%203.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/changeEmail.dart';
import 'package:social_media_app/features/authentication/presentation/screens/changePassword.dart';
import 'package:social_media_app/features/authentication/presentation/screens/splashScreen.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:social_media_app/features/profile/presentation/screens/blockUsersPage.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_event.dart';

class CustomDrawer extends StatelessWidget {
  final UserProfile? user;
  const CustomDrawer({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.65, // 👈 هنا عرض الدروار كنسبة مئوية من الشاشة
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // 👈 بدون زوايا مستديرة
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: SizedBox(height: 20),
              ),
              ListTile(
                trailing: Icon(Icons.lock_outline),
                title: Text("Change Password"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<ProfileBloc>(
                        create: (_) => sl<ProfileBloc>(),
                        child: const ChangePasswordPage(),
                      ),
                    ),
                  );
                  ;
                },
              ),
               ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<AuthenticationBloc
>(
                        create: (_) => sl<AuthenticationBloc>(),
                        child: const changeEmailPage(),
                      ),
                    ),
                  );
                  ;
                },
                trailing: Icon(Icons.email_outlined),
                title: Text("Change Email"),
              ),
              ListTile(
                trailing: Icon(Icons.block),
                title: Text("blocked Users"),
                onTap: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => blockUsersPage(
                          data: user!.blockedUsers,
                        ),
                      ),
                    );
                  } else {
                    return;
                  }
                  ;
                },
              ),
              const Divider(),
              Card(
                elevation: 3,
                child: ListTile(
                  trailing: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                          print("✅dis✅");

                                  context.read<ChatBloc>().add(disConnectToSocketEvent());

                    context.read<AuthenticationBloc>().add(LogOutRequested());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>  SplashScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
