import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/bloc/auth_bloc.dart';
import 'package:flutter_app/src/widget/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    authBloc.checkLogin().then((value){
      if(value){
        Navigator.of(context).pushReplacement( MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 150),
                child: Image(
                  image: AssetImage('ic_mess.png'),
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100, left: 50, right: 50),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Phone Number or Email',
                        hintStyle: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Colors.grey
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 50,
                        child: MaterialButton(

                          onPressed: () {
                            print('fffffff');
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),

                          color: Colors.blue,
                          child: Text(
                            'LOG IN',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 50,
                        child: RaisedButton(

                          onPressed: () {
                            print('fffffff');
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          color: Colors.green,
                          child: Text(
                            'CREATE NEW ACCOUNT',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () => _onLoginClick(2),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)),
                          color: Colors.red,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10),
                                child: Text(
                                  'LOG IN WITH GMAIL',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'You will not be  creating a Facebook profile',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: () {
                          print('ffffff');
                        },
                        child: Text(
                          'FORGOT PASSWORD',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18
                          ),
                        ),
                      ),
                    )


                  ],
                ),
              ),

            ],
          )
      ),
    );
  }


  _onLoginClick(int type) {

    switch (type) {
      case 1:
        {
          break;
        }
      case 2:
        {
          authBloc.signInWithGoogle(context).then((value) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },));
          });

          break;
        }
    }
  }
}

