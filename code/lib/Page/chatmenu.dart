import 'package:code/Page/ChatRoom.dart';
import 'package:code/Page/Database.dart';
import 'package:code/Page/search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Reusable/HelperMethods.dart';
import '../constants.dart';

class ChatMenu extends StatefulWidget {
  const ChatMenu({Key? key}) : super(key: key);

  @override
  _ChatMenuState createState() => _ChatMenuState();
}

class _ChatMenuState extends State<ChatMenu> {
  Stream<QuerySnapshot>? chatRoomsStream;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    //username here is targetusername
                    targetUserName: snapshot.data!.docs[index]['chatroomid']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data!.docs[index]["chatroomid"],
                  );
                })
            : Container();
      },
    );
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Database().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRoomsStream = snapshots;
        print(
            "we got the data + ${chatRoomsStream.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color(0xffFFDE59),
        title: Text('Chats',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black)),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFFDE59),
        child: Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String targetUserName;
  final String chatRoomId;

  ChatRoomsTile({required this.targetUserName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoom(
                      chatRoomId: chatRoomId,
                      targetUser: targetUserName,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text(targetUserName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(targetUserName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
