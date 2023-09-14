import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  //firebase auth, facebook, google instances
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  //hasErrors , errorCode , provider, uid, password, email, name, imageUrl
  bool _hasErrors = false;
  bool get hasErrors => _hasErrors;

  String? _errorCode = null;
  String? get errorCode => _errorCode;

  String? _provider = null;
  String? get provider => _provider;

  String? _uid = null;
  String? get uid => _uid;

  String? _password = null;
  String? get password => _password;

  String? _email = null;
  String? get email => _email;

  String? _name = null;
  String? get name => _name;

  String? _imageUrl = null;
  String? get imageUrl => _imageUrl;

  SignInProvider() {
    checkSignInUser();
  }
  Future checkSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    _isSignedIn = s.getBool('isSignedIn') ?? false;
    notifyListeners();
  }

  Future setSignInUser() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  //signin with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      //execute authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        //siging to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //save user details
        _name = userDetails.displayName;
        _email = userDetails.email;
        _imageUrl = userDetails.photoURL;
        _provider = "GOOGLE";
        _uid = userDetails.uid;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode = "You already have an account with us.";
            _hasErrors = true;
            notifyListeners();
            break;
          case "null":
            _errorCode =
                "Some unexpected error occured while trying to sign in";
            _hasErrors = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasErrors = true;
            notifyListeners();
        }
      }
    } else {
      _hasErrors = true;
      notifyListeners();
    }
  }

  //entry for cloudfirestore
  Future getUserDataFromFireStore(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) => {
              _uid = snapshot['uid'],
              _name = snapshot['name'],
              _email = snapshot['email'],
              _imageUrl = snapshot['imageUrl'],
              _provider = snapshot['provider'],
            });
  }

  //
  Future saveDataToSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('imageUrl', _imageUrl!);
    await s.setString('provider', _provider!);
    await s.setString('uid', _uid!);
    notifyListeners();
  }

  //save data to firestore
  Future saveDataToFirestore() async {
    final DocumentReference r =
        FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name": _name,
      "email": _email,
      "uid": _uid,
      "imageUrl": _imageUrl,
      "provider": _provider,
    });
    notifyListeners();
  }

  //check user existence in cloud storage
  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (snap.exists) {
      print("Existing user");
      return true;
    } else {
      print("New user");
      return false;
    }
  }

  //fetch data from shared preferences
  Future getDataFromSharedPreferences() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _name = s.getString('name');
        _email = s.getString('email');
        _imageUrl = s.getString('imageUrl');
        _provider = s.getString('provider');
        _uid = s.getString('uid');
        notifyListeners();
  }

  //signout
  Future userSignOut() async {
    await firebaseAuth.signOut;
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    //clear storage info
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }
}
