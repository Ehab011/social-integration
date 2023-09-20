import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttersignin/pages/profile.dart';
import 'package:fluttersignin/pages/register.dart';
import 'package:fluttersignin/providers/internet_provider.dart';
import 'package:fluttersignin/providers/sign_in_provider.dart';
import 'package:fluttersignin/utils/nextscreen.dart';
import 'package:fluttersignin/utils/snack_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: _buildBody(),
      ),
    );
  }

  //Body of the Scaffold
  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 230, 81, 0),
            Color.fromARGB(255, 239, 108, 0),
            Color.fromARGB(255, 255, 167, 38),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 60),
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: _buildContainerDecoration(),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
  //Header style
  Widget _buildHeader() {
    return const Padding(
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
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(60),
        topRight: Radius.circular(60),
      ),
    );
  }

  //Content of scaffold(buttons,TextFields,...)

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Icon(
          FontAwesomeIcons.userAstronaut,
          size: 50,
          color: Colors.orange[900],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                //Email TextField
                emailTextField(),
                const SizedBox(height: 10),

                //password text field
                  passwordTextField(),
                const SizedBox(
                  height: 10,
                ),

                //Don't have an account, register navigator
                registerNavigator(),
                const SizedBox(height: 20),

                //Login button with email (not implemented yet)
                _buildLoginButton(),
                const SizedBox(height: 20),
                _buildContinueWith(),
                const SizedBox(height: 20),

                //Login with google button
                _buildSignInButton(
                  controller: googleController,
                  icon: FontAwesomeIcons.google,
                  color: Colors.red,
                  text: "Google",
                  onPressed: () {
                    _handleGoogleSignIn();
                  },
                ),

                //Login with facebook button
                const SizedBox(height: 15),
                _buildSignInButton(
                  controller: facebookController,
                  icon: FontAwesomeIcons.facebook,
                  color: Colors.blue,
                  text: "Facebook",
                  onPressed: () {
                    _handleFacebookSignIn();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Text registerNavigator() {
    return Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register here",
                      style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          nextScreen(context, RegisterPage());
                        },
                    ),
                  ],
                ),
              );
  }

  TextFormField passwordTextField() {
    return TextFormField(
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password must be 6 characters";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.orange[900]),
                    prefixIcon:
                        Icon(FontAwesomeIcons.lock, color: Colors.orange[900]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                );
  }

  TextFormField emailTextField() {
    return TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
                validator: (val) {
                  return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                      ? null
                      : "Please enter a valid email";
                },
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.orange[900]),
                  prefixIcon: Icon(FontAwesomeIcons.envelope,
                      color: Colors.orange[900]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              );
  }
  //Email Login button
  Widget _buildLoginButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange[900],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
  //Or Continue with text builder
  Widget _buildContinueWith() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Or Continue with",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
  //Login button builder(facebook/google)
  Widget _buildSignInButton({
    required RoundedLoadingButtonController controller,
    required IconData icon,
    required Color color,
    required String text,
    required VoidCallback onPressed,
  }) {
    return RoundedLoadingButton(
      controller: controller,
      onPressed: onPressed,
      successColor: color,
      width: MediaQuery.of(context).size.width * 0.40,
      elevation: 0,
      borderRadius: 25,
      color: color,
      child: Wrap(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  


  //Read user data from shared preferences and check for internet connection
  Future<void> _handleGoogleSignIn() async {
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
          // Check user existence
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // User exists
              await sp.getUserDataFromFireStore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        googleController.success();
                        _handleAfterSignIn();
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        googleController.success();
                        _handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }
  //Read user data from shared preferences and check for internet connection

  Future _handleFacebookSignIn() async {
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
                        _handleAfterSignIn();
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignInUser().then((value) {
                        facebookController.success();
                        _handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  //1 second delay before navigation
  void _handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const ProfilePage());
    });
  }

}


  

  