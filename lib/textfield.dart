import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String hinttext;
  final TextEditingController control;
  final bool obsc;
  const InputText(
      {super.key,
      required this.control,
      required this.hinttext,
      required this.obsc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50, right: 50, top: 20),
      child: TextField(
        controller: control,
        obscureText: obsc,
        decoration: InputDecoration(
            hintText: hinttext,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey.shade700,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            fillColor: Colors.white,
            filled: true),
      ),
    );
  }
}
