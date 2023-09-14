import 'package:flutter/material.dart';
import 'package:fluttersignin/components/my_button.dart';
import 'package:fluttersignin/components/my_textfield.dart';
import 'package:fluttersignin/controller/login_controller.dart';
import 'package:fluttersignin/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //signuser in methods
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            //logo
            const Icon(
              Icons.lock,
              size: 100,
            ),

            const SizedBox(
              height: 50,
            ),
            // welcome
            Text(
              'Welcome back, Sir!',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(
              height: 35,
            ),

            //username
            textFields(
              controller: usernameController,
              hintText: 'Username',
              obscureText: false,
            ),
            const SizedBox(height: 15),

            //Password
            textFields(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            //forgot password

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            //signin button
            MyButton(
              onTap: signUserIn,
            ),

            const SizedBox(
              height: 45,
            ),
            //signin with fb/google
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30,),


            //not a member?register
            FloatingActionButton.extended(
              onPressed: () async {
                await LoginController().signInWithGoogle();
                if (mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                }
              },
              icon: Image.asset(
                'lib/assets/google.png',
                height: 32,
                width: 32,
              ),
              label: const Text('Sign in with google'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            )
          ]),
        ),
      ),
    );
  }
}
