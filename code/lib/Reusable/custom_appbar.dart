import 'package:code/Page/Selling.dart';
import 'package:code/Page/chatmenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black), //icon colour
      backgroundColor: Color(0xffFFDE59),
      title: Container(
        color: Color(0xffFFDE59),
        padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
        child: Text('Treeft',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black)),
      ),
      actionsIconTheme: IconThemeData(color: Colors.black),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatRoom()),
              );
            },
            icon: Icon(Icons.chat)),
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Selling()),
              );
            },
            icon: Icon(CupertinoIcons.money_dollar))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.0);
}
