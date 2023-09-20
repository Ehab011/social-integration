import 'package:flutter/material.dart';
import 'package:fluttersignin/utils/nextscreen.dart';
import 'package:provider/provider.dart';
import 'package:fluttersignin/providers/sign_in_provider.dart';
import 'package:fluttersignin/pages/home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData(); // Initialize user data when the page loads
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange[900], 
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                sp.userSignOut(); // Trigger sign-out when the exit button is pressed
                nextScreenReplace(context, const HomePage()); // Navigate to the home page
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display user profile picture in a circular container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage("${sp.imageUrl}"),
                  radius: 50,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Display the user's name with a bold font
              Text(
                "Welcome ${sp.name}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              // Display the user's email address
              Text(
                "Email: ${sp.email}",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              // Display the user's provider information
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Provider: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "${sp.provider}".toUpperCase(),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
