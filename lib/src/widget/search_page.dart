import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:flutter_app/src/widget/detail_chat.dart';
import 'package:flutter_app/src/widget/profile_clipper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';

class SearchPage extends StatefulWidget {
  final UserModel userCurrent;

  const SearchPage({Key key, this.userCurrent}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _isScroll = true;
  String _textSearch="";
  final _textSearchController = TextEditingController();
  final Firestore nodeRoot = Firestore.instance;


  List<UserModel> _items = new List();
  final subject = new PublishSubject<String>();

  bool _isLoading = false;


  @override
  void initState() {
    subject.stream
        .debounce(new Duration(milliseconds: 600))
        .listen(_textChanged);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
        child:Column(
          children: <Widget>[
            _buildAppBarSearch(),
//            StreamBuilder(
//                stream: chatBloc.recieveCountFindUser,
//                builder: (context,countUserFindSnapshot){
//                  if(!countUserFindSnapshot.hasData){
//                    return Container();
//                  }else{
//                    if(countUserFindSnapshot.data<=0){
//                      return Center(
//                        child: Text("Không tìm thấy"),
//                      );
//                    }
//                    else{
//                      return Text(
//                        'ffffffff'
//                      );
//
//                    }
//                  }
//                }
//            ),
            new Expanded(
              child: _isLoading
              ? Container(
                child: Center(child: CircularProgressIndicator()),
                padding: EdgeInsets.all(16.0),
              )
              : new ListView.builder(
                padding: new EdgeInsets.all(9.0),
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildItemFriendSearch(_items[index]);
                },
              ),
//              child: StreamBuilder(
//                  stream: chatBloc.recieveSearchVal,
//                  builder: (context,searchSnapshot){
//                    if(searchSnapshot.hasData && searchSnapshot.data.toString().trim()!=''){
//                      //print(searchSnapshot.data.toString().trim());
//                      chatBloc.searchUser(searchSnapshot.data.toString().trim());
//                      return StreamBuilder(
//                        stream: chatBloc.userStream,
//                        builder: (context,userSnapshot){
//                          if(userSnapshot.hasData){
//                            return Text(''+userSnapshot.data.id);
//                          }else{
//                            return Container(
//                              width: MediaQuery.of(context).size.width,
//                              height: 1,
//                              child: CircularProgressIndicator(),
//                            );
//                          }
//                        },
//                      );
//                    }
//                    else{
//                      return Container();
//                    }
//                  }
//              ),
            )

          ],
        )
      )
    );
  }


  _buildAppBarSearch(){
    return Container(
      height: 90.0,
      padding: EdgeInsets.only(right: 12.0, top: 25.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: _isScroll ? Colors.black12 : Colors.white,
          offset: Offset(0.0, 1.0),
          blurRadius: 10.0,
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 45,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top:5),
              child: TextField(



                autofocus: true,

//                controller: _textSearchController,
                onChanged: (string) => (subject.add(string)),
                //onChanged: (val) => debounce(const Duration(milliseconds: 1000), _onChanged, [val]),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search'
                ),

              ),
            ),
          )
        ],
      ),
    );

  }




  Future<void> _textChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _clearList();
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _clearList();

    await nodeRoot.collection('users').where("name", isGreaterThanOrEqualTo: text ).limit(20).orderBy('name',descending: true).getDocuments().then((value){
      value.documents.forEach(_addItem);

    }).catchError(_onError)
        .then((e){
      setState(() {
        _isLoading=false;
      });

    });
  }

  void _onError(dynamic d) {
    setState(() {
      _isLoading = false;
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }

  void _addItem(item) {
    setState(() {
      var userModel= new UserModel(
          id: item['id'],
          name: item['name'],
           listFriend: item['listFriend'].cast<String>(),
          idChat: item['idChat'].cast<String>(),
          isActive: item['isActive'],
          imageAvatarUrl:  item['imageAvatarUrl']);
      if(userModel.id.trim().toString()!=authBloc.userCurrent.uid.trim().toString())
      _items.add(userModel);
    });
  }


  _buildItemFriendSearch(UserModel userModel){
    return InkWell(
      onTap: (){
        checkChatOrNot(userModel.idChat).then((value){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetail(
                  urlImg: userModel.imageAvatarUrl,
                  friendName: userModel.name,
                  isActive: userModel.isActive,
                  idChat: value,
                  idFriend: userModel.id,
                  listIdChat: widget.userCurrent.idChat,
                )
              ),
            );
        });
      },

      child: Padding(
        padding:  EdgeInsets.only(bottom: 20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(
                  clipper: ProfileClipper(),
                  child: Image.network(
                    userModel.imageAvatarUrl,
                    width:45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    userModel.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ),

              ],

            ),
          ],
        ),
      ),
    );
  }
  Future<String> checkChatOrNot(List<String>datas) async{
     for(var itemIdChatFriend in datas){
      for(var itemIdChatUserCurrent in widget.userCurrent.idChat){
        if (itemIdChatUserCurrent.trim() == itemIdChatFriend.trim()){
          return itemIdChatFriend;
        }
      }
    }
     return '';
  }

  @override
  void dispose() {
    print('dis');
    //_textSearchController.clear();
    subject?.close();
    super.dispose();
  }
}
