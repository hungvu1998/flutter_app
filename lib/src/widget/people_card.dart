import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/model/story_model.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:flutter_app/src/widget/page_detail_stories.dart';

class PeopleCard extends StatefulWidget {
  final List<StoryItem> listStories;
  final int indexItem;
  PeopleCard({Key key, this.listStories, this.indexItem});

  _PeopleCardState createState() => _PeopleCardState();
}
final Firestore nodeRoot = Firestore.instance;
class _PeopleCardState extends State<PeopleCard> {
  @override
  void initState() {


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return PageDetailStories(
            listStories:widget.listStories,
          );
        }));
      },
      child: Container(
        height: 600.0,
        margin: EdgeInsets.only(
          right: 8.0,
          left: 8.0,
          bottom: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(widget.listStories[0].imgUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(.6),
                Colors.black.withOpacity(.3),
              ],
              stops: [0.1, 0.9],
              begin: Alignment.bottomCenter,
            ),
          ),
          child: StreamBuilder(
              stream: nodeRoot.collection('users').where("id", isEqualTo:widget.listStories[0].idFriend).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Container(

                  );
                }
                else{
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            width: 2.0,
                            color: snapshot.data.documents[0]["isActive"]
                                ? Colors.blue.shade700
                                : Colors.transparent,
                          ),
                        ),
                        child: Container(
                          width: 46.0,
                          height: 46.0,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(23.0),
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data.documents[0]["imageAvatarUrl"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text(
                       snapshot.data.documents[0]["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  );
                }
              }
          ),
        ),
      ),
    );
  }
}

class CardUser extends StatelessWidget {
  final String avatar;

  const CardUser({Key key, this.avatar}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){

      },
      child: Container(
        height: 600.0,
        margin: EdgeInsets.only(
          right: 8.0,
          left: 8.0,
          bottom: 16.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(avatar),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(.6),
                Colors.black.withOpacity(.3),
              ],
              stops: [0.1, 0.9],
              begin: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    width: 2.0,
                    color: Colors.transparent,
                  ),
                ),
                child: Container(
                  width: 46.0,
                  height: 46.0,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(23.0),
                  ),
                  child: Icon(
                    Icons.add
                  ),
                ),
              ),
              Text(
                'Thêm tin mới' ,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
