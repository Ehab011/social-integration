import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttersignin/components/my_button.dart';
import 'package:fluttersignin/pages/home.dart';
import 'package:fluttersignin/utils/nextscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String fullName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
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
          SizedBox(height: 60),
          _buildHeader(),
          SizedBox(height: 20),
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

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Register",
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          SizedBox(height: 10),
          Text(
            "Create your account!",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(60),
        topRight: Radius.circular(60),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Icon(
          FontAwesomeIcons.userCheck,
          size: 80,
          color: Colors.orange[900],
        ),
        SizedBox(height: 50),
        _buildInputField(
          labelText: "Full name",
          prefixIcon: FontAwesomeIcons.user,
          onChanged: (val) {
            setState(() {
              fullName = val;
            });
          },
          validator: (val) {
            if (val!.isNotEmpty) {
              return null;
            } else {
              return "Name can't be empty!";
            }
          },
        ),
        SizedBox(height: 20),
        _buildInputField(
          labelText: "Email",
          prefixIcon: FontAwesomeIcons.envelope,
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
        ),
        SizedBox(height: 20),
        _buildInputField(
          labelText: "Password",
          prefixIcon: FontAwesomeIcons.lock,
          onChanged: (val) {
            setState(() {
              password = val;
            });
          },
          validator: (val) {
            if (val!.length < 6) {
              return "Password must be at least 6 characters";
            } else {
              return null;
            }
          },
          obscureText: true,
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
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
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Text.rich(
          TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Login now",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    nextScreen(context, HomePage());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String labelText,
    required IconData prefixIcon,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.orange[900],
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.orange[900],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.white,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
