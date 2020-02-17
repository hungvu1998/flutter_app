import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'messenger_app_bar.dart';

class DetailChatPage extends StatefulWidget {
  final String friendName;
  final bool isActive;
  final String urlImg;
  final String idChat;

  const DetailChatPage({Key key, this.friendName, this.isActive, this.urlImg,this.idChat}) : super(key: key);
  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  bool _isScroll = false;
  final Firestore nodeRoot = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            _buildAppBar(),
            widget.idChat!=null ?Expanded(
              child: StreamBuilder(
                stream: nodeRoot
                    .collection('chats/' + widget.idChat + '/message')
                    .orderBy("timestamp",descending: true)
                    .snapshots(),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context,index){
                        return Padding(

                        );
                      },
                    );
                  }
                },
              ),

            )

          ],
        ),
      ),
    );
  }
  _buildAppBar() {
    return MessengerAppBarAction(
      isScroll: _isScroll,
      isBack: true,
      title: widget.friendName,
      imageUrl:widget.urlImg,
      isActive: widget.isActive,
      actions: <Widget>[
        Icon(
          FontAwesomeIcons.phoneAlt,
          color: Colors.lightBlue,
          size: 20.0,
        ),
        Icon(
          FontAwesomeIcons.infoCircle,
          color: Colors.lightBlue,
          size: 20.0,
        ),
      ],
    );
  }
}


