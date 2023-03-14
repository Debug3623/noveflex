import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import '../Provider/UserProvider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              )),
          title: Text(Languages.of(context)!.faq,
              style: const TextStyle(
                  color: const Color(0xff2a2a2a),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Alexandria",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
          centerTitle: true,
        ),
        body: SafeArea(
          child:ExpandableTheme(
            data: const ExpandableThemeData(
              iconColor: Colors.blue,
              useInkWell: true,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: _height*0.1,
                ),
                Card1(),
                Card2(),
                Card3(),
                Card4(),
                Card5(),
                Card6(),
                Card7(),
                Card8(),
              ],
            ),
          ),


        ));
  }



}


class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.famousAuthor_,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.faqText_long,
                      softWrap: true,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Languages.of(context)!.joinUs,
                            style: const TextStyle(
                                color: const Color(0xff676767),
                                fontWeight: FontWeight.w700,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0),
                            textAlign: TextAlign.left),
                        SizedBox(height: _height*0.02,),
                        Text(
                            Languages.of(context)!.faqText_long,
                            style: const TextStyle(
                                color: const Color(0xff676767),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),
                        SizedBox(height: _height*0.04,),
                        context.read<UserProvider>().SelectedLanguage ==
                            "English" ? Container(
                          height: _height*0.3,
                          width: _width*0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage("assets/quotes_data/faq_image_english_1.jpeg"),
                                  fit: BoxFit.cover
                              )
                          ),
                        ) : Container(
                          height: _height*0.3,
                          width: _width*0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage("assets/quotes_data/faq_image_arabic.jpeg"),
                                  fit: BoxFit.cover
                              )
                          ),
                        ) ,
                        SizedBox(height: _height*0.04,),
                        Text(
                            Languages.of(context)!.faqText_long_1,
                            style: const TextStyle(
                                color: const Color(0xff676767),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            textAlign: TextAlign.left),
                        SizedBox(height: _height*0.04,),
                        GestureDetector(
                          onTap: (){
                            _launchUrl();
                          },
                          child: Center(
                            child: Container(
                              height: _height*0.05,
                              width: _width*0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black12

                              ),
                              child: Center(
                                child: Text(Languages.of(context)!.readerMore,
                                  style: const TextStyle(
                                      color:  const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 14.0
                                  ),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _launchUrl() async {
    var url = Uri.parse("https://novelflex.com/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}


class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                         Languages.of(context)!.profit_text,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.mangaka_text,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  Languages.of(context)!.mangaka_text,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}


class Card3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.fanSupport,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.fanSupport2,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                Languages.of(context)!.fanSupport2,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}


class Card4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.privateAds,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.privateAds2,
                      softWrap: true,
                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  Languages.of(context)!.privateAds2,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Card5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.readerWin,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.readerWin2,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  Languages.of(context)!.readerWin2,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Card6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.ourCondition,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.ourCondition2,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              Languages.of(context)!.ourCondition2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Card7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.submission,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.submission2,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              Languages.of(context)!.submission2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Card8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white
            ),
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,

                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                        iconColor: Colors.black45
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          Languages.of(context)!.copyRight,
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Alexandria",
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),
                        )),
                    collapsed: Text(
                      Languages.of(context)!.copyRight2,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              Languages.of(context)!.copyRight2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                            )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}


