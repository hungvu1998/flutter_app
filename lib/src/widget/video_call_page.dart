import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';



class VideoCallPage extends StatefulWidget {
  final String idFriend;
  final String urlImageFriend;
  final String fiendName;

  const VideoCallPage({Key key, this.idFriend, this.urlImageFriend, this.fiendName}) : super(key: key);


  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> with WidgetsBindingObserver {
  CameraController controller;
  int _positionCamera=2;
  Future<void> _initializeControllerFuture;
  File _image;

  Future <void> getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image=image;
      print(_image);
    });
  }
  @override
  void initState() {
    super.initState();
    controller =
    new CameraController(cameras[_positionCamera], ResolutionPreset.medium);
    _initializeControllerFuture =
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (!controller.value.isInitialized) {
      return new Container();
    }
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Transform.scale(
              scale: controller.value.aspectRatio / deviceRatio,
              child: new AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: new CameraPreview(controller),
              ),
            ),
          ),
          Container(
            child:Column(
              children: <Widget>[
                _buildAppBarVideoCall(),
                Expanded(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Container(
                            width: 100,
                            height: 100,
                              margin: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                image: DecorationImage(
                                  image: NetworkImage(widget.urlImageFriend),
                                  fit: BoxFit.cover,
                                ),
                              )
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top:10),
                          child: Text(widget.fiendName,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        )
                      ],
                      
                    ),

                  ),
                ),
                _buildBottomVideoCall()
              ],
            ),
          ),
        ],
      ),
    );
  }
  _buildAppBarVideoCall(){
    return Padding(
      padding: EdgeInsets.only(
        top:40, left:16,right: 16,
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {

            },
            child:Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey.withAlpha(160),
                ),
                child: Icon(
                  Icons.message,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Container(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: (){
                  setState(() {
                    if(_positionCamera==0){
                      print(_positionCamera);
                      _positionCamera=2;
                      controller =
                      new CameraController(cameras[_positionCamera], ResolutionPreset.medium);
                      controller.initialize().then((_) {
                        if (!mounted) {
                          return;
                        }

                        setState(() {});
                      });
                    }
                    else{
                      print(_positionCamera);
                      _positionCamera=0;
                      controller =
                      new CameraController(cameras[_positionCamera], ResolutionPreset.medium);
                      controller.initialize().then((_) {
                        if (!mounted) {
                          return;
                        }

                        setState(() {});
                      });
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.shade400.withAlpha(200),
                    ),
                    child: Icon(
                      Icons.switch_camera,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade400.withAlpha(200),
                  ),
                  child: Icon(
                    FontAwesomeIcons.video,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildBottomVideoCall(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            InkWell(
              onTap: () async{
                try {
                 getImage();
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print("erroo");
                  print(e);
                }

              },
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidCircle,
                    size: 40.0,
                    color: Colors.grey.shade400.withAlpha(200),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30,left: 30),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey.shade400.withAlpha(200),
                ),
                child: Icon(
                  FontAwesomeIcons.microphone,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.red,
                ),
                child: Icon(
                  FontAwesomeIcons.phoneSlash,
                  size: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
