import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/TabScreens/SearchScreen.dart';
import 'TabScreens/Menu_screen.dart';
import 'TabScreens/MyCorner.dart';
import 'TabScreens/home_screen.dart';
import 'Utils/Colors.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int pageIndex = 2;

  final Screen = [
    SearchScreen(),
    MyCorner(),
    HomeScreen(),
    MenuScreen(),
  ];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: AppColors.primaryColor,
      body:  Screen[pageIndex],
      // drawer: DrawerCode(),
      bottomNavigationBar: buildMyNavBar(context),


    );
  }

  Container buildMyNavBar(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.08,
      color: const Color(0xffffffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                pageIndex = 0;
              });
            },
            child: Container(
              height: height*0.031,
              width:width*0.07 ,
              child: pageIndex == 0
                  ?  Image.asset("assets/quotes_data/icon_search_ziplink.png",color:AppColors.activeColor ,fit: BoxFit.contain,)
                  : Image.asset("assets/quotes_data/icon_search_ziplink.png",color:AppColors.inactive,fit: BoxFit.contain,),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                pageIndex = 1;
              });
            },
            child: Container(
              height: height*0.03,
              width:width*0.07 ,
              child: pageIndex == 1
                  ?  Image.asset("assets/quotes_data/feather_new3x.png",color:AppColors.activeColor ,fit: BoxFit.contain,)
                  : Image.asset("assets/quotes_data/feather_new3x.png",color:AppColors.inactive,fit: BoxFit.contain,),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                pageIndex = 2;
              });
            },
            child: Container(
              height: height*0.03,
              width:width*0.07 ,
              child: pageIndex == 2
                  ?  Image.asset("assets/quotes_data/icon_home_ziplin.png",color:AppColors.activeColor ,fit: BoxFit.contain,)
                  : Image.asset("assets/quotes_data/icon_home_ziplin.png",color:AppColors.inactive,fit: BoxFit.contain,),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                pageIndex = 3;
              });
            },
            child: Container(
              height: height*0.03,
              width:width*0.07 ,
              child:  pageIndex == 3
                  ?  Image.asset("assets/quotes_data/icon_menu_ziplin.png",color:AppColors.activeColor ,fit: BoxFit.contain,)
                  : Image.asset("assets/quotes_data/icon_menu_ziplin.png",color:AppColors.inactive,fit: BoxFit.contain,),
            ),
          ),
        ],
      ),
    );
  }
}
