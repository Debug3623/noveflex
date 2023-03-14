import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mailto/mailto.dart';
import 'package:novelflex/MixScreens/AccountInfoScreen.dart';
import 'package:novelflex/Models/UserReferralModel.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../MixScreens/FaqScreen.dart';
import '../MixScreens/PieChartScreen.dart';
import '../MixScreens/ProfileScreens/HomeProfileScreen.dart';
import '../MixScreens/WalletDirectory/MyWalletScreen.dart';
import '../MixScreens/WalletDirectory/Unlock_wallet_screen_one.dart';
import '../MixScreens/disclimar_screen.dart';
import '../Models/MenuProfileModel.dart';
import '../Models/ReaderProfileModel.dart';
import '../Models/StatusCheckModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../ad_helper.dart';
import '../localization/Language/languages.dart';
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  StatusCheckModel? _statusCheckModel;
  UserReferralModel? _userReferralModel;
  MenuProfileModel? _menuProfileModel;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  bool isCheck = true;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    _checkInternetConnection();
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {

    _interstitialAd?.dispose();

    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Transitioner(
                context: context,
                child: HomeProfileScreen(),
                animation:
                AnimationType.slideLeft, // Optional value
                duration:
                Duration(milliseconds: 1000), // Optional value
                replacement: false, // Optional value
                curveType: CurveType.decelerate, // Optional value
              );
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf6f9),
      body: SafeArea(
        child: _isInternetConnected
            ? _isLoading
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [

                          Center(
                            child: Container(
                              color: const Color(0xffebf5f9),
                              margin: EdgeInsets.only(top: _height*0.02, bottom: _height*0.02),
                              child:  Container(
                                height: _height*0.15,
                               decoration: BoxDecoration(
                                 color: Colors.black12,
                                 shape: BoxShape.circle,
                                 image: DecorationImage(
                                   image: _menuProfileModel!.data.profilePhoto !=
                                       ""
                                       ? NetworkImage(
                                     _menuProfileModel!.data.profilePath,

                                   )
                                       : AssetImage('assets/profile_pic.png')
                                   as ImageProvider,
                                   fit: BoxFit.cover
                                 )
                               ),
                                    ),
                              height: _height * 0.1,
                              width: _width * 0.3,
                            ),
                          ),
                          Center(
                            child: Container(
                              color: const Color(0xffebf5f9),
                              child: Column(
                                children: [
                                  Text(
                                    (_menuProfileModel!.data.username),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: const Color(0xff2a2a2a),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Neckar",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 6.0,
                                  ),
                                  Text(
                                    _menuProfileModel!.data.email,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: const Color(0xff676767),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Alexandria",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _height*0.03,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                            width: _width*0.7,
                            height: 1,
                            decoration:
                                BoxDecoration(color: const Color(0xffbcbcbc))),
                      ),
                      SizedBox(
                        height: _height*0.03,
                      ),
                      GestureDetector(
                        onTap: () {
                          Transitioner(
                            context: context,
                            child: AccountScreen(),
                            animation:
                                AnimationType.slideBottom, // Optional value
                            duration:
                                Duration(milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.decelerate, // Optional value
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.manage_accounts_outlined),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.account,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _loadInterstitialAd();
                          if (_interstitialAd != null) {
                            _interstitialAd?.show();
                          } else {
                            Transitioner(
                              context: context,
                              child: HomeProfileScreen(),
                              animation:
                              AnimationType.slideLeft, // Optional value
                              duration:
                              Duration(milliseconds: 1000), // Optional value
                              replacement: false, // Optional value
                              curveType: CurveType.decelerate, // Optional value
                            );
                          }

                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.account_circle_outlined),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.myProfile,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Platform.isIOS
                              ? _launchIOSUrl()
                              : _launchAndroidUrl();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star_border_rounded),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.rate_Us,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          funcOpenMailComposer();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.mail_lock_outlined),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.ContactUs,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _checkInternetConnectionInviteApp();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.inviteApp,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Transitioner(
                            context: context,
                            child: FaqScreen(),
                            animation:
                            AnimationType.slideLeft, // Optional value
                            duration:
                            Duration(milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.decelerate, // Optional value
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                      child: Icon(Icons.pan_tool_alt_outlined),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white12
                                  ),),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.faq,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _statusCheckModel!.data[0].type == "Writer",
                        child:  GestureDetector(
                          onTap: () {
                            Transitioner(
                              context: context,
                              child: PieChartScreen(),
                              animation:
                              AnimationType.slideLeft, // Optional value
                              duration:
                              Duration(milliseconds: 1000), // Optional value
                              replacement: false, // Optional value
                              curveType: CurveType.decelerate, // Optional value
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(_width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.bar_chart),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(Languages.of(context)!.Statistics,
                                        style: const TextStyle(
                                            color: const Color(0xff2a2a2a),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Neckar",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        textAlign: TextAlign.left)
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Transitioner(
                            context: context,
                            child: MyWalletScreen(),
                            animation:
                            AnimationType.slideLeft, // Optional value
                            duration: Duration(
                                milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.decelerate, // Optional value
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.card_travel),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(Languages.of(context)!.myWallet,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      textAlign: TextAlign.left)
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if(_menuProfileModel!.data.totalAmount>=5){
                            Transitioner(
                              context: context,
                              child: UnlockWalletScreenOne(),
                              animation: AnimationType.fadeIn, // Optional value
                              duration: Duration(
                                  milliseconds: 1000), // Optional value
                              replacement: false, // Optional value
                              curveType: CurveType.decelerate, // Optional value
                            );

                          }else{
                            // ToastConstant.showToast(context, Languages.of(context)!.amountWithDraw);

                            showDialogMoney();


                          }

                        },
                        child: Container(
                          width: _width * 0.5,
                          height: _height * 0.05,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0x24000000),
                                    offset: Offset(0, 7),
                                    blurRadius: 14,
                                    spreadRadius: 0)
                              ],
                              color: const Color(0xff3a6c83)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(),
                              Icon(
                                Icons.card_travel,
                                color: Colors.white,
                              ),
                              Text(Languages.of(context)!.unlockWallet,
                                  style: const TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Lato",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.center),
                              SizedBox()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height*0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_outlined,
                                color: const Color(0xff3a6c83)),
                            Text(Languages.of(context)!.LogOut,
                                style: const TextStyle(
                                    color: const Color(0xff3a6c83),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Alexandria",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.right)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _height*0.04,
                      ),

                    ],
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "INTERNET NOT CONNECTED",
                      style: TextStyle(
                        fontFamily: Constants.fontfamily,
                        color: Color(0xFF256D85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.019,
                    ),
                    GestureDetector(
                      child: Container(
                        width: _width * 0.2,
                        height: _height * 0.058,
                        decoration: BoxDecoration(
                            color: const Color(0xFF256D85),
                            shape: BoxShape.circle
                        ),
                        child: const Center(
                          child: Icon(Icons.sync,color: Colors.white,),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _checkInternetConnection();
                        });
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }


  void funcOpenMailComposer() async{

    final mailtoLink = Mailto(
      to: ['n0velflexsupp0rt@gmail.com'],
      cc: ['zahidrehman507@gmail.com','support@estisharati.net'],
      subject: '',
      body: '',
    );
    await launch('$mailtoLink');
  }

  void showDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.alert,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
            Languages.of(context)!.dialogAreyousure,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  Languages.of(context)!.yes,
                  style: TextStyle(fontFamily: Constants.fontfamily),
                ),
                onPressed: ()  {
                  UserProvider userProvider =
                      Provider.of<UserProvider>(this.context, listen: false);

                  userProvider.setUserToken("");
                  userProvider.setUserEmail("");
                  userProvider.setUserName("");
                  Phoenix.rebirth(context);
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text(
                Languages.of(context)!.no,
                style: TextStyle(fontFamily: Constants.fontfamily),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void showDialogMoney() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.alert,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
            Languages.of(context)!.amountWithDraw,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                Languages.of(context)!.dismiss,
                style: TextStyle(fontFamily: Constants.fontfamily),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  _launchIOSUrl() async {
    var url = Uri.parse("https://apps.apple.com/ae/app/novelflex/id1661629198");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchAndroidUrl() async {
    var url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.appcom.estisharati.novel.flex");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future CHECK_STATUS() async {
    final response =
        await http.get(Uri.parse(ApiUtils.CHECK_PROFILE_STATUS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('status_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _statusCheckModel = statusCheckModelFromJson(jsonData);
        MENU_PROFILE_API();
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future MENU_PROFILE_API() async {
    final response =
    await http.get(Uri.parse(ApiUtils.MENU_PROFILE_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('menu_profile_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _menuProfileModel = menuProfileModelFromJson(jsonData);

        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
        _isInternetConnected=true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isInternetConnected = false;
        });
      }
    } else {
      CHECK_STATUS();

    }
  }

  Future<void> _createDynamicLink(var referralCode) async {
    Uri url;
    String link = "https://novelflexapp.page.link/?referral_code=${referralCode}";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://novelflexapp.page.link',
      link: Uri.parse(link),
      androidParameters: const AndroidParameters(
        packageName: 'com.appcom.estisharati.novel.flex',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.appcom.estisharati.novel.flex.novelflex',
        minimumVersion: '1.0.1',
        appStoreId: '1661629198'
      ),
    );


    final  shortLink =
    await dynamicLinks.buildLink(parameters);
    url = shortLink;
    await Share.share('Congratulation You have been invited by ${context.read<UserProvider>().UserName} to NovelFlex $url');
    print("url_dynamic  ${url}");
  }

  Future GET_REFER_CODE() async {
    final response =
    await http.get(Uri.parse(ApiUtils.USER_REFERRAL_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('referralApi_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        if(jsonData1['success'] == false){
          _createDynamicLink("");
        }else{
          _userReferralModel = userReferralModelFromJson(jsonData);
          _createDynamicLink(_userReferralModel!.success![0]!.referralCode.toString());
        }

        // if(_userReferralModel!.success![0]!.referralCode!=""||_userReferralModel!.success![0]!.referralCode!=null){
        //   _createDynamicLink(_userReferralModel!.success![0]!.referralCode.toString());
        // }else{
        //
        // }

      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
      }
    }
  }

  Future _checkInternetConnectionInviteApp() async {
    if (this.mounted) {
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isInternetConnected = false;
        });
      }
    } else {
      GET_REFER_CODE();

    }
  }


}
