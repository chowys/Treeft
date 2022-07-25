import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Page/Database.dart';
import 'package:code/Reusable/HelperMethods.dart';
import 'package:flutter/material.dart';
import 'package:code/Reusable/widget.dart';

import '../constants.dart';
import 'ChatRoom.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

late String _myName;

class _SearchState extends State<Search> {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  TextEditingController searchEditingController = new TextEditingController();
  Database databaseMethods = new Database();
  late QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;
  bool roomExists = false;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
    print("${_myName}");
  }

  Widget searchList() {
    return haveUserSearched
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index]["username"],
                userEmail: searchSnapshot.docs[index]["email"],
              );
            })
        : Container();
//to ensure promise is kept and no runtime if back button is pressed when no search is made
    /*ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SearchTile(
            userName: "No Results",
            userEmail: "No Results",
          );
        });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(137, 34, 33, 33),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xffFFDE59),
        title: Text('Search',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black)),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color(0x54fffffff),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchEditingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "search username ...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight),
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                            IconData(0xe567, fontFamily: 'MaterialIcons'))),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }

  //create Chatrooms, send user to convo screen, pushreplacement
  createChatAndStartConvo(String userName) {
    print("${userName} is the target User");
    print("${_myName} is you");
    if (userName != _myName) {
      String chatRoomId = getChatRoomId(userName, _myName);

      List<String> users = [userName, _myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId,
        "hasMessages": false
      };

//if Chatroom alr exists, do not create new one
      /*updateRoomExists(chatRoomId);

      if (!roomExists) {
        Database().createChatRoom(chatRoomId, chatRoomMap);
        print('new room created');
      }*/
      createRoom(chatRoomId, chatRoomMap);

      print("${chatRoomId} is chatroom id");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                    chatRoomId: chatRoomId,
                    targetUser: userName,
                  )));
    } else {
      print("You cannot send a message to yourself");
    }
  }

  //creates room according to if it exists already
  createRoom(String chatRoomId, Map<String, dynamic> chatRoomMap) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .get();

    roomExists = ds.exists;

    if (!roomExists) {
      await Database().createChatRoom(chatRoomId, chatRoomMap);
      print('new room created');
    }
  }

//assigns true if room exists
  /*updateRoomExists(String chatRoomId) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .get();

    roomExists = ds.exists;
    print(roomExists);
  }*/

  Widget SearchTile({required userName, required userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatAndStartConvo(userName);
            },
            child: checkUserValidity(userName),
          )
        ],
      ),
    );
  }

//prevent self-messaging
  Widget checkUserValidity(String targetUser) {
    if (targetUser != _myName) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(24)),
        child: Text(
          "Message",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(24)),
      child: Text(
        "Message",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      await databaseMethods
          .getUserByUsername(searchEditingController.text)
          .then((val) {
        searchSnapshot = val;
        print("$searchSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }
}

getChatRoomId(String a, String b) {
  print("getChatRoomId Succesful");
  print("a is ${a}");
  print("b is ${b}");
  if (a.compareTo(b) == 1) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}



/*getUserInfo() async {
  -_myName = await HelperFunctions.getUserNameSharedPreference();
  setState(() {

  });
}*/


/*class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(color: Colors.black),
              ),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              createChatAndStartConvo(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: const Text(
                "Message",
              ),
            ),
          )
        ],
      ),
    );
  }
}*/
