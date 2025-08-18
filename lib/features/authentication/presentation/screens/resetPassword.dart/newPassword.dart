import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container%203.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/logInPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/resetPassword.dart/newPassword.dart';
import 'package:social_media_app/features/authentication/presentation/screens/widgets/buttonText.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:social_media_app/core/utils/snackbar_helper.dart';

class Newpassword extends StatelessWidget {
  Newpassword({super.key});
  final formkey = GlobalKey<FormState>();
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => sl<AuthenticationBloc>(),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (contexts, state) {
            if (state is AuthPasswordResetSuccess) {
              Navigator.pushReplacement(
                contexts,
                MaterialPageRoute(builder: (contexts) => LogIn()),
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
                    const Text(
                      "Create New password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      "This password should be different from the previous password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w400,
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
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    // initial: cc.getemail(),
                                    text: "New Password",
                                    onSave: (val) {
                                      password = val;
                                    },
                                    type: TextInputType.visiblePassword,
                                    validate: Validators.validatePassword,
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  CustomTextField(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    // initial: cc.getemail(),
                                    text: "Confirm Password",
                                    onSave: (val) {
                                      // authControlar.email = val;
                                    },
                                    type: TextInputType.visiblePassword,
                                    validate: Validators.validatePassword,
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                ],
                              ),
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
                                      label: "Change Password",
                                    ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();

                                  context.read<AuthenticationBloc>().add(
                                      ResetPasswordRequested(
                                          newPassword: password!));
                                }
                              }),
                          SizedBox(
                            height: 60,
                          ),
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
