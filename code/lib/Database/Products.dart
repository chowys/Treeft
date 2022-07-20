import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Page/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'Products';
  final FirebaseAuth auth = FirebaseAuth.instance;

  /*Future<String> getUserName() async {
    final CollectionReference users = _firestore.collection('UserData');
    final String uid = auth.currentUser!.uid;
    final result = await users.doc(uid).get();
    final data = result.data() as Map<String, dynamic>;
    return data['username'];
  }
  */

  void uploadProduct({
    required String name,
    required String category,
    required List<dynamic> images,
    required double price,
    required String description,
    required bool featured,
    required bool general,
    required String username,
  }) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).doc(productId).set({
      'name': name,
      'uid': uid,
      'images': images,
      'price': price,
      'category': category,
      'description': description,
      'featured': featured,
      'general': general,
      'username': username,
    });
  }
}
