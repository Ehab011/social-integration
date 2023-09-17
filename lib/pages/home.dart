import 'package:flutter/material.dart';
import 'package:fluttersignin/components/my_button.dart';
import 'package:fluttersignin/components/my_textfield.dart';
import 'package:fluttersignin/controller/login_controller.dart';
import 'package:fluttersignin/pages/profile.dart';
import 'package:fluttersignin/providers/internet_provider.dart';
import 'package:fluttersignin/providers/sign_in_provider.dart';
import 'package:fluttersignin/utils/nextscreen.dart';
import 'package:fluttersignin/utils/snack_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Colors.deepOrange,
              Colors.orange,
              Colors.deepOrange,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                              controller: googleController,
                              onPressed: () {
                                handleGoogleSignIn();
                              },
                              successColor: Colors.red,
                              width: MediaQuery.of(context).size.width * 0.80,
                              elevation: 0,
                              borderRadius: 25,
                              color: Colors.red,
                              child: Wrap(
                                children: const[
                                  Icon(
                                    FontAwesomeIcons.google,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              )
                              ),
                          const SizedBox(height: 15,),

                          RoundedLoadingButton(
                              controller: facebookController,
                              onPressed: () {
                                handleFacebookSignIn();
                                
                              },
                              successColor: Colors.blue,
                              width: MediaQuery.of(context).size.width * 0.80,
                              elevation: 0,
                              borderRadius: 25,
                              color: Colors.blue,
                              child: Wrap(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.facebook,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Sign in with Facebook",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              )),
                        ])))
          ],
        ),
      ),
    );
  }

  //handle google signin
  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasErrors == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          //check user existence
          sp.checkUserExists().then((value) async {
            if (value == true) {
              //user exists
              await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        googleController.success();
                        handleAfterSignIn(); 
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }
  //handle facebook signin
  Future handleFacebookSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) {
        if (sp.hasErrors == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.blue);
          facebookController.reset();
        } else {
          //check user existence
          sp.checkUserExists().then((value) async {
            if (value == true) {
              //user exists
              await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        facebookController.success();
                        handleAfterSignIn(); 
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  //handle after sign in
  handleAfterSignIn() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const ProfilePage());
    });
  }
}

