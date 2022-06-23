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

  static int fetchTransaction() {
    final user = FirebaseAuth.instance.currentUser;
    int trans = 0;

    FirebaseFirestore.instance
        .collection('UserData')
        .doc(user?.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> ds) {
      trans = ds.data()!['transactions'];
      print(trans);
      print("fetched");
      return trans;
    }).catchError((e) {
      print(e);
    });

    /*print(trans);
    print("returned");
    return trans;*/
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
