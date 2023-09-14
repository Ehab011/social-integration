import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class LoginController {
  
  Future<UserCredential?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    User? user = userCredential.user;
    if(user != null){
      String userName = user.displayName ?? "No Name";
        String userEmail = user.email ?? "No Email";
        String userId = user.uid;
        String userPhotoUrl = user.photoURL ?? "";
        
        // You can use this information as needed.
        print("User Name: $userName");
        print("User Email: $userEmail");
        print("User ID: $userId");
        print("User Photo URL: $userPhotoUrl");
      }
      return userCredential;
  }

  Future<void> logout() async {
    final GoogleSignIn googleSign = GoogleSignIn();
    await googleSign.signOut();
  }
}
