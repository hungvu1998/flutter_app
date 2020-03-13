import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/src/utlis/app_theme.dart';
import 'package:flutter_app/src/widget/detail_chat.dart';
import 'package:flutter_app/src/widget/home_screen.dart';
import 'package:flutter_app/src/widget/profile.dart';
import 'package:flutter_app/src/widget/splash_screen.dart';

var routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => SplashScreen(),

  "/Home": (BuildContext context) => HomeScreen(),
  "/chatDetail": (BuildContext context) => ChatDetail(),
  "/profile": (BuildContext context) => Profile(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      Platform.isAndroid ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: AppTheme.textTheme,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}

