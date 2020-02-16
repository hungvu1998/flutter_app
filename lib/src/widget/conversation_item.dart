import 'package:flutter/material.dart';

class ConversationItem extends StatefulWidget {
  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(),

        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: SlideAction(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: SlideAction(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.phone,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 16.0),
            child: SlideAction(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.videocam,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
        ],
        secondaryActions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: SlideAction(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: SlideAction(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications,
                color: Colors.black,
                size: 20.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: SlideAction(
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restore_from_trash,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
