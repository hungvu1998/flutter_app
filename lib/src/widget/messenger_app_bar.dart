import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MessengerAppBarAction extends StatefulWidget {
  List<Widget> actions = List<Widget>(0);
  String title;
  bool isScroll;
  bool isBack;
  bool isActive;
  String imageUrl;

  MessengerAppBarAction({
    this.actions,
    this.title = '',
    this.isScroll,
    this.isBack,

    this.imageUrl,
    this.isActive,
  });

  @override
  _MessengerAppBarActionState createState() => _MessengerAppBarActionState();
}

class _MessengerAppBarActionState extends State<MessengerAppBarAction> {
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
              Container(
                width: 16.0,
              ),
              Stack(
                children: <Widget>[

                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: NetworkImage( widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isActive,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color:Colors.green
                          ),
                        ),
                      ),

                    ),
                  ) ,
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    widget.isActive ? 'Đang hoạt động' : "Active 10 hours ago",
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  )
                ],
              )
            ],
          ),
          Container(
            child: Row(
              children: widget.actions
                  .map((c) => Container(
                padding: EdgeInsets.only(left: 20.0),
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