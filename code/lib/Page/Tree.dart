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
              //FUTURE BUILDER HERE TO LOAD TREE
              /*FutureBuilder<DocumentSnapshot>(
                future: users.doc(uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  print(uid);

                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return const Text("Document does not exist");
                  }

                  print("has data");
                  print(snapshot.hasData);
                  print("exists");
                  print(snapshot.data!.exists);

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Image.asset(generateTree(data['transactions']),
                        height: 300, width: 300);
                  }

                  return const Text("loading");
                },
              ),*/

              Image.asset(generateTree(), height: 300, width: 300),

              LinearPercentIndicator(
                width: 180.0,
                percent: generateEXP(),
                animation: true,
                animationDuration: 1500,
                leading: const Text(
                  "Current Lvl",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: const Text(
                  "Next Lvl",
                  style: TextStyle(fontSize: 20),
                ),
                progressColor: Colors.green,
              ),
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            //Text(Database.fetchTransaction());
          },
          child: Text('Check'),
        ),*/
      ),
    );
  }

  String generateTree() {
    //print("tree");
    //print(trans);
    if (trans < 5 && trans >= 0) {
      return "assets/images/Sapling.png";
    } else if (trans < 10 && trans >= 5) {
      return "assets/images/growingtree.png";
    } else if (trans == -1) {
      return "assets/images/loading.png";
    }
    return "assets/images/Tree1.png";
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
