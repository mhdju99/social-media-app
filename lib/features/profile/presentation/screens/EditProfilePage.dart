import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/features/authentication/presentation/screens/components/ReusableDatePickerField.dart';
import 'package:social_media_app/features/profile/domain/entities/user_entity.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';

import '../../../../core/injection_container copy 2.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? selectedImage;

  Future<void> _pickImage(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  bool isEditingfirstName = false;
  bool isEditinglastName = false;
  bool isEditingUsername = false;
  bool isEditingEmail = false;
  bool isEditingDate = false;
  bool isEditingcity = false;
  bool isEditingcountry = false;
  bool isEditingBio = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final bioController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    usernameController.text = widget.user.userName;
    cityController.text = widget.user.location.city;
    countryController.text = widget.user.location.country;
    emailController.text = widget.user.email;
    bioController.text = widget.user.about ?? "a";
    dateController.text = widget.user.birthDate.toIso8601String();
  }

  Widget buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" $label :",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: isEditing
                    ? TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                        ),
                        child: Text(controller.text),
                      ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEditableDateField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" $label :",
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: isEditing
                    ? ReusableDatePickerField(controller: controller)
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                        ),
                        child: Text(controller.text),
                      ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: BlocProvider(
          create: (context) => sl<ProfileBloc>(),
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileSuccess) {
                Navigator.pop(context, 'refresh');
              } else if (state is ProfileFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Image
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: selectedImage != null
                                  ? FileImage(selectedImage!)
                                  : NetworkImage(
                                      "${EndPoints.baseUrl}/users/profile-image?profileImagePath=${widget.user.profileImage}",
                                    ) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _pickImage(context),
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.camera_alt,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Editable Fields
                  buildEditableField(
                    label: "first Name",
                    controller: firstNameController,
                    isEditing: isEditingfirstName,
                    onEdit: () => setState(() => isEditingfirstName = true),
                  ),
                  buildEditableField(
                    label: "last Name",
                    controller: lastNameController,
                    isEditing: isEditinglastName,
                    onEdit: () => setState(() => isEditinglastName = true),
                  ),
                  buildEditableDateField(
                    label: "date",
                    controller: dateController,
                    isEditing: isEditingDate,
                    onEdit: () => setState(() => isEditingDate = true),
                  ),
                  buildEditableField(
                    label: "Username",
                    controller: usernameController,
                    isEditing: isEditingUsername,
                    onEdit: () => setState(() => isEditingUsername = true),
                  ),
                  buildEditableField(
                    label: "Email",
                    controller: emailController,
                    isEditing: isEditingEmail,
                    onEdit: () => setState(() => isEditingEmail = true),
                  ),
                  buildEditableField(
                    label: "country",
                    controller: countryController,
                    isEditing: isEditingcountry,
                    onEdit: () => setState(() => isEditingcountry = true),
                  ),
                  buildEditableField(
                    label: "city",
                    controller: cityController,
                    isEditing: isEditingcity,
                    onEdit: () => setState(() => isEditingcity = true),
                  ),
                  buildEditableField(
                    label: "Bio",
                    controller: bioController,
                    isEditing: isEditingBio,
                    onEdit: () => setState(() => isEditingBio = true),
                  ),

                  const SizedBox(height: 30),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(ModifyProfileEvent(
                                email: isEditingEmail
                                    ? emailController.text
                                    : null,
                                lastName: isEditinglastName
                                    ? lastNameController.text
                                    : null,
                                firstName: isEditingfirstName
                                    ? firstNameController.text
                                    : null,
                                about: isEditingBio ? bioController.text : null,
                                birthDate: (isEditingDate &&
                                        dateController.text.isNotEmpty)
                                    ? dateController.text
                                    : null,
                                city:
                                    isEditingcity ? cityController.text : null,
                                country: isEditingcountry
                                    ? countryController.text
                                    : null,
                                userName: isEditingUsername
                                    ? usernameController.text
                                    : null,
                                photo: selectedImage));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Save Changes",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
