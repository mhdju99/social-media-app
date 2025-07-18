import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/injection_container.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/features/authentication/domain/params/register_params.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomButton.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/CustomTextField.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/ReusableDatePickerField.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/YesNoSelecto.dart';
import 'package:social_media_app/features/authentication/presentation/screens/testPage.dart';
import 'package:social_media_app/features/authentication/presentation/screens/widgets/buttonText.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final firstFormKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  String? userName;

  String? firstName;
  String? lastName;

  String? email;
  String? password;
  String? country;
  String? city;

  DateTime? birthDate;
  bool? certifiedDoctor = false;
  // AuthController authControlar = Get.put(AuthController());
  String? selectedCountry;

  bool showSecondPage = false;

  void togglePage() {
    setState(() {
      showSecondPage = !showSecondPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const testpage()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Form(
            key: firstFormKey,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create your",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      "Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Metropolis",
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 27,
                    ),
                    showSecondPage ? buildNewContent() : _buildOriginalContent()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              DoctorPatientSelector(
                title: "User Type :",
                initialValue: certifiedDoctor,
                onSaved: (val) => certifiedDoctor = val,
                validator: (val) =>
                    val == null ? 'Please choose an option' : null,
              ),
              const SizedBox(
                height: 9,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.person_outline),
                text: "First Name",
                onSave: (val) {
                  firstName = val;
                },
                // controller: firstNameController,
                validate: Validators.validateGeneral,
              ),
              const SizedBox(
                height: 9,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.person_outline),
                text: "lastName",
                onSave: (val) {
                  lastName = val;
                },
                validate: Validators.validateGeneral,
              ),
              const SizedBox(
                height: 9,
              ),
              ReusableDatePickerField(
                controller: dateController,
                label: "Birth Date",
                onSaved: (date) => birthDate = date,
                validator: (date) =>
                    date == null ? 'يرجى اختيار تاريخ الميلاد' : null,
              ),
              const SizedBox(
                height: 9,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.public),
                text: "country",
                onSave: (val) {
                  country = val;
                },
                validate: Validators.validateGeneral,
              ),
              const SizedBox(
                height: 9,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.location_city),
                text: "city",
                onSave: (val) {
                  city = val;
                },
                validate: Validators.validateGeneral,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
              onTap: () {
                if (firstFormKey.currentState!.validate()) {
                  firstFormKey.currentState!.save();
                  togglePage();
                }
              },
              child: const Icon(
                Icons.arrow_forward,
                size: 40,
              )),
        ],
      ),
    );
  }

  Widget buildNewContent() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 7,
            ),
            CustomTextField(
              prefixIcon: const Icon(Icons.email_outlined),
              text: "Email",
              onSave: (val) {
                email = val;
              },
              type: TextInputType.emailAddress,
              validate: Validators.validateEmail,
            ),
            const SizedBox(
              height: 7,
            ),
            CustomTextField(
              prefixIcon: const Icon(Icons.account_circle_outlined),
              text: "Username",
              onSave: (val) {
                userName = val;
              },
              type: TextInputType.name,
              validate: Validators.validateuserName,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              prefixIcon: const Icon(Icons.password_outlined),
              onSave: (val) {
                password = val;
              },
              validate: Validators.validatePassword,
              text: "Password",
              type: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 9,
            ),
            CustomTextField(
              prefixIcon: const Icon(Icons.password_outlined),
              validate: (value) => Validators.confirmPasswordValidator(
                password,
                value,
              ),
              text: "confirm password",
              type: TextInputType.visiblePassword,
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return CustomButton(
                child: state is AuthLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : buttonText(
                        label: "Sign Up",
                      ),
                onPressed: () {
                  firstFormKey.currentState!.save();
                  if (firstFormKey.currentState!.validate()) {
                    context.read<AuthenticationBloc>().add(RegisterRequested(
                        params: RegisterParams(
                            certifiedDoctor: certifiedDoctor!,
                            firstName: firstName!,
                            userName: userName!,
                            lastName: lastName!,
                            birthDate: birthDate!.toIso8601String(),
                            email: email!,
                            password: password!,
                            country: country!,
                            city: city!,
                            preferredTopics: [])));
                  }
                });
          },
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          children: [
            Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: const Divider())),
            const Text("OR"),
            Expanded(
                child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: const Divider(),
            )),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Already have an account?",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Metropolis",
            fontWeight: FontWeight.w200,
          ),
        ),
        InkWell(
          onTap: () {
            // Get.offAll(LogIn());
            // authControlar.isOriginalContent = false.obs;
          },
          child: const Text(
            "Log In",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              color: Colors.purple,
              fontFamily: "Metropolis",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        GestureDetector(
            onTap: () {
              togglePage();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 40,
            )),
      ],
    ));
  }
}
