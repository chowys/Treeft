import 'package:code/Page/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:code/Page/Tree.dart';
import 'package:code/Blocs/blocs.dart';
import 'package:code/Models/models.dart';

class CustomNavBar extends StatelessWidget {
  final String screen;
  final Product? product;

  const CustomNavBar({
    Key? key,
    required this.screen,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xffFFDE59),
      child: Container(
        height: 70,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          IconButton(
              icon: Icon(Icons.home, color: Colors.black),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              }),
          IconButton(
              icon: Icon(CupertinoIcons.tree, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Tree()),
                );
              }),
          IconButton(
              icon: Icon(Icons.lock),
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                });
                Navigator.pop(context);
              }),
        ]),
      ),
    );
  }
}
