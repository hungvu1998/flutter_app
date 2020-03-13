import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/widget/video_call_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../bloc/auth_bloc.dart';
import 'detail_chat.dart';

class ConversationItem extends StatefulWidget {
  final DocumentSnapshot datas;
  final String idChat;
  final List<String> listIdChat;
  const ConversationItem({Key key, this.datas,this.idChat,this.listIdChat}) : super(key: key);
  @override
  _ConversationItemState createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  String idFriend ;
  final Firestore nodeRoot = Firestore.instance;
  String _urlImg;
  String _friendName;
  bool _isActive;
  var _timestamp;

  @override
  void initState() {
    _getIDfriend();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     return InkWell(
       onTap: (){
         if(_urlImg!=null&& _friendName!=null && _isActive!=null){
           Navigator.push(context, MaterialPageRoute(
               builder: (context) => ChatDetail(
                 urlImg: _urlImg,
                 friendName: _friendName,
                 isActive: _isActive,
                 idChat: widget.idChat,
                 idFriend: idFriend,
                 listIdChat: widget.listIdChat,
               )
           ));
         }
       },
       child:  Padding(
         padding: const EdgeInsets.symmetric(vertical: 12.0),
         child: Slidable(
           actionPane: SlidableDrawerActionPane(),
           actionExtentRatio: 0.15,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: _buildItemChat(),

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
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(
                       builder: (context) => VideoCallPage(
                         idFriend: idFriend,
                         urlImageFriend: _urlImg,
                         fiendName: _friendName,
                       )
                   ));
                 },
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
       ),
     );
  }

  _buildItemChat(){

    if(idFriend!=null)
      return StreamBuilder(
        stream:nodeRoot
            .collection('users')
            .where("id", isEqualTo: idFriend )
            .snapshots() ,
        builder: (context,snapshotFriend){
          if(!snapshotFriend.hasData){
            if(_friendName!=null )
               return Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          image: DecorationImage(
                              image: NetworkImage(_urlImg),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Visibility(
                      visible: _isActive,
                      child: Container(
                        height: 60,
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
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
                      ),
                    ) ,
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _friendName,
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Flexible(
                                    child: _buildLatestMessage(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(readTimestamp(widget.datas['timestamp']),
                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible:!widget.datas["check"],
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color:Colors.blueAccent
                                  ),
                                ),
                              ),
                            )

                          ],
                        )


                      ],
                    ),
                  ),
                )
              ],
            );
            else
              return Container();
          }
          else{
            _friendName=snapshotFriend.data.documents[0]['name'].toString();
            _isActive=snapshotFriend.data.documents[0]['isActive'];
            _urlImg=snapshotFriend.data.documents[0]['imageAvatarUrl'];
            _friendName=snapshotFriend.data.documents[0]['name'];
            return Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: DecorationImage(
                          image: NetworkImage(snapshotFriend.data.documents[0]['imageAvatarUrl']),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    Visibility(
                      visible: snapshotFriend.data.documents[0]['isActive'],
                      child: Container(
                        height: 60,
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
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
                      ),
                    ) ,
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshotFriend.data.documents[0]['name'],
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Flexible(
                                    child: _buildLatestMessage(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(readTimestamp(widget.datas['timestamp']),
                                        style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible:!widget.datas["check"],
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color:Colors.blueAccent
                                  ),
                                ),
                              ),
                            )

                          ],
                        )


                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      );
    else
      return Container();
  }


  _buildConversationImage(){

  }


  _buildLatestMessage(){
    bool _isThatYou= widget.datas["idFrom"]==authBloc.userCurrent.uid;
    return  widget.datas['type']==0 ? Text(
        _isThatYou ? "Bạn: "+widget.datas["content"]: widget.datas["content"],
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: widget.datas["check"] ? Colors.grey.shade700 : Colors.black, fontSize: 16,fontWeight:  widget.datas["check"] ?  null :  FontWeight.bold,),
    ) : Text(
      'f'
    );
  }
  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  Future<String> _getIDfriend() async {
    if(widget.datas['idFrom'].toString().trim() == authBloc.userCurrent.uid){
      idFriend= widget.datas["idTo"].toString();
    }
    else{
      idFriend= widget.datas["idFrom"].toString();
    }
  }
}
