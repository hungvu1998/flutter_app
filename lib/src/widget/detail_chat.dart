
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/bloc/chat_bloc.dart';
import 'package:flutter_app/src/model/Message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'messenger_app_bar.dart';


class ChatDetail extends StatefulWidget {
  String idChat;
  final String urlImg;
  final String friendName;
  final bool isActive;
  final String idFriend;
  final List<String> listIdChat;
  //final List<String> listIdChatFriend;
  ChatDetail({Key key, this.idChat,this.urlImg,this.friendName,this.idFriend,this.isActive,this.listIdChat}) : super(key: key);

  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final _isScroll = true;
  final myController = TextEditingController();
  bool isShowSticker;
  File imageFile;
  bool isLoading;
  String imageUrl;
  final Firestore nodeRoot = Firestore.instance;
  final FocusNode focusNode = new FocusNode();


  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  final List<Message> messages = [];
  @override
  void initState() {
    isShowSticker = false;
    isLoading = false;
    imageUrl = '';


    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    focusNode.addListener(onFocusChange);
    firebaseMessaging.getToken().then((token){

      print('--- Firebase toke here ---');

      print(token);

    });

    super.initState();
  }


  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: WillPopScope(
          onWillPop: () async{
            if(isShowSticker){
              setState(() {
                isShowSticker=false;
              });
              return false;
            }
            else
              return true;
          },
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildAppBar(),
                  widget.idChat!=null?Expanded(
                    child: StreamBuilder(
                      stream: nodeRoot
                          .collection('chats/' + widget.idChat + '/message')
                          .orderBy("timestamp",descending: true)
                          .snapshots(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData)
                          return Center(child: CircularProgressIndicator());
                        else{
                          return ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Visibility(
                                      visible:index == snapshot.data.documents.length-1 || (snapshot.data.documents[index]['timestamp'] - snapshot.data.documents[index+1]['timestamp'] >= 3600000) ,
                                      child: Center(
                                        child:  Text(readTimestamp(snapshot.data.documents[index]['timestamp']),
                                            style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 2.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: snapshot.data.documents[index]['idTo'] == authBloc.userCurrent.uid? MainAxisAlignment.start :MainAxisAlignment.end ,
                                        children: <Widget>[
                                          Center(
                                              child: Container(
                                                height: 40.0,
                                                width: 40.0,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  image: snapshot.data.documents[index]['idTo'] == authBloc.userCurrent.uid ? DecorationImage(
                                                    image: NetworkImage(widget.urlImg),
                                                    fit: BoxFit.cover,
                                                  ) :null,
                                                ),
                                              )),
                                          SizedBox(width: 15.0),
                                          Container(
                                            child: Container(
                                                constraints: BoxConstraints(maxWidth: 250),

                                                child:snapshot.data.documents[index]['type'] == 0
                                                    ? Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius: BorderRadius.circular(15.0),
                                                  ),
                                                  child: Text(
                                                    snapshot.data.documents[index]['content'],
                                                    style: TextStyle(fontSize: 16.0,),
                                                  ),)
                                                    :snapshot.data.documents[index]['type'] == 2 ?(Container(
                                                    child: snapshot.data.documents[index]['content']=='like'
                                                        ?  Image.asset('asset/images/sticker/like.png',
                                                      width: 50.0,
                                                      height: 50.0,
                                                      fit: BoxFit.cover,)
                                                        : Image.asset(
                                                      'asset/images/sticker/${snapshot.data.documents[index]['content']}.gif',
                                                      width: 100.0,
                                                      height: 100.0,
                                                      fit: BoxFit.cover,
                                                    )
                                                )) :Container(
                                                  child: FlatButton(
                                                    child: Material(
                                                      child: CachedNetworkImage(
                                                        placeholder: (context, url) => Container(
                                                          child: CircularProgressIndicator(
                                                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
                                                          ),
                                                          width: 200.0,
                                                          height: 200.0,
                                                          padding: EdgeInsets.all(70.0),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xffE8E8E8),
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8.0),
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => Material(
                                                          child: Image.asset(
                                                            'assets/images/img_not_available.jpeg',
                                                            width: 200.0,
                                                            height: 200.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(8.0),
                                                          ),
                                                          clipBehavior: Clip.hardEdge,
                                                        ),
                                                        imageUrl: snapshot.data.documents[index]['content'],
                                                        width: 200.0,
                                                        height: 200.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                      clipBehavior: Clip.hardEdge,
                                                    ),
                                                    onPressed: () {
//                                                      Navigator.push(
//                                                          context, MaterialPageRoute(builder: (context) => FullPhoto(url: snapshot.data.documents[index]['content'])));
                                                    },
                                                    padding: EdgeInsets.all(0),
                                                  ),

                                                )
                                            ),
                                          ),

                                        ],
                                      ),

                                    ),
                                  ],
                                ),
                              );
                            },

                          );
                        }
                      },
                    ),
                  ):
                  Expanded(
                    child: Center(
                        child:Column(
                          children: <Widget>[
                            Padding(
                              padding:  EdgeInsets.only(top:20),
                              child:  Container(
                                width: 100.0,
                                height: 100.0,
                                margin: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  image: DecorationImage(
                                    image: NetworkImage(widget.urlImg),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:10),
                              child: Text(widget.friendName,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                            )

                          ],
                        )
                    ),
                  ),
                  (isShowSticker ? buildSticker() : Container()),
                  _buildBottomChat(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var format2 = new DateFormat('dd-MM-yyyy HH:mm a');
    var date = new  DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    }
    else{
      time =format2.format(date);
    }
//    } else if (diff.inDays > 0 && diff.inDays < 7) {
//      if (diff.inDays == 1) {
//        time = diff.inDays.toString() + ' DAY AGO';
//      } else {
//        time = diff.inDays.toString() + ' DAYS AGO';
//      }
//    } else {
//      if (diff.inDays == 7) {
//        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
//      } else {
//
//        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
//      }
//    }

    return time;
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
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

  _buildBottomChat() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: InkWell(
                onTap: getImage,
                child: Icon(
                  FontAwesomeIcons.image,
                  size: 25.0,
                  color: Colors.lightBlue,
                ),
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Container(
              child: Stack(
                children: <Widget>[
                  TextField(
                    controller: myController,
                    focusNode: focusNode,
                    onChanged: (value) {
                      chatBloc.feedMessageVal(value);
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: 'Aa',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:10,right: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: getSticker,
                        child: Icon(
                          FontAwesomeIcons.solidSmileBeam,
                          size: 25.0,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder(
              stream: chatBloc.recieveChatMessageVal,
              initialData: '',
              builder: (context,snapshot){
                String _chatMessage = snapshot.data;
                if(_chatMessage!= null && _chatMessage.trim()!= ''){

                  return IconButton(
                    onPressed:() {
                      _sendMessage(_chatMessage, 0);
                      _chatMessage='';
                    },
                    icon: Icon(
                      Icons.send,
                      size: 25.0,
                      color: Colors.lightBlue,
                    ),
                  );
                }
                else
                  return IconButton(
                    onPressed: (){
                      _sendMessage("like", 2);
                    },
                    icon: Icon(
                      FontAwesomeIcons.solidThumbsUp,
                      size: 25.0,
                      color: Colors.lightBlue,
                    ),
                  );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () =>
                    _sendMessage('mimi1', 2)
                ,
                child: new Image.asset(
                  'asset/images/sticker/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () =>_sendMessage('mimi2', 2)
                ,
                child: new Image.asset(
                  'asset/images/sticker/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _sendMessage('mimi3', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => _sendMessage('mimi4', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _sendMessage('mimi5', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () =>_sendMessage('mimi6', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => _sendMessage('mimi7', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () =>_sendMessage('mimi8', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => _sendMessage('mimi9', 2),
                child: new Image.asset(
                  'asset/images/sticker/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }
  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference reference = FirebaseStorage.instance.ref().child(authBloc.userCurrent.uid+'_'+fileName);

    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        _sendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print( 'This file is not an image');
    });
  }
  _createnewIdChat() async {
    DocumentReference  docRef= await nodeRoot.collection('chats').add({
      'idChat':"",
    });
    return docRef.documentID.toString();
  }
  _sendMessage(String content,int type) async {
    if(type == 0){
      myController.clear();
      chatBloc.feedMessageVal('');
    }

    if(widget.idChat==null){
      var docRef = await _createnewIdChat();
      nodeRoot.collection('chats').document(docRef).updateData({'idChat':docRef});

//    var newListIdChatFriend = new List();
//    nodeRoot.collection('users').document(widget.idFriend).updateData({'idChat':FieldValue.arrayRemove([widget.listIdChatFriend])});
//    newListIdChatFriend.add(docRef);
//    for(var item in widget.listIdChatFriend) {
//      newListIdChatFriend.add(item);
//    }
      nodeRoot.collection('users').document(widget.idFriend).updateData({'idChat':FieldValue.arrayUnion([docRef as String])});
      nodeRoot.collection('users').document(authBloc.userCurrent.uid).updateData({'idChat':FieldValue.arrayUnion([docRef as String])});


      nodeRoot.collection('chats/' +docRef + '/message').add({
        'check':true,
        'content':content,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'idFrom':authBloc.userCurrent.uid,
        'idTo':widget.idFriend.toString(),
        'type':type,

      });

      setState(() {
        widget.idChat=docRef;
      });

    }
    else{
      nodeRoot.collection('chats/' + widget.idChat + '/message').add({
        'check':true,
        'content':content,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'idFrom':authBloc.userCurrent.uid,
        'idTo':widget.idFriend.toString(),
        'type':type,
      });
    }











    await nodeRoot.collection('users').document(authBloc.userCurrent.uid)
        .updateData({'idChat':FieldValue.arrayRemove([widget.idChat])});
    var list = new List();
    list.add(widget.idChat);
    for(var itemIdchat in widget.listIdChat){
      if(itemIdchat.trim() != widget.idChat.trim()){
        list.add(itemIdchat);
      }
    }
    await nodeRoot.collection('users').document(authBloc.userCurrent.uid)
        .updateData({'idChat': list});



  }


}
