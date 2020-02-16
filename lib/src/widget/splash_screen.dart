import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/widget/home_screen.dart';
import 'package:flutter_app/src/widget/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(
      seconds: 3),
        (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomeScreen()),ModalRoute.withName("/Home"));
        },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        constraints: BoxConstraints.expand(),
    child: Image(image: AssetImage('ic_mess.png'))
    )
    );
  }
}

