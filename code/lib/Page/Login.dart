import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Page/Database.dart';
import 'package:code/Page/Homescreen.dart';
import 'package:code/Page/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Reusable/HelperMethods.dart';
import '../Reusable/reusable_widget.dart';
import 'Resetpassword.dart';

class LogIn extends StatefulWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => LogIn(),
    );
  }

  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late QuerySnapshot snapshotUserInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFDE59),
      body: Form(
        key: _key,
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/pixelatedtree.png"),
                  SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Enter email", Icons.person_outline, false,
                      _emailTextController, validateEmail),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter password", Icons.lock_outline, true,
                      _passwordTextController, validatePassword),
                  SizedBox(
                    height: 5,
                  ),
                  forgetPassword(context),
                  signingnresetButton(context, "SIGN IN", () {
                    if (_key.currentState!.validate()) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        //chat method
                        HelperFunctions.saveUserLoggedInSharedPreference(true);
                        //chat method
                        HelperFunctions.saveUserEmailSharedPreference(
                            _emailTextController.text);

                        Database()
                            .getUserByEmail(_emailTextController.text)
                            .then((val) {
                          snapshotUserInfo = val;
                          HelperFunctions.saveUserNameSharedPreference(
                              snapshotUserInfo.docs[0]['username']);
                          print(
                              "${snapshotUserInfo.docs[0]['username']} is your Username");
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Homescreen()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }
                  }),
                  signUpOption()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signup()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
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
