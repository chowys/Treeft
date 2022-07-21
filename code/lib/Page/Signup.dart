import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Reusable/HelperMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFDE59),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xffFFDE59),
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
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
                reusableTextField("Enter username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signingnresetButton(context, "SIGN UP", () async {
                  /*FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Account created successfully");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homescreen()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });*/

                  /*FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Account created successfully");


                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homescreen()));

                    if (value != null && value.user != null) {
                      FirebaseFirestore.instance
                          .collection('UserData')
                          .doc(value.user?.uid)
                          .set({
                        "email": value.user?.email,
                        "uid": value.user?.uid,
                        "Transactions": 0
                      });

                      //create another collection for listings
                    }

                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });*/
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

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homescreen()));
                  } catch (e) {
                    print(e.toString());
                  }
                })
              ],
            ),
          ))),
    );
  }
}
