import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/bloc/network_bloc.dart';
import 'package:flutter_app/src/widget/home_screen.dart';
import 'package:flutter_app/src/widget/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;
  startTime() async {
    //netWorkBloc.checkNetWork();
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
      //if(netWorkBloc.netWorkStatus){
        authBloc.checkLogin().then((value){
          if(value){
            Navigator.of(context).pushReplacement( MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        });
      //}else{
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      //}


  }



  @override
  void initState() {
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'ic_mess.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

