import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'Products';
  final FirebaseAuth auth = FirebaseAuth.instance;

  void uploadProduct(
      {required String productName,
      required String category,
      required List images,
      required double price,
      required String productDescription}) {
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var id = Uuid();
    String productId = id.v1();
    _firestore.collection(ref).doc(productId).set({
      'name': productName,
      'uid': uid,
      'images': images,
      'price': price,
      'category': category,
      'description': productDescription
    });
  }
}
