

import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

final BlueToothBloc blueToothBloc = new BlueToothBloc();
class BlueToothBloc {

  FlutterBlue bluetooth = FlutterBlue.instance;
  List<BluetoothDevice> deviceList = [];
  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];
    try{
     await bluetooth.startScan(timeout: Duration(seconds: 4));
       bluetooth.scanResults.listen((scanResult){
        //print(scanResult.length);
        scanResult.forEach((f){
          //print(f.device.name);
          devices.add(f.device);
        });
      });
    }on PlatformException{
      print('Error');
    }

    deviceList = devices;
   // await flutterBlue.state.listen(stat)
  }

}