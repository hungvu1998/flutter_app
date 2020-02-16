class StoryItem {
  String idFriend;
  String imgUrl;

  List<String> listSeen;


  StoryItem({this.idFriend, this.imgUrl,this.listSeen,});

//  UserModel.fromMap(Map snapshot,String id) :
//        id = id ?? '',
//        imageAvatarUrl = snapshot['imageAvatarUrl'] ?? '',
//        name = snapshot['name'] ?? '',
//        isActive = snapshot['isActive'] ?? '',
//        listFriendID = snapshot['listFriendID'] ?? '';
//
//  toJson() {
//    return {
//      "id" :id,
//      "imageAvatarUrl": imageAvatarUrl,
//      "name": name,
//      "listFriendID": listFriendID,
//      "isActive": isActive,
//    };
//  }
}