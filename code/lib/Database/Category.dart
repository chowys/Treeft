import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class CategoryService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'Categories';

  void createCategory(String name) {
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection(ref).doc(categoryId).set({'Category': name});
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => _firestore
          .collection(ref)
          .where('Category', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}
