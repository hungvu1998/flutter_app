import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/chat_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _isScroll = true;
  final _textSearchController = TextEditingController();
  final Firestore nodeRoot = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
        child:Column(
          children: <Widget>[
            _buildAppBarSearch(),
            StreamBuilder(
                stream: chatBloc.recieveCountFindUser,
                builder: (context,countUserFindSnapshot){
                  if(!countUserFindSnapshot.hasData){
                    return Container();
                  }else{
                    if(countUserFindSnapshot.data<=0){
                      return Center(
                        child: Text("Không tìm thấy"),
                      );
                    }
                    else{
                      return Text(
                        'ffffffff'
                      );

                    }
                  }
                }
            ),
            Expanded(
              child: StreamBuilder(
                  stream: chatBloc.recieveSearchVal,
                  builder: (context,searchSnapshot){
                    if(searchSnapshot.hasData && searchSnapshot.data.toString().trim()!=''){
                      //print(searchSnapshot.data.toString().trim());
                      chatBloc.searchUser(searchSnapshot.data.toString().trim());
                      return StreamBuilder(
                        stream: chatBloc.userStream,
                        builder: (context,userSnapshot){
                          if(userSnapshot.hasData){
                            return Text(''+userSnapshot.data.id);
                          }else{
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 1,
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }
                    else{
                      return Container();
                    }
                  }
              ),
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
                controller: _textSearchController,
                onChanged: (val) => debounce(const Duration(milliseconds: 1000), _onChanged, [val]),
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
  void _onChanged(String val) {
    chatBloc.feedSearchVal(val);
    //chatBloc.searchUser(val);
  }


  Map<Function, Timer> _timeouts = {};
  void debounce(Duration timeout, Function target, [List arguments = const []]) {
    if (_timeouts.containsKey(target)) {
      _timeouts[target].cancel();
    }

    Timer timer = Timer(timeout, () {
      Function.apply(target, arguments);
    });

    _timeouts[target] = timer;
  }

  @override
  void dispose() {
    _textSearchController.clear();
    super.dispose();
  }
}
