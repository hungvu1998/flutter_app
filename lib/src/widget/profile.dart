import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
        child: Row(
          children: <Widget>[
            Image(image: AssetImage('ic_mess.png')),
            Row(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                    border: InputBorder.none,
                  ),
                )

              ],
            )
          ],
        )
      )
    );
  }
}
