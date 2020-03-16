
import 'package:flutter/material.dart';
import 'package:flutter_app/src/model/story_model.dart';


class PageDetailStories extends StatefulWidget {
  final List<StoryItem> listStories;

  const PageDetailStories({Key key, this.listStories}) : super(key: key);
  @override
  _PageDetailStoriesState createState() => _PageDetailStoriesState();
}

class _PageDetailStoriesState extends State<PageDetailStories> with SingleTickerProviderStateMixin {
  var _pageController = PageController(initialPage: 0, keepPage: false);
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: 25.0,),
      child: PageView.builder(
          controller: _pageController,
          itemCount: widget.listStories.length,
          itemBuilder: (context,index){

            if(index == widget.listStories.length-1){
              new Future.delayed(
                  const Duration(seconds: 3),
                      () => Navigator.pop(context));
            }
            else{
              new Future.delayed(
                  const Duration(seconds: 3),
                      () => _pageController.jumpToPage(index+1));
            }
            return Container(
              color: Colors.white30,
              constraints: BoxConstraints.expand(),
              child: Column(
                children: <Widget>[

                  Image.network(widget.listStories[index].imgUrl,fit: BoxFit.contain,),
                ],
              ),
            );
          }
      ),
    );
  }
}