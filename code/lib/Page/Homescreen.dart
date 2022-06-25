import 'package:code/Page/Login.dart';
import 'package:code/Page/Selling.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Tree.dart';
import 'Settings.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Navigation Tabs
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black), //icon colour
        backgroundColor: Color(0xffFFDE59),
        title: const Text('Treeft', style: TextStyle(color: Colors.black)),
      ),

//Drawer
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffFFDE59),
              ),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Treeft Tree'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                // Change to tree page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Tree()),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                // Change to Settings
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Selling()));
          },
          backgroundColor: Colors.black,
          child: Text('Sell')),
    );
  }
}
