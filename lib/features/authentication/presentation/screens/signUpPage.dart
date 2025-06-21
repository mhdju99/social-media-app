// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:store_app/controllers/auth_viewnodel.dart';
// import 'package:store_app/view/screens/logInPage.dart';
// import 'package:store_app/view/widgets/CustomButton.dart';
// import 'package:store_app/view/widgets/CustomTextField.dart';
// import 'package:store_app/view/widgets/buttonText.dart';
// import 'package:store_app/view/widgets/dropDown.dart';

// class SignUP extends StatelessWidget {
//   SignUP({super.key});
//   final formkey = GlobalKey<FormState>();
//   AuthController authControlar = Get.put(AuthController());
//   String? selectedCountry;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Create your",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontFamily: "Metropolis",
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const Text(
//                 "Account",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontFamily: "Metropolis",
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(
//                 height: 27,
//               ),
//               Obx(() {
//                 return authControlar.isOriginalContent.value
//                     ? _buildOriginalContent()
//                     : _buildNewContent();
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNewContent() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Form(
//             key: formkey,
//             child: Column(
//               children: [
//                 CustomTextField(
//                   text: "Full Name",
//                   onSave: (val) {
//                     authControlar.name = val;
//                   },
//                   validate: (e) {
//                     if (e == null || e.length < 4) {
//                       return ".";
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 9,
//                 ),
//                 CustomTextField(
//                   prefixIcon: const Icon(Icons.email),
//                   text: "Email",
//                   onSave: (val) {
//                     authControlar.email = val;
//                   },
//                   type: TextInputType.emailAddress,
//                   validate: (e) {
//                     return authControlar.validateEmail(e);
//                   },
//                 ),
//                 const SizedBox(
//                   height: 9,
//                 ),
//                 CustomTextField(
//                   prefixIcon: const Icon(Icons.password_outlined),
//                   onSave: (val) {
//                     authControlar.password = val;
//                   },
//                   onchange: (p0) => authControlar.pp = p0,
//                   validate: (e) {
//                     return authControlar.validatePassword(e);
//                   },
//                   text: "Password",
//                   type: TextInputType.visiblePassword,
//                 ),
//                 const SizedBox(
//                   height: 9,
//                 ),
//                 CustomTextField(
//                   prefixIcon: const Icon(Icons.password_outlined),
//                   onSave: (val) {
//                     authControlar.password = val;
//                   },
//                   validate: (e) {
//                     return authControlar.confirmPassword(e);
//                   },
//                   text: "confirm password",
//                   type: TextInputType.visiblePassword,
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 30,
//           ),
//           GestureDetector(
//               onTap: () {
//                 formkey.currentState!.save();
//                 if (formkey.currentState!.validate()) {
//                   authControlar.toggleContent();
//                 } else {
//                   Get.snackbar("error", " error in username or password");
//                 }
//               },
//               child: const Icon(
//                 Icons.arrow_forward,
//                 size: 40,
//               )),
//         ],
//       ),
//     );
//   }

//   Widget _buildOriginalContent() {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Form(
//             key: formkey,
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: Obx(() {
//                     if (authControlar.isLoadingC.value) {
//                       return const CircularProgressIndicator();
//                     }

//                     return dropDown(
//                       genderItems:
//                           authControlar.countries.map((val) => val).toList(),
//                       name: "country",
//                       onSave: (Value) {
//                         authControlar.country = Value;
//                       },
//                     );
//                   }),
//                 ),
//                 const SizedBox(
//                   height: 7,
//                 ),
//                 CustomTextField(
//                   text: "city",
//                   onSave: (val) {
//                     authControlar.city = val;
//                   },
//                   validate: (e) {
//                     if (e == null || e.length < 4) {
//                       return ".";
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 7,
//                 ),
//                 CustomTextField(
//                   text: "address",
//                   onSave: (val) {
//                     authControlar.address = val;
//                   },
//                   validate: (e) {
//                     if (e == null || e.length < 4) {
//                       return ".";
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 GetX<AuthController>(
//                   builder: (controllar) {
//                     return CustomButton(
//                         chaild: controllar.isLoading.value
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : const buttonText(label: "Sign Up"),
//                         onPressed: () {
//                           formkey.currentState!.save();
//                           if (formkey.currentState!.validate()) {
//                             controllar.isLoading.value = true;
//                             authControlar.signUp();
//                           } else {
//                             Get.snackbar(
//                                 "error", " error in username or password");
//                           }
//                         });
//                   },
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: Container(
//                             margin:
//                                 const EdgeInsets.only(left: 10.0, right: 10.0),
//                             child: const Divider())),
//                     const Text("OR"),
//                     Expanded(
//                         child: Container(
//                       margin: const EdgeInsets.only(left: 10.0, right: 10.0),
//                       child: const Divider(),
//                     )),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 const Text(
//                   "Already have an account?",
//                   textAlign: TextAlign.end,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: "Metropolis",
//                     fontWeight: FontWeight.w200,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.offAll(LogIn());
//                     authControlar.isOriginalContent = false.obs;
//                   },
//                   child: const Text(
//                     "Log In",
//                     textAlign: TextAlign.end,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.purple,
//                       fontFamily: "Metropolis",
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 18,
//           ),
//           // GestureDetector(
//           //     onTap: () {
//           //       authControlar.toggleContent();
//           //     },
//           //     child: const Icon(
//           //       Icons.arrow_back,
//           //       size: 40,
//           //     )),
//         ],
//       ),
//     );
//   }
// }
