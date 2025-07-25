import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container%203.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/splashScreen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.65, // 👈 هنا عرض الدروار كنسبة مئوية من الشاشة
        child: Drawer(
          shape:const RoundedRectangleBorder(
    borderRadius: BorderRadius.zero, // 👈 بدون زوايا مستديرة
  ) ,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: SizedBox(height: 20),
              ),
              const ListTile(
                trailing: Icon(Icons.lock_outline),
                title: Text("Change Password"),
              ),
              const ListTile(
                trailing: Icon(Icons.email_outlined),
                title: Text("Change Email"),
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
                    context.read<AuthenticationBloc>().add(LogOutRequested());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
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
