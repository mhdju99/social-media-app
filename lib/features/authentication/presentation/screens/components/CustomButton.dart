// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  void Function()? onPressed;

  CustomButton({
    Key? key,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.deepPurple.shade800,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
          border: Border.all(color: const Color.fromARGB(255, 92, 91, 92))),
      child: MaterialButton(
        disabledColor: Colors.purple,

        // padding:
        //     const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        onPressed: onPressed,

        child: child,
      ),
    );
  }
}
