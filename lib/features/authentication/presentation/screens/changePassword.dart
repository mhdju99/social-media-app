import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';

import '../../../../core/injection_container.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      context.read<ProfileBloc>().add(ChangePasswordEvent(
            oldPassword: _oldPasswordController.text.trim(),
            newPassword: _newPasswordController.text.trim(),
          ));
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is changedpassword) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password changed successfully")),
            );
            Navigator.pop(context); // رجوع للصفحة السابقة
          } else if (state is ProfileFailure) {
                          print("☪${state.message}");
      
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPasswordField(
                    label: "Old Password",
                    controller: _oldPasswordController,
                    obscureText: _obscureOld,
                    toggle: () => setState(() => _obscureOld = !_obscureOld),
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: "New Password",
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    toggle: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: "Confirm Password",
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    toggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 24),
                  state is ProfileLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text("Change Password"),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Required";
        if (value.length < 6) return "Password must be at least 6 characters";
        return null;
      },
    );
  }
}
