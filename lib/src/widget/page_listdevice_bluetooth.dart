
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'messenger_app_bar.dart';

class ChatViaBlueTooth extends StatefulWidget {
  @override
  _ChatViaBlueToothState createState() => _ChatViaBlueToothState();
}

class _ChatViaBlueToothState extends State<ChatViaBlueTooth> {
  final _isScroll = true;
  bool _toggleValue;
  int count=0;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  @override
  void initState() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    var subscription = flutterBlue.scanResults.listen((scanResult) {
     print(scanResult.length);
    });
    flutterBlue.stopScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
              builder: (c, snapshot){
                final state = snapshot.data;
                if (state == BluetoothState.on) {
                    _toggleValue =true;
                }
                else{
                    _toggleValue=false;
                }
                return Container(
                  child: Column(
                    children: <Widget>[
                      _buildAppBar(),
                      Container(
                        padding: EdgeInsets.all( 20),
                        child:  Text(_toggleValue ? 'Đảm bảo thiết bị mà bạn muốn kết nối đang ở chố độ ghép đôi' : 'Bật Bluetooth kết nốt với thiết bị ở gần để thực hiện chat ' ,
                          style: TextStyle(
                              color: Colors.black
                          ),
                        ),
                      ),
                      _buildListDeviceBlue()
                    ],
                  ),
                );

              }
          ),

        ),
      ),
    );
  }


  _buildAppBar(){
    return Container(
      height: 100.0,
      padding: EdgeInsets.only(right: 12.0, top: 0.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: _isScroll ? Colors.black12 : Colors.white,
          offset: Offset(0.0, 1.0),
          blurRadius: 10.0,
        ),
      ]),
      child: Row(
        children: <Widget>[
          Container(
            width: 45,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(context);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            width: 16.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              child: Text(
                'BlueTooth',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IgnorePointer(
            ignoring: false,
            child: Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: _toggleValue ? Colors.blueAccent[100] : Colors.redAccent[100].withOpacity(0.5)
                ),
                child: InkWell(
                  onTap: (){
                      setState(() {_toggleValue = !_toggleValue;});

                  },
                  child: Stack(
                    children: <Widget>[
                        AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        top:3,
                        left: _toggleValue ? 60 : 0,
                        right: _toggleValue ? 0 : 60,
                        child: InkWell(
                          onTap: (){

                          },
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder: (Widget widget,Animation<double> animation){
                              return RotationTransition(
                                child: widget,
                                turns: animation,
                              );
                            },
                            child: _toggleValue ?
                            Icon(
                              Icons.check_circle,color : Colors.white,size:35,key: UniqueKey(),
                            )
                                : Icon(
                              Icons.remove_circle_outline,color : Colors.red,size:35,key: UniqueKey(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  _buildListDeviceBlue(){
    return Container(

    );
  }
}

