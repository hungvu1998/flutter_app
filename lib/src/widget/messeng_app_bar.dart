
import 'package:flutter/material.dart';
import 'package:flutter_app/src/widget/profile.dart';

import 'app_bar_network_rounded_image.dart';
import 'appbar_title.dart';


class MessengerAppBar extends StatefulWidget {
  List<Widget> actions = List<Widget>(0);
  String title;
  String img;
  bool isScroll;
  bool isBack;

  MessengerAppBar({this.actions, this.title = '', this.isScroll, this.isBack,this.img});

  @override
  _MessengerAppBarState createState() => _MessengerAppBarState();
}

class _MessengerAppBarState extends State<MessengerAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.0,
      padding: EdgeInsets.only(right: 12.0, top: 25.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: widget.isScroll ? Colors.black12 : Colors.white,
          offset: Offset(0.0, 1.0),
          blurRadius: 10.0,
        ),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 16.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return Profile(
                      imgUrl:widget.img,
                    );
                  }));
                },
                child: AppBarNetworkRoundedImage(
                  imageUrl: widget.img,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              AppBarTitle(
                text: widget.title,
              ),
            ],
          ),
          Container(
            child: Row(
              children: widget.actions
                  .map((c) => Container(
                padding: EdgeInsets.only(left: 16.0),
                child: c,
              ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}