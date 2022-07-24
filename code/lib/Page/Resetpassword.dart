import 'package:code/Page/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Reusable/reusable_widget.dart';
import 'Homescreen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _emailTextController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFDE59),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xffFFDE59),
        elevation: 0,
        title: const Text(
          "Reset Password",
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
                  reusableTextField("Enter email", Icons.person_outline, false,
                      _emailTextController, validateEmail),
                  const SizedBox(
                    height: 20,
                  ),
                  signingnresetButton(context, "RESET PASSWORD", () {
                    if (_key.currentState!.validate()) {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(
                              email: _emailTextController.text)
                          .then((value) => Navigator.of(context).pop());
                    }
                  })
                ],
              ),
            ))),
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
