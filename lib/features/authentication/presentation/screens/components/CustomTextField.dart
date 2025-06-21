// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final String? initial;
  Icon prefixIcon;
  String? Function(String?)? validate;
  void Function(String?)? onSave;
  void Function(String?)? onchange;
  void Function()? onEditingComplete;
  TextInputType? type;
  CustomTextField(
      {super.key,
      required this.text,
      this.prefixIcon = const Icon(Icons.person),
      this.type,
      this.initial,
      this.validate,
      this.onchange,
      this.onEditingComplete,
      this.onSave});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

bool isVisible = true;

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onchange,
      initialValue: widget.initial,
      keyboardType: widget.type,
      obscureText:
          widget.type == TextInputType.visiblePassword ? isVisible : false,
      decoration: InputDecoration(
        suffixIcon: widget.type == TextInputType.visiblePassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child:
                    Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        prefixIcon: widget.prefixIcon,
        labelText: widget.text,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.w200,
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      validator: widget.validate,
      onSaved: widget.onSave,
      autovalidateMode: AutovalidateMode.disabled,
    );
  }
}
