
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/chat_bloc.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:flutter_app/src/widget/people_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'messeng_app_bar.dart';

class ListStory extends StatefulWidget {
  final UserModel userModel;

  const ListStory({Key key, this.userModel}) : super(key: key);
  @override
  _ListStoryState createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
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
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            MessengerAppBar(
              isScroll: _isScroll,
              title: 'People',
              img:  widget.userModel.imageAvatarUrl,
              actions: <Widget>[
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidAddressBook,
                    size: 18.0,
                  ),
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(
                    FontAwesomeIcons.userPlus,
                    size: 18.0,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: new  GridView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  controller: _controller,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.5),
                  ),
                  itemCount: chatBloc.listStories!=null?chatBloc.listStories.length+1:0,
                  itemBuilder: ( context,  index) {
                    if(index == 0){
                      return CardUser(
                          avatar: widget.userModel.imageAvatarUrl
                      );
                    }
                    else
                    return PeopleCard(
                        listStories:   chatBloc.listStories[index-1], indexItem: index);
                  },
                )

              ),
            )
          ],
        ),
      ),
    );
  }
}