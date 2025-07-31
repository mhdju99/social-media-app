import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/validators.dart';
import 'package:social_media_app/features/authentication/presentation/blocs/bloc/authentication_bloc.dart';
import 'package:social_media_app/features/profile/presentation/blocs/profile_bloc.dart';

import '../../../../core/injection_container.dart';

class changeEmailPage extends StatefulWidget {
  const changeEmailPage({super.key});

  @override
  State<changeEmailPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<changeEmailPage> {
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
      context.read<AuthenticationBloc>().add(ResetemailRequested(
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
        title: const Text("Change Email"),
      ),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is sendemail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  duration: Duration(seconds: 4),
                  content: Text(
                      "confirmation email was sent to ${_newPasswordController.text} please confirm within 30s")),
            );
            Navigator.pop(context); // رجوع للصفحة السابقة
          } else if (state is AuthFailure) {
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
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: "New Email",
                    controller: _newPasswordController,
                    obscureText: _obscureNew,
                    toggle: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  state is ProfileLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text("Change Email"),
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
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
        border: const OutlineInputBorder(),
      ),
      validator: Validators.validateEmail,
    );
  }
}
