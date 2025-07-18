import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/authentication/data/data_sources/authentication_local_data_source.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/logInPage.dart';

class testpage extends StatefulWidget {
  const testpage({super.key});

  @override
  State<testpage> createState() => _testpageState();
}

class _testpageState extends State<testpage> {
  @override
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final localDataSource = sl<AuthenticationLocalDataSource>();
    final token = await localDataSource.getTokenSec();

    if (mounted) {
      setState(() {
        _token = token;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => sl<AuthenticationBloc>(),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationInitial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LogIn()),
              (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            top: true,
            child: Column(
              children: [
                Center(
                  child: _token == null
                      ? const Text("لم يتم العثور على توكن")
                      : Text("Token: $_token"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    context.read<AuthenticationBloc>().add(LogOutRequested());
                  },
                  child: const Text("Logout"),
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}
