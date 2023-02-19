import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/TabScreens/SearchScreen.dart';
import 'TabScreens/Menu_screen.dart';
import 'TabScreens/MyCorner.dart';
import 'TabScreens/home_screen.dart';
import 'TabScreens/profile_screen.dart';
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
  //
  // void _onItemTapped(int index) {
  //   index == 4
  //       ? _drawerKey.currentState!.openDrawer()
  //       : setState(() {
  //     pageIndex = index;
  //   });
  // }

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
      height: height*0.1,
      color: const Color(0xffffffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            iconSize: 55,
            icon: pageIndex == 0
                ? const Icon(
              Icons.search,
              color: AppColors.activeColor,
              size: 35,
            )
                : const Icon(
              Icons.search,
              color: AppColors.inactive,
              size: 35,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            iconSize: 55,
            icon: pageIndex == 1
                ?  SizedBox(
                height: height*0.07,
                width:width*0.07 ,
                child: Image.asset("assets/quotes_data/my_corner.png",color:AppColors.activeColor ,))
                : SizedBox(
              height: height*0.07,
                width:width*0.07 ,
                child: Image.asset("assets/quotes_data/my_corner.png",color:AppColors.inactive,))
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            iconSize: 55,
            icon: pageIndex == 2
                ? const Icon(
              Icons.home,
              color: AppColors.activeColor,
              size: 35,
            )
                : const Icon(
              Icons.home,
              color: AppColors.inactive,
              size: 35,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
            },
            iconSize: 55,
            icon: pageIndex == 3
                ? const Icon(
              Icons.menu,
              color: AppColors.activeColor,
              size: 35,
            )
                : const Icon(
              Icons.menu,
              color: AppColors.inactive,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
