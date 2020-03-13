import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:flutter_app/src/widget/chat_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {

  @override

  _HomeScreenState createState() => _HomeScreenState();
}
var nodeRoot = Firestore.instance;
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: nodeRoot.collection('users').where(
            "id", isEqualTo: authBloc.userCurrent.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          else {
            var userModel =  new UserModel(
                id: snapshot.data.documents[0]['id'],
                name: snapshot.data.documents[0]['name'],
               // listFriend: snapshot.data.documents[0]['listFriend'].cast<String>(),
                idChat: snapshot.data.documents[0]['idChat'].cast<String>(),
                isActive: snapshot.data.documents[0]['isActive'],
                imageAvatarUrl:  snapshot.data.documents[0]['imageAvatarUrl']);
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                body: Container(
                  child: TabBarView(
                    children: <Widget>[
                      ChatPage(

                        userModel: userModel,
                      ),
                      ChatPage(
                        userModel: userModel,
                      ),
                      ChatPage(
                        userModel: userModel,
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Material(
                  child: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).accentColor,
                    indicatorColor: Colors.yellowAccent.withOpacity(0.0),
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(FontAwesomeIcons.solidComment,size: 24,),
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.userFriends,size: 24,),
                      ),
                      Tab(
                        icon: Icon(FontAwesomeIcons.solidCompass,size: 24,),
                      ),
                    ],
                  ),
                ),
              ),

            );
          }
        }
    );
  }

}
