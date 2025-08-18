import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/snackbar_helper.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/UploadProfileImagePage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomButton.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/authentication/presentation/screens/resetPassword.dart/inputEmail.dart';
import 'package:social_media_app/features/authentication/presentation/screens/signUpPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/widgets/buttonText.dart';
import 'package:social_media_app/features/profile/presentation/screens/ipchange.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_bloc.dart';
import 'package:social_media_app/features/realtime/presentation/blocs/chat_event.dart';
import 'package:social_media_app/main_page.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? _email;
  String? _password;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<AuthenticationBloc>(),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (contexts, state) {
            if (state is AuthSuccess) {
              // context
              //   .read<ChatBloc>()
              //   .add(ConnectToSocketEvent(response.token));
              context.read<ChatBloc>().add(ConnectToSocketEvent());

              Navigator.pushReplacement(
                contexts,
                MaterialPageRoute(builder: (contexts) => MainPage()),
              );
            } else if (state is AuthFailure) {
              SnackbarHelper.show(context,
                  title: "",
                  message: state.message,
                  contentType: ContentType.failure);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(9),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 44,
                    ),
                    const Text(
                      "Sign in to your Account",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                      prefixIcon:
                                          const Icon(Icons.email_outlined),
                                      // initial: cc.getemail(),
                                      text: "Email",
                                      onSave: (val) {
                                        _email = val;
                                      },
                                      type: TextInputType.emailAddress,
                                      validate: Validators.validateEmail),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  CustomTextField(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    // initial: cc.getPassword(),
                                    onSave: (val) {
                                      _password = val;
                                    },
                                    validate: Validators.validatePassword,
                                    text: "Password",
                                    type: TextInputType.visiblePassword,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Inputemail()),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Forget Password?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.deepPurple,
                                    fontFamily: "Metropolis",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButton(
                              child: state is AuthLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : buttonText(
                                      label: "Sign in",
                                    ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  context.read<AuthenticationBloc>().add(
                                      LogInRequested(
                                          params: LoginParams(
                                              email: _email!,
                                              password: _password!)));
                                }
                              }),
                          const SizedBox(
                            height: 60,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: const Divider())),
                              const Text("OR"),
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: const Divider(),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          const Text(
                            "Don't have an account? ",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Metropolis",
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUP()),
                              );
                            },
                            child: const Text(
                              "Sign Up Now",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple,
                                fontFamily: "Metropolis",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SetIpPage()),
                              );
                            },
                            child: const Text(
                              "change server ip ",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple,
                                fontFamily: "Metropolis",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
