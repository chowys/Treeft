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

  Future<void> updateUserList(
      String username, int transactions, String? uid, String email) async {
    return await userList.doc(uid).set({
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

  Future<void> addMessage(String chatRoomId, chatMessageData,
      List<String> users, String msgID) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(msgID)
        .set(chatMessageData)
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

  getOffers(String chatRoomId, String myUserName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection('chats')
        .where('isOffer', isEqualTo: true)
        .where('sendBy', isNotEqualTo: myUserName)
        .where('accepted', isEqualTo: false)
        .snapshots();
  }

  updateOffer(String chatRoomId, String myUserName, String offer, int time,
      String msgID) async {
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection('chats')
        .doc(msgID)
        .update({
      "sendBy": myUserName,
      "message": offer,
      'time': time,
      'isOffer': true,
      'accepted': true,
      'msgID': msgID
    });
  }
}
