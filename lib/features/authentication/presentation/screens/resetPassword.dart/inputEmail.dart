import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container%203.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomButton.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/authentication/presentation/screens/resetPassword.dart/VerificationCode.dart';
import 'package:social_media_app/features/authentication/presentation/screens/widgets/buttonText.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'package:social_media_app/core/utils/snackbar_helper.dart';

class Inputemail extends StatelessWidget {
  Inputemail({super.key});
  final formkey = GlobalKey<FormState>();
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (context) => sl<AuthenticationBloc>(),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (contexts, state) {
            if (state is AuthCodeRequestedSuccess) {
          

              Navigator.push(
                contexts,
                MaterialPageRoute(
                    builder: (contexts) => Verificationcode(email: email!,)),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forget ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Metropolis",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Your Password?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Metropolis",
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 27,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      // key: formkey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Form(
                              key: formkey,
                              child: CustomTextField(
                                prefixIcon: const Icon(Icons.email_outlined),
                                text: "Email",
                                onSave: (val) {
                                  email = val;
                                },
                                type: TextInputType.emailAddress,
                                validate: Validators.validateEmail,
                              ),
                            ),
                            const SizedBox(
                              height: 19,
                            ),
                            const Text(
                              "To recover yout password, please enter your email address",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Metropolis",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                          CustomButton(
                              child: state is AuthLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : buttonText(
                                      label: "Send",
                                    ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  formkey.currentState!.save();
                                  context.read<AuthenticationBloc>().add(
                                      RequstResetCodeRequested(email: email!));
                                }
                              })
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
                    const SizedBox(
                      height: 100,
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
      )
      
      
      ,
    );
  }
}
