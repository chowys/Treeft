import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'Database.dart' as u;

class Tree extends StatefulWidget {
  const Tree({Key? key}) : super(key: key);
  @override
  State<Tree> createState() => _TreeState();
}

class _TreeState extends State<Tree> with TickerProviderStateMixin {
  static const String _title = 'Treeft Tree';
  String tree = "assets/images/Loading.jpg";
  late AnimationController controller;
  int trans = -1;
  String transString = 'Loading';

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    CollectionReference users =
        FirebaseFirestore.instance.collection('UserData');

//update at the start
    updateTransaction();

    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            _title,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xffFFDE59),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Background1.png"),
                fit: BoxFit.cover),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(generateTree(), height: 300, width: 300),
              LinearPercentIndicator(
                width: 248.7,
                percent: generateEXP(),
                animation: true,
                animationDuration: 1500,
                leading: generateLeftLvl(),
                trailing: generateRightLvl(),
                progressColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateTree() {
    if (trans < 5 && trans >= 0) {
      return "assets/images/Sapling.png";
    } else if (trans < 10 && trans >= 5) {
      return "assets/images/growingtree.png";
    } else if (trans == -1) {
      return "assets/images/loading.png";
    }
    return "assets/images/Tree1.png";
  }

  Widget generateLeftLvl() {
    if (trans == -1) {
      return Text(
        "Lvl --",
        style: TextStyle(fontSize: 20),
      );
    }
    ;
    return Text(
      "Lvl ${trans}",
      style: TextStyle(fontSize: 20),
    );
  }

  Widget generateRightLvl() {
    if (trans == -1) {
      return Text(
        "Lvl --",
        style: TextStyle(fontSize: 20),
      );
    }
    ;
    return Text(
      "Lvl ${trans + 1}",
      style: TextStyle(fontSize: 20),
    );
  }

  double generateEXP() {
    //print('exp');
    //print(trans);
    if (trans < 0) {
      return 0.00;
    } else if (trans <= 5 && trans >= 0) {
      return trans / 5.00;
    } else if (trans > 5 && trans <= 10) {
      return (trans - 5.00) / 5.00;
    } else if (trans > 10 && trans <= 15) {
      return (trans - 10.00) / 5.00;
    }
    return 1.00;
  }

  void updateTransaction() {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('UserData')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> ds) {
      trans = ds.data()!['transactions'];
      transString = "Lvl$trans";
    }).catchError((e) {
      print(e);
    });
  }
}
