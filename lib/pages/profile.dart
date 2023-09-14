import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersignin/pages/home.dart';
import 'package:fluttersignin/utils/nextscreen.dart';
import 'package:provider/provider.dart';
import 'package:fluttersignin/providers/sign_in_provider.dart';
import 'package:fluttersignin/controller/test.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage("${sp.imageUrl}"),
            radius: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Welcome ${sp.name}",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Email: ${sp.email}",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Provider: "),
              const SizedBox(
                width: 5,
              ),
              Text(
                "${sp.provider}".toUpperCase(),
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                sp.userSignOut();
                nextScreenReplace(context, const HomePage());
              },
              child: Text("Logout", style: TextStyle(color: Colors.white),))
        ],
      ),
      
      ),
    );
  }
}
