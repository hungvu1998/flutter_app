import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

final chatBloc = ChatBloc();

class ChatBloc {
  var _searchValController = BehaviorSubject<String>();
  var _chatMessageValController = BehaviorSubject<String>();
  var _countFindUserController = BehaviorSubject<int>();



  Function(String) get feedSearchVal => _searchValController.sink.add;
  Function(String) get feedMessageVal => _chatMessageValController.sink.add;
  Function(int) get feedCounFindUser => _countFindUserController.sink.add;

  Stream<String> get recieveSearchVal => _searchValController.stream;
  Stream<String> get recieveChatMessageVal => _chatMessageValController.stream;
  Stream<int> get recieveCountFindUser => _countFindUserController.stream;

  var nodeRoot = Firestore.instance;


  var _userController = StreamController<UserModel>.broadcast();
  Stream get userStream => _userController.stream;


  Future<UserModel>  getUserInfo(String id) async {
    var userModel;
    await nodeRoot.collection('users').where("id", isEqualTo: id ).getDocuments().then((value){
      userModel= new UserModel(
          id: value.documents[0]['id'],
          name: value.documents[0]['name'],
         // listFriend: value.documents[0]['listFriend'].cast<String>(),
          idChat: value.documents[0]['idChat'].cast<String>(),
          isActive: value.documents[0]['isActive'],
          imageAvatarUrl:  value.documents[0]['imageAvatarUrl']);
      //_userController.add(userModel);
    });
    return userModel;
  }


  Future<UserModel> searchUser(String key) async{

    await nodeRoot.collection('users').where("name", isLessThanOrEqualTo: key ).limit(20).orderBy('name',descending: true).getDocuments().then((value){
      if(value.documents.length<=0){
        feedCounFindUser(value.documents.length);
      }
      else{
        for(var item in value.documents){
          var userModel= new UserModel(
              id: item['id'],
              name: item['name'],
              // listFriend: value.documents[0]['listFriend'].cast<String>(),
              idChat: item['idChat'].cast<String>(),
              isActive: item['isActive'],
              imageAvatarUrl:  item['imageAvatarUrl']);
          _userController.add(userModel);
        }
      }

    });

  }






//  List<List<StoryItem>> listStories ;
//  List<UserModel> friendList = new List();
//  var _storiesController = StreamController<String>.broadcast();
//  Stream get storiesStream => _storiesController.stream;
//  getStories(String id) async {
//    var userModel = await getUserInfo(id);
//    listStories=[];
//    var dem =0;
//    for(var i=0;i< userModel.listFriend.length;i++){
//      List<StoryItem> list=new List();
//
//      nodeRoot.collection('users').where("id", isEqualTo:userModel.listFriend[i]).getDocuments().then((value){
//        var userModel= new UserModel(
//            id: value.documents[0]['id'],
//            name: value.documents[0]['name'],
//            isActive: value.documents[0]['isActive'],
//            idChat: value.documents[0]['idChat'].cast<String>(),
//            imageAvatarUrl:  value.documents[0]['imageAvatarUrl']);
//
//        friendList.add(userModel);
//      });
//
//      nodeRoot.collection('users/' + userModel.listFriend[i] + '/stories').orderBy("timestamp",descending: true).getDocuments().then((value){
//        dem++;
//        if(value.documents.length>0){
//          for(var itemStories in value.documents){
//            var itemStory = StoryItem(
//                idFriend:  userModel.listFriend[i],
//                listSeen: itemStories["listSeen"].cast<String>(),
//                imgUrl: itemStories["imgUrl"]
//            );
//            list.add(itemStory);
//          }
//          listStories.add(list);
//        }
//        if(dem== userModel.listFriend.length){
//          _storiesController.add("done");
//        }
//      });
//    }
//
//
//    //var userModel = await getUserInfo();
//
//  }
  dispose() {
    //_storiesController?.close();
    _chatMessageValController?.close();
    _searchValController?.close();
    _countFindUserController?.close();
    _userController?.close();
  }
}