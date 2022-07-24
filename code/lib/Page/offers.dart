//Display Offers in this screen
import 'package:code/Page/ChatRoom.dart';
import 'package:code/Page/Database.dart';
import 'package:code/Page/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Reusable/HelperMethods.dart';
import '../constants.dart';

class Offers extends StatefulWidget {
  final String chatRoomId;

  Offers({required this.chatRoomId});

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  Stream<QuerySnapshot>? offerStream;

  Widget offersList() {
    return StreamBuilder(
      stream: offerStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return OffersTile(
                      targetUserName: snapshot.data!.docs[index]["sendBy"],
                      offerDetails: snapshot.data!.docs[index]["message"],
                      timeOfOffer: snapshot.data!.docs[index]["time"],
                      chatRoomId: widget.chatRoomId,
                      msgID: snapshot.data!.docs[index]["msgID"]);
                })
            : Container();
      },
    );
  }

  getUserInfogetOffers() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Database().getOffers(widget.chatRoomId, Constants.myName).then((snapshots) {
      setState(() {
        offerStream = snapshots;
        print(
            "we got the data + ${offerStream.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  void initState() {
    getUserInfogetOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFDE59),
        title: Text('All Offers',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black)),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        child: offersList(),
      ),
    );
  }
}

class OffersTile extends StatefulWidget {
  final String targetUserName;
  final String offerDetails;
  final int timeOfOffer;
  final String chatRoomId;
  final String msgID;

  OffersTile(
      {required this.targetUserName,
      required this.offerDetails,
      required this.timeOfOffer,
      required this.chatRoomId,
      required this.msgID});

  @override
  State<StatefulWidget> createState() => new _OfferView();
}

class _OfferView extends State<OffersTile> {
  bool accepted = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //accepts offer and turn them from red to green by updating the accepted field in firestore
        Database().updateOffer(widget.chatRoomId, widget.targetUserName,
            widget.offerDetails, widget.timeOfOffer, widget.msgID);
        accepted = true;
        updateAccepted();

        String _myUsername = widget.chatRoomId
            .toString()
            .replaceAll("_", "")
            .replaceAll(widget.targetUserName, "");

        List<String> users = [widget.targetUserName, _myUsername];

        Map<String, dynamic> chatMessageData = {
          "sendBy": _myUsername,
          "message": "Accepted ${widget.offerDetails}",
          'time': DateTime.now().millisecondsSinceEpoch,
          'isOffer': false,
          'accepted': false,
          'msgID': 'Accepted ${widget.msgID}',
          'senderID': uid
        };

        Database().addMessage(widget.chatRoomId, chatMessageData, users,
            'Accepted ${widget.msgID}');

        //updates succeful transaction field in userData for both users which updates Tree and Listings
        FirebaseFirestore.instance
            .collection('UserData')
            .doc(uid)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> ds) {
          int trans = ds.data()!['transactions'];
          trans = trans + 1;
          String email = ds.data()!['email'];
          //updates accepting user's data
          Database().updateUserList(_myUsername, trans, uid, email);
          print('updated transactions for accepter');
        }).catchError((e) {
          print(e);
        });

//update offerer's data
        FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .doc(widget.msgID)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> ds) {
          String offererID = ds.data()!['senderID'];

          FirebaseFirestore.instance
              .collection('UserData')
              .doc(offererID)
              .get()
              .then((DocumentSnapshot<Map<String, dynamic>> ds) {
            int trans2 = ds.data()!['transactions'];
            trans2 = trans2 + 1;
            String email2 = ds.data()!['email'];
            //updates accepting user's data
            Database().updateUserList(
                widget.targetUserName, trans2, offererID, email2);
            print('updated transactions for offerer');
          }).catchError((e) {
            print(e);
          });
        }).catchError((e) {
          print(e);
        });
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: !accepted
                  ? BoxDecoration(
                      color: Color.fromARGB(255, 243, 135, 33),
                      borderRadius: BorderRadius.circular(30))
                  : BoxDecoration(
                      color: Color.fromARGB(255, 33, 243, 138),
                      borderRadius: BorderRadius.circular(30)),
              child: Icon(IconData(0xf584, fontFamily: 'MaterialIcons')),
            ),
            SizedBox(
              width: 12,
            ),
            Text(widget.offerDetails,
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

  updateAccepted() {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(widget.msgID)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> ds) {
      accepted = ds.data()!['accepted'];
    }).catchError((e) {
      print(e);
    });
  }
}
