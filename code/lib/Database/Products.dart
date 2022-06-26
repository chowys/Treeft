import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'Products';

  void uploadProduct(
      {required String productName,
      required String category,
      required List images,
      required double price}) {
    var id = Uuid();
    String productId = id.v1();
    _firestore
        .collection(ref)
        .doc(productId)
        .set({'name': productName, 'id': productId, 'category': category});
  }
}
