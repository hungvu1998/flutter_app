import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/src/model/user_model.dart';

final chatBloc = ChatBloc();

class ChatBloc {
  var _userController = StreamController<UserModel>.broadcast();
  Stream get userStream => _userController.stream;
  var nodeRoot = Firestore.instance;








  Future<UserModel>  getUserInfo(String id) async {
    var userModel;
    await nodeRoot.collection('users').where("id", isEqualTo: id ).getDocuments().then((value){
      userModel= new UserModel(
          id: value.documents[0]['id'],
          name: value.documents[0]['name'],
          //listFriend: value.documents[0]['listFriend'].cast<String>(),
          idChat: value.documents[0]['idChat'].cast<String>(),
          isActive: value.documents[0]['isActive'],
          imageAvatarUrl:  value.documents[0]['imageAvatarUrl']);
      _userController.add(userModel);
    });
    return userModel;
  }
  dispose() {
    _userController?.close();
  }
}