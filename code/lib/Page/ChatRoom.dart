import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Page/Database.dart';
import 'package:code/Page/offers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../Reusable/HelperMethods.dart';
import '../constants.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final String targetUser;

  ChatRoom({required this.chatRoomId, required this.targetUser});

  @override
  _ChatState createState() => _ChatState();
}

late String _myName;

class _ChatState extends State<ChatRoom> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();

  @override
  void initState() {
    getUserInfo();
    print(Database().getConversationMessages(widget.chatRoomId));
    Database().getConversationMessages(widget.chatRoomId).then((val) async {
      print("${val} is val");

      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
    print("${_myName} My name in chatroom");
  }

  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .735,
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                        message: snapshot.data!.docs[index]["message"],
                        sendByMe:
                            _myName == snapshot.data!.docs[index]["sendBy"],
                        isOffer: snapshot.data!.docs[index]["isOffer"],
                      );
                    }),
              )
            : Container();
      },
    );
  }

  addMessage() {
    String msgID = FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(widget.chatRoomId)
        .collection("chats")
        .doc()
        .id;

    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": _myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'isOffer': false,
        'accepted': false,
        'msgID': msgID,
        'senderID': FirebaseAuth.instance.currentUser!.uid
      };

      List<String> users = [widget.targetUser, _myName];
      Database().addMessage(widget.chatRoomId, chatMessageMap, users, msgID);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  addOffer() {
    if (messageEditingController.text.isNotEmpty) {
      String msgID = FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .doc()
          .id;
      Map<String, dynamic> chatOfferMap = {
        "sendBy": _myName,
        "message": 'Offer : ${messageEditingController.text}',
        'time': DateTime.now().millisecondsSinceEpoch,
        'isOffer': true,
        'accepted': false,
        'msgID': msgID,
        'senderID': FirebaseAuth.instance.currentUser!.uid
      };

      List<String> users = [widget.targetUser, _myName];
      Database().addMessage(widget.chatRoomId, chatOfferMap, users, msgID);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(137, 34, 33, 33),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffFFDE59),
        title: Text(widget.targetUser,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black)),
        elevation: 0.0,
        centerTitle: false,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: const Color(0x54FFFFFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Message / Offer ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color.fromARGB(153, 255, 255, 255)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/send.png",
                            height: 25,
                            width: 25,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        addOffer();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(169, 154, 52, 52),
                                    Color.fromARGB(153, 236, 10, 10)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            "assets/images/send.png",
                            height: 25,
                            width: 25,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Offers(
                                      chatRoomId: widget.chatRoomId,
                                    )));
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(243, 50, 122, 45),
                                    Color.fromARGB(153, 10, 236, 97)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            IconData(0xe0aa, fontFamily: 'MaterialIcons'),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final bool isOffer;

  MessageTile(
      {required this.message, required this.sendByMe, required this.isOffer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: const Radius.circular(23),
                    topRight: const Radius.circular(23),
                    bottomLeft: const Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: const Radius.circular(23),
                    topRight: const Radius.circular(23),
                    bottomRight: const Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? (isOffer
                      ? [
                          const Color.fromARGB(255, 244, 187, 0),
                          const Color.fromARGB(255, 244, 187, 0)
                        ]
                      : [const Color(0xff007EF4), const Color(0xff2A75BC)])
                  : (isOffer
                      ? [
                          const Color.fromARGB(255, 244, 53, 0),
                          const Color.fromARGB(255, 244, 53, 0)
                        ]
                      : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
