import 'package:flutter/material.dart';
import 'package:clean_news_ai/src/ui/screens/popular_news.dart';
import 'package:clean_news_ai/src/ui/screens/liked_screen.dart';
import 'package:clean_news_ai/src/ui/screens/settings_screen.dart';
import 'dart:ui';

class ParentScreen extends StatefulWidget{

  createState() => ParentScreenState();

}

class ParentScreenState extends State<ParentScreen> with SingleTickerProviderStateMixin{

  TabController tabController;
  

  initState(){
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getTabBar(){
    final bool iphonex = MediaQuery.of(context).size.height >= 812.0;
    final double bottomPadding = iphonex ? 16.0 : 0.0;
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      color: Colors.black54,
      child: TabBar(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.green,
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.whatshot),
          ),
          Tab(
            icon: Icon(Icons.favorite_border),
          ),
          Tab(
            icon: Icon(Icons.settings),
          )
        ],
        controller: tabController,
        indicatorColor: Colors.transparent,
      ),
    );
  }

  getTabBarViews(tabs){
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  build(context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
          children: [
            getTabBarViews([
              FlutterNewsScreen(),
              LikedScreen(),
              SettingsScreen()
            ]),
            Container(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
                  child: getTabBar()),
              alignment: AlignmentDirectional.bottomEnd,
            )
          ]
      ),
    );
  }
}