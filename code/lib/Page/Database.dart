import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final CollectionReference userList =
      FirebaseFirestore.instance.collection('UserData');

  Future<void> createUserData(
      String username, int transactions, String? uid, String email) async {
    return await userList.doc(uid).set({
      'username': username,
      'transactions': transactions,
      'uid': uid,
      'email': email
    });
  }

//dont touch for now
  Future updateUserList(
      String username, int transactions, String? uid, String email) async {
    return await userList.doc(uid).update({
      'username': username,
      'transactions': transactions,
      'uid': uid,
      'email': email
    });
  }

  getUserByUsername(String username) {
    return FirebaseFirestore.instance
        .collection('UserData')
        .where('username', isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) {
    return FirebaseFirestore.instance
        .collection('UserData')
        .where('email', isEqualTo: email)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(
      String chatRoomId, chatMessageData, List<String> users) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });

    //update hasMessages when there is at least 1 message
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).update(
        {"users": users, "chatroomid": chatRoomId, "hasMessages": true});
  }

  getUserChats(String myUserName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: myUserName)
        .where("hasMessages", isEqualTo: true)
        .snapshots();
  }

  /*static Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('UserData')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  static Future<User?> readUser() async {
    final user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
// Get single document
    final docUser = FirebaseFirestore.instance.collection('UserData').doc(uid);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      return User.fromJson(snapshot.data()!['transactions']);
    }

    return null;
  }*/

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

/*class User {
  String uid;
  final String username;
  int transactions;

  User({this.uid = '', required this.username, required this.transactions});

//same function as the one used in databse class
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'transaction': transactions,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      uid: json['uid'],
      username: json['username'],
      transactions: json['transactions']);
}*/
