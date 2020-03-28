import 'dart:async';

import 'package:connectivity/connectivity.dart';
final NetWorkBloc netWorkBloc = NetWorkBloc();
class NetWorkBloc {
  var connectivityStatus = 'Unknown';
//This is verify the Internet Access.
  Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubs;
  bool netWorkStatus =false;

  Future<void> checkNetWork() async{
      connectivitySubs =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          connectivityStatus = result.toString();
          if (result == ConnectivityResult.none) {
            netWorkStatus = false;
          }
          else{
            netWorkStatus=true;
          }
        });
  }
  dispose(){
    connectivitySubs?.cancel();
  }
}