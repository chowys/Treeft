import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Page/Login.dart';
import 'package:code/Reusable/HelperMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Reusable/reusable_widget.dart';
import 'Homescreen.dart';
import 'Database.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFDE59),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xffFFDE59),
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _key,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter username", Icons.person_outline,
                      false, _userNameTextController, validateUsername),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter email", Icons.person_outline, false,
                      _emailTextController, validateEmail),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter password", Icons.lock_outlined, true,
                      _passwordTextController, validatePassword),
                  const SizedBox(
                    height: 20,
                  ),
                  signingnresetButton(context, "SIGN UP", () async {
                    if (_key.currentState!.validate()) {
                      try {
                        //Creates Account
                        UserCredential cred = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text);

                        //Create UserData
                        User? user = cred.user;
                        await Database().createUserData(
                            _userNameTextController.text,
                            0,
                            user?.uid,
                            _emailTextController.text);

                        //Chat Function
                        HelperFunctions.saveUserLoggedInSharedPreference(true);
                        HelperFunctions.saveUserNameSharedPreference(
                            _userNameTextController.text);
                        HelperFunctions.saveUserEmailSharedPreference(
                            _emailTextController.text);

                        //Navigation
                        print("Account created successfully");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homescreen()));
                      } on FirebaseAuthException catch (error) {
                        Fluttertoast.showToast(
                            msg: error.message!, gravity: ToastGravity.TOP);
                      }
                    }
                  })
                ],
              ),
            ))),
      ),
    );
  }
}

String? validateUsername(String? formUsername) {
  if (formUsername == null || formUsername.isEmpty)
    return 'Username is required.';

  return null;
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'E-mail address is required.';
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'Password is required.';

  return null;
}
