import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/bloc/chat_bloc.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:flutter_app/src/widget/profile.dart';
import 'package:flutter_app/src/widget/profile_clipper.dart';
import 'package:flutter_app/src/widget/search_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'conversation_item.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;

  const ChatPage({Key key, this.userModel}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseMessaging _firebaseMessaging =  new FirebaseMessaging();
  final Firestore nodeRoot = Firestore.instance;
  //bool _isSearch=false;
  final _textSearchController = TextEditingController();
  final FocusNode focusNode = new FocusNode();
  bool _isScroll = false;
  ScrollController _controller;


  _scrollListener() {
    if (_controller.offset > 0) {
      this.setState(() {
        _isScroll = true;
      });
    } else {
      this.setState(() {
        _isScroll = false;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SearchPage()
      ));
    }
  }


  @override
  void initState() {
    setUpNotification();
    focusNode.addListener(onFocusChange);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void setUpNotification() async {
    _firebaseMessaging.getToken().then((token){
      nodeRoot.collection('users').document(authBloc.userCurrent.uid).updateData({'token': token});
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print("Message: $message");
      },
      onResume: (Map<String, dynamic> message) async{
        print("Message: $message");
      },
      onLaunch: (Map<String, dynamic> message) async{
        print("Message: $message");
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
//        if(_isSearch){
//          setState(() {
//            FocusScope.of(context).requestFocus(FocusNode());
//            _isSearch=!_isSearch;
//            _textSearchController.clear();
//          });
//          return false;
//        }
//        else if(focusNode.hasFocus)
//          return false;
//        else
          return true;
      },
      child: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildAppBarMessage(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: widget.userModel.idChat.length + 2,
                  itemBuilder: (context,index){
                    if(index == 0){
                      return _buildSearchBar();
                    }
                    else if(index == 1){
                      return Container(

                      );
                    }
                    else
                      return
                      StreamBuilder(
                        stream: nodeRoot
                            .collection('chats/' + widget.userModel.idChat[index-2].toString() + '/message')
                            .orderBy("timestamp",descending: true)
                            .snapshots(),
                        builder: (context,snapshotChat){
                          if(!snapshotChat.hasData){
                            return  Container();
                          }
                          else{
                            return ConversationItem(

                              datas: snapshotChat.data.documents[0],
                              idChat:  widget.userModel.idChat[index-2].toString(),
                              listIdChat: widget.userModel.idChat,
                            );
                          }

                        },

                      );

                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBarMessage(){
    return Padding(
      padding: EdgeInsets.only(
        top:40, left:16,right: 16,
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Profile(
                  imgUrl: widget.userModel.imageAvatarUrl,
                );
              }));
            },
            child: ClipOval(
              clipper: ProfileClipper(),
              child: Image.network(
                widget.userModel.imageAvatarUrl,
                width:45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text("Chat",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(
                    FontAwesomeIcons.camera,
                    size: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(
                    FontAwesomeIcons.pen,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildSearchBar(){
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0,top: 20.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 7,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SearchPage()
                ));
              },
              child: Container(
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  children: <Widget>[
                    Container(width: 10.0,),
                    Icon(Icons.search),
                    Container(width: 8.0,),
                    Expanded(
                        child: Text(
                          'Search'
                        ),
//                      child: TextField(
//                        //focusNode: focusNode,
//                        controller: _textSearchController,
//                        onChanged: (value){
//                          chatBloc.feedSearchVal(value);
//                        },
//                        decoration: InputDecoration(
//                            border: InputBorder.none,
//                            hintText: 'Search'
//                        ),
//                      ),

                    )
                  ],
                ),
              ),
            ),
          ),
//          _isSearch ?
//          Flexible(
//            flex: 1,
//            child: Padding(
//              padding: EdgeInsets.only(left: 15),
//              child: InkWell(
//                onTap: (){
//                  setState(() {
//                    _textSearchController.clear();
//                    _isSearch=!_isSearch;
//                    FocusScope.of(context).requestFocus(FocusNode());
//                  });
//                },
//                child: Text(
//                  "Hủy"
//                ),
//              ),
//            ),
//          ) : Container()
        ],
      ),

    );

  }

  _buildListStories(){
    return Container(
      height: 100,
      padding: EdgeInsets.only(top: 16.0),
      child: StreamBuilder(
        stream: null,
        builder: (context,snapshot){
          return Container(

          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textSearchController.clear();
   super.dispose();
  }



}
