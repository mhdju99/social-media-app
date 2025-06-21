import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/features/authentication/domain/params/login_params.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomButton.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/widgets/buttonText.dart';

class LogIn extends StatefulWidget {
  LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String? _email;
  String? _password;
  final formkey = GlobalKey<FormState>();
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد';
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'البريد الإلكتروني غير صالح';
    }

    return null;
  }

  // ✅ دالة التحقق من كلمة المرور
  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<AuthenticationBloc>(),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => testpage()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
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
                                    validate: _validateEmail,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  CustomTextField(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    // initial: cc.getPassword(),
                                    onSave: (val) {
                                      _password = val;
                                    },
                                    validate: _validatePassword,
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
                              // Get.to(Inputemail());
                              // authControlar.isOriginalContent = false.obs;
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
                              // Get.to(SignUP());
                              // authControlar.isOriginalContent = false.obs;
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
