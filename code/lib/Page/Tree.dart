import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Database.dart';

class Tree extends StatefulWidget {
  const Tree({Key? key}) : super(key: key);
  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  static const String _title = 'Tree';
  String tree = "assets/images/Loading.jpg";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: Color(0xffFFDE59),
        ),
        body: Center(
          //Determines type of tree based on transaction
          child: Image.asset(generateTree()),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            //Text(Database.fetchTransaction());
          },
          child: Text('Check'),
        ),
      ),
    );
  }

  String generateTree() {
    print(Database.fetchTransaction());
    print("method value");
    if (Database.fetchTransaction() < 5 && Database.fetchTransaction() >= 0) {
      return "assets/images/Tree1.jpg";
    } else if (Database.fetchTransaction() < 10 &&
        Database.fetchTransaction() >= 5) {
      return "assets/images/Tree2.png";
    }
    return "assets/images/Tree3.jpg";
  }

  /*int generateEXP() {
    if (Database.fetchTransaction() % 5 == 0) {
      //blank exp bar
      return 
    }
  }*/
}

/*class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}*/

/*class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Color(0xffFFDE59), textStyle: const TextStyle(fontSize: 20));

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 30),
          ElevatedButton(
            style: style,
            onPressed: () {
            },
            child: const Text('Update'),
          ),
        ],
      ),
      
    );
  }
  }*/
