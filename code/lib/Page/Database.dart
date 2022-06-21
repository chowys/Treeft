import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('UserData');

  Future<void> createUserData(
      String username, int transactions, String? uid) async {
    return await userList
        .doc(uid)
        .set({'username': username, 'transactions': transactions, 'uid': uid});
  }

  Future updateUserList(String username, int transactions, String? uid) async {
    return await userList.doc(uid).update(
        {'username': username, 'transactions': transactions, 'uid': uid});
  }

//for hong yuan
  Future listingList(
      String title, int price, String description, String? uid) async {
    return await userList
        .doc(uid)
        .update({'title': title, 'price': price, 'description': description});
  }

  /*Future getTransactions() async {
    int numTrans = 0;

    try {
      await userList.getDoc().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return numTrans;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/
}
