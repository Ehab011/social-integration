import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersignin/controller/login_controller.dart';
import 'package:fluttersignin/controller/test.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';





class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> { 
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(''),
        Text('email'),
        ElevatedButton(
            onPressed: () async {
              await LoginController().logout();
              Navigator.pop(context);
            },
            child: Text('Logout')),
      ],
    );
  }
}
