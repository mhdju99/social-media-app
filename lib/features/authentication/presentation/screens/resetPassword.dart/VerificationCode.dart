// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:social_media_app/core/injection_container%203.dart';
import 'package:social_media_app/core/utils/snackbar_helper.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomButton.dart';
import 'package:social_media_app/features/authentication/presentation/screens/resetPassword.dart/newPassword.dart';
import 'package:social_media_app/features/authentication/presentation/screens/widgets/buttonText.dart';

class Verificationcode extends StatelessWidget {
  String code='';
 final String email;
  Verificationcode({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => sl<AuthenticationBloc>(),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (contexts, state) {
            if (state is AuthCodeVerifiedSuccess) {
              Navigator.push(
                contexts,
                MaterialPageRoute(builder: (contexts) => Newpassword()),
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
                      "Verification",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Please enter 6 digit code your received in your email",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Form(
                              // key: formkey,
                              child: Column(
                                children: [
                                  OtpTextField(
                                    numberOfFields: 6,
                                    borderColor: const Color(0xFF512DA8),
                                    //set to true to show as box or false to show as dash
                                    showFieldAsBox: true,
                                    //runs when a code is typed in
                                    onCodeChanged: (String code) {
                                      //handle validation or checks here
                                    },
                                    //runs when every textfield is filled
                                    onSubmit: (String verificationCode) {
                                      code = verificationCode;
                                    }, // end onSubmit
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  CustomButton(
                                      child: state is AuthLoading
                                          ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : buttonText(
                                              label: "Verify",
                                            ),
                                      onPressed: () {
                                        context.read<AuthenticationBloc>().add(
                                            VerifyResetCodeRequested(
                                                code: code,
                                                email: email));
                                      })
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          // const Text(
                          //   "Didn't receive any code? ",
                          //   textAlign: TextAlign.end,
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     fontFamily: "Metropolis",
                          //     fontWeight: FontWeight.w200,
                          //   ),
                          // ),
                          // InkWell(
                          //   onTap: () {
                          //     cc.getcode();
                          //   },
                          //   child: const Text(
                          //     "Resend new code",
                          //     textAlign: TextAlign.end,
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       color: Colors.purple,
                          //       fontFamily: "Metropolis",
                          //       fontWeight: FontWeight.w700,
                          //     ),
                          //   ),
                          // )
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
