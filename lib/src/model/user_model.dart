class UserModel {
  String id;
  String imageAvatarUrl;
  String name;
  List<String> idChat;
  bool isActive;
  String token;

  UserModel({this.id, this.imageAvatarUrl, this.name,this.idChat,this.isActive,this.token});
  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'imageAvatarUrl': imageAvatarUrl,
        'name':name,
        'idChat':idChat,
        'isActive':isActive,
        'token' : token
      };
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