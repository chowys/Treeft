import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code/Page/Database.dart';
import 'package:flutter/material.dart';
import 'package:code/Reusable/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Size get preferredSize => const Size.fromHeight(100);

  TextEditingController searchEditingController = new TextEditingController();
  Database databaseMethods = new Database();
  late QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

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
      appBar: AppBar(
        backgroundColor: const Color(0xffFFDE59),
        title: const Text('Search'),
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
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: "search username ...",
                        hintStyle: TextStyle(
                          color: Colors.black,
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

//create Chatrooms, send user to convo screen, pushreplacement
  createChatAndStartConvo(String userName) {
    //List<String> users = [userName, ];
    //databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
  }
}

class SearchTile extends StatelessWidget {
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
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: const Text(
              "Message",
            ),
          )
        ],
      ),
    );
  }
}
