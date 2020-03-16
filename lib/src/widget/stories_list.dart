import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/bloc/chat_bloc.dart';
import 'package:flutter_app/src/model/story_model.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:flutter_app/src/widget/page_detail_stories.dart';

import 'detail_chat.dart';

class StoriesList extends StatefulWidget {
  final UserModel user;

  const StoriesList({Key key, this.user}) : super(key: key);
  @override
  _StoriesListState createState() => _StoriesListState();
}

class _StoriesListState extends State<StoriesList> {
  List<StoryItem> list;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chatBloc.storiesStream,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: widget.user.listFriend.length+1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              if(index == 0 ){
                return AddToYourStoryButton( user: widget.user);
              }
              else{
                //return Text('fffffff');
                return StreamBuilder(
                  stream: nodeRoot
                      .collection('users/' + widget.user.listFriend[index-1].toString()+ '/stories')
                      .snapshots(),
                  builder: (context,snapshotStories){
                    if(!snapshotStories.hasData || snapshotStories.data.documents.length <=0){
                      return StreamBuilder(
                          stream: nodeRoot.collection('users').where(
                              "id", isEqualTo: widget.user.listFriend[index-1]).snapshots(),
                          builder: (context,snapshotFriend){
                            if(snapshotFriend.hasData){
                              var userModel =  new UserModel(
                                  id: snapshotFriend.data.documents[0]['id'],
                                  name: snapshotFriend.data.documents[0]['name'],
                                  listFriend: snapshotFriend.data.documents[0]['listFriend'].cast<String>(),
                                  idChat: snapshotFriend.data.documents[0]['idChat'].cast<String>(),
                                  isActive: snapshotFriend.data.documents[0]['isActive'],
                                  imageAvatarUrl:  snapshotFriend.data.documents[0]['imageAvatarUrl']);
                              return FriendItem(
                                userFriend: userModel,
                                userCurrent: widget.user,
                              );
                            }
                            else
                              return Container();
                          }
                      );
                    }else{
                      getStoryUser(snapshotStories.data.documents).then((list){
                        setState(() {
                          this.list=list;
                        });
                      });

                      if(list==null){
                        return Container();
                      }else{
                        return StoryListItem(
                            listStories: this.list
                        );
                      }
                    }
                  });
              }
            }
        );
      }
    );
  }
  Future<List<StoryItem>> getStoryUser(List<DocumentSnapshot> datas) async{
    list = new List();
    for(var i=0;i< datas.length;i++){
      var item = new StoryItem(
          listSeen: datas[i]['listSeen'].cast<String>(),
          imgUrl: datas[i]['imgUrl']
      );
      list.add(item);
    }
    return list;
  }
}
final Firestore nodeRoot = Firestore.instance;


class AddToYourStoryButton extends StatefulWidget {
  final UserModel user;

  const AddToYourStoryButton({Key key, this.user}) : super(key: key);
  @override
  _AddToYourStoryButtonState createState() => _AddToYourStoryButtonState();
}

class _AddToYourStoryButtonState extends State<AddToYourStoryButton> {
  List<StoryItem> list;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: StreamBuilder(
          stream: nodeRoot
              .collection('users/' + widget.user.id + '/stories')
              .orderBy("timestamp",descending: true)
              .snapshots() ,
          builder: (context,snapshot){

            if (!snapshot.hasData)
              return Container();
            else if(snapshot.data.documents.length <= 0 ){
              return Row(
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                            // borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Icon(
                            Icons.add,
                            size: 35.0,
                          )),
                      SizedBox(height: 8.0),
                      Text('Your story', style: _viewedStoryListItemTextStyle()),
                    ],
                  ),
                  SizedBox(width: 12.0)
                ],
              );
            }
            else{
              getStoryUser(snapshot.data.documents).then((list){
                setState(() {
                  this.list=list;
                });
              });

              if(list==null){
                return Container();
              }else{
                return StoryListItem(
                    listStories: this.list
                );
              }




              //return StoryListItem(listStories: snapshot.data);
            }
          }
      ),
    );
  }
  Future<List<StoryItem>> getStoryUser(List<DocumentSnapshot> datas) async{
    list = new List();
    for(var i=0;i< datas.length;i++){
      var item = new StoryItem(
          listSeen: datas[i]['listSeen'].cast<String>(),
          imgUrl: datas[i]['imgUrl']
      );
      list.add(item);
    }
    return list;
  }
}



_viewedStoryListItemTextStyle() {
  return TextStyle(fontSize: 12, color: Colors.grey);
}


class StoryListItem extends StatefulWidget {
  final List<StoryItem> listStories;

  StoryListItem({this.listStories,});
  @override
  _StoryListItemState createState() => _StoryListItemState();
}

class _StoryListItemState extends State<StoryListItem> {

  @override
  Widget build(BuildContext context) {
    bool check=false;
    for(var item in widget.listStories){
      for(var item2 in item.listSeen){
        if(item2 == authBloc.userCurrent.uid){
          check=true;
          break;
        }
      }
    }
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                  child:  InkWell(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return PageDetailStories(
                          listStories:widget.listStories,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right:16.0),
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        margin: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: check ?  Border.all(color: Colors.grey.shade300, width: 3): Border.all(color: Colors.blue, width: 3) ,
                          image: DecorationImage(
                            image: NetworkImage(widget.listStories[0].imgUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )



              )
            ],
          )
        ],
      ),
    );

  }
}


class FriendItem extends StatelessWidget {
  final UserModel userFriend;
  final UserModel userCurrent;

  const FriendItem({Key key, this.userFriend,this.userCurrent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print('fffff');
      },
      child: Container(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      child:  InkWell(
                        onTap: (){
                          print('ggggg');
                          checkChatOrNot(userFriend.idChat).then((value){

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatDetail(
                                    urlImg: userFriend.imageAvatarUrl,
                                    friendName: userFriend.name,
                                    isActive: userFriend.isActive,
                                    idChat: value,
                                    idFriend: userFriend.id,
                                    listIdChat: userCurrent.idChat,
                                  )
                              ),
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right:16.0),
                          child:   Stack(
                            children: <Widget>[
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    image: DecorationImage(
                                        image: NetworkImage(userFriend.imageAvatarUrl),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Visibility(
                                visible: userFriend.isActive,
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
                        ),
                      )



                  )
                ],
              )
            ],
          ),

      ),
    );
  }
  Future<String> checkChatOrNot(List<String>datas) async{
    for(var itemIdChatFriend in datas){
      for(var itemIdChatUserCurrent in userCurrent.idChat){
        if (itemIdChatUserCurrent.trim() == itemIdChatFriend.trim()){
          return itemIdChatFriend;
        }
      }
    }
    return '';
  }

}

