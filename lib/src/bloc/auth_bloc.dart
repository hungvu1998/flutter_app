import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';

final authBloc = AuthBloc();

class AuthBloc{
  final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser userCurrent;

  Future<FirebaseUser> signInWithGoogle(context) async {
    ProgressDialog pr= new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true);
    pr.style(
        message: 'Login...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    pr.show();
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    await userIsExit(user.uid);
    userCurrent=user;
    pr.dismiss();
    return user;

  }


  Future<void> userIsExit(String authID) async {
    await db
        .collection('users').document(authID).get().then((documentSnapshot) async {
      if (documentSnapshot.data == null) {
        print('chua co');
        UserModel userModel = new UserModel(
            id:authID,
            name: "Default",
            idChat: [],
            isActive: true,
            imageAvatarUrl: "https://scontent.fhan1-1.fna.fbcdn.net/v/t1.0-9/p960x960/84697154_2516174735316139_945259827255312384_o.jpg?_nc_cat=102&_nc_ohc=6MAbYPZo7E8AX8wLOXk&_nc_ht=scontent.fhan1-1.fna&_nc_tp=6&oh=5be3f9bdbee19c6707d777d0d89c440c&oe=5ECE144E"
        );
        await addDataUser(userModel.id,userModel.toJson());
      }
    });
  }

  Future<bool> checkLogin() async {
    final FirebaseUser user =await _auth.currentUser();
    if (user != null) {
      userCurrent = user;
      return true;
    }

    return false;
  }

  Future<bool> logout() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    userCurrent = null;
    return true;
  }

  Future<void> _loginWithFacebook() async {
    // TODO: handle login
  }

  Future<void> addDataUser(String authid, userModel) async {
    await db
    .collection('users').document(authid).setData(userModel).catchError((e){
      print("and data User error" + e );

    }).then((value){
      print("and data User succes");
   });
  }

  Future<void> updateDataUser(String authID, newValues) async {
    await db
        .collection('users')
        .document(authID)
        .updateData(newValues)
        .catchError((e) {
      print("Update data User error" + e );
    });
  }

  Future<void> deleteData(authID) async {
    await db
        .collection('users')
        .document(authID)
        .delete()
        .catchError((e) {
      print("Delete data User error" + e );
    });
  }

}