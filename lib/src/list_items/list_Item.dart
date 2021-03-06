import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:clean_news_ai/src/blocs/saved_news_bloc.dart';
import 'package:clean_news_ai/src/resources/repository.dart';
import 'package:transparent_image/transparent_image.dart';


class ListItem extends StatefulWidget {

  final name;
  final url;
  var liked;
  final title;
  final publishedAt;
  final urlToImage;

  ListItem(
      this.name,
      this.url,
      this.liked,
      this.title,
      this.publishedAt,
      this.urlToImage);

  createState() => ListItemState();

}

class ListItemState extends State<ListItem> with TickerProviderStateMixin {

  var colorAnimation;
  var colorAnimationController;


  initState(){
    colorAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    colorAnimation = Tween(begin: 1.0, end: 0.5).animate(colorAnimationController);
    super.initState();
  }

  dispose(){
    colorAnimationController.dispose();
    super.dispose();
  }

  build(context) {
      return AnimatedBuilder(
          animation: colorAnimation,
          builder: (context,_){
            colorAnimationController.forward();
            return Container(
                child: GestureDetector(
                    child: Card(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        elevation: 8.0,
                        color: Colors.transparent,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            child: Container(
                              child:
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                              widget.name,
                                              style: TextStyle(color: Colors.white, fontSize: 16)),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: (){
                                                  Share.share(widget.url);
                                                },
                                                icon: Icon(Icons.share, color: Colors.green),
                                                color: Colors.white,
                                              ),
                                              IconButton(
                                                onPressed: (){
                                                  updateSavedNews();
                                                  if(mainArticles.containsKey(widget.url)){
                                                    mainArticles[widget.url].liked ? mainArticles[widget.url].liked = false : mainArticles[widget.url].liked = true;
                                                  }
                                                  widget.liked ? bloc.deleteArticle(widget.url) : bloc.saveArticle(
                                                      {
                                                        "name" : widget.name,
                                                        "url" : widget.url,
                                                        "title" : widget.title,
                                                        "publishedAt" : widget.publishedAt,
                                                        "urlToImage" : widget.urlToImage,
                                                      });
                                                  setState(() {
                                                    widget.liked = !widget.liked;
                                                  });
                                                },
                                                icon: widget.liked ? Icon(Icons.favorite, color: Colors.green) : Icon(Icons.favorite_border, color: Colors.green),
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                                    child: Text(
                                        widget.title,
                                        style: TextStyle(color: Colors.white, fontSize: 20)),
                                    alignment: Alignment.center,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 16.0, bottom: 16.0, top: 8.0),
                                    child: Text(widget.publishedAt,
                                        style: TextStyle(color: Colors.white, fontSize: 16)),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              ),

                              decoration: widget.urlToImage != null ?  BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  image: DecorationImage(
                                    image: Image.network(widget.urlToImage).image,
                                    colorFilter: ColorFilter.mode(Colors.black54.withOpacity(colorAnimation.value), BlendMode.hardLight),
                                    fit: BoxFit.cover,
                                  )
                              ) : BoxDecoration(
                                  color: Colors.black.withOpacity(0.5)
                              ),
                            )
                        )
                    ),
                    onTap: () => launch(widget.url)
                )
            );
          });
  }
}


