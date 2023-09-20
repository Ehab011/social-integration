import 'package:flutter/material.dart';

class textFields extends StatelessWidget {
  //final controller;
  final String hintText;
  final bool obscureText;
  final icon;

  const textFields({
    super.key,
    //required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        //controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[400]),
          hintText: hintText,
        ),
      ),
    );
  }
}
