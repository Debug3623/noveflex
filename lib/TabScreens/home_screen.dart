import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:new_version/new_version.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:novelflex/MixScreens/RecentNovelsScreen.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../MixScreens/BooksScreens/BookDetailsAuthor.dart';
import '../MixScreens/SeeAllBooksScreen.dart';
import '../MixScreens/notification_screen.dart';
import '../Models/HomeModelClass.dart';
import '../Models/RecentModel.dart';
import '../Models/SliderModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../ad_helper.dart';
import '../localization/Language/languages.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  String route;
  HomeScreen({Key? key, required this.route}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final globalKey = GlobalKey<ScaffoldState>();
  String release = "";
  late AnimationController _bellController;
  SliderModel? _sliderModel;
  RecentModel? _recentModel;
  HomeModelClass? _homeModelClass;
  bool _isLoading = false;
  bool _isNotificationsLoading = false;
  late final translator;
  String? version = '';
  String? storeVersion = '';
  String? storeUrl = '';
  String? packageName = '';
  bool _isInternetConnected = true;
  int count = 0;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    _loadAds();
    _bellController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    checkUpdate();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _bellController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  _loadAds() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      key: globalKey,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: _height * 0.06,
        backgroundColor: const Color(0xffebf5f9),
        leading: (widget.route != "guest")
            ? Container(
                height: _height * 0.1,
                width: _width * 0.1,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/quotes_data/NoPath.png"),
                )),
              )
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
                )),
        actions: [
          SizedBox(
            width: _width * 0.14,
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: _height * 0.02,
                ),
              ],
            ),
          ),
          _isNotificationsLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoActivityIndicator(),
                )
              : InkWell(
                  onTap: () {
                    context.read<UserProvider>().setNotificationsCount(0);
                    setState(() {});
                    Transitioner(
                      context: context,
                      child: NotificationScreen(),
                      animation: AnimationType.slideBottom, // Optional value
                      duration: Duration(milliseconds: 1000), // Optional value
                      replacement: false, // Optional value
                      curveType: CurveType.decelerate, // Optional value
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        child: SizedBox(
                          child: IconButton(
                            onPressed: () {
                              context
                                  .read<UserProvider>()
                                  .setNotificationsCount(0);
                              setState(() {});

                              if (widget.route != "guest") {
                                Transitioner(
                                  context: context,
                                  child: NotificationScreen(),
                                  animation: AnimationType
                                      .slideBottom, // Optional value
                                  duration: Duration(
                                      milliseconds: 1000), // Optional value
                                  replacement: false, // Optional value
                                  curveType:
                                      CurveType.decelerate, // Optional value
                                );
                              } else {
                                ToastConstant.showToast(context,
                                    "Please register yourself to Proceed");
                              }
                            },
                            icon: context
                                        .read<UserProvider>()
                                        .getNotificationCount !=
                                    0
                                ? Lottie.asset(LottieFiles.$63128_bell_icon,
                                    controller: _bellController,
                                    height: 60,
                                    fit: BoxFit.cover)
                                : const Icon(
                                    Icons.notifications_none,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                          ),
                        ),
                      ),
                      context.read<UserProvider>().getNotificationCount != 0
                          ? Positioned(
                              left: _width * 0.065,
                              top: _height * 0.005,
                              child: Container(
                                height: _height * 0.03,
                                width: _width * 0.05,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFF5733)),
                                child: Center(
                                  child: Text(
                                      (widget.route != "guest")
                                          ? context
                                              .read<UserProvider>()
                                              .getNotificationCount
                                              .toString()
                                          : "0",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Lato",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 10.0),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
          const SizedBox(
            width: 5.0,
          )
        ],
      ),
      body: _isInternetConnected == false
          ? Center(
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
                          shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
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
            )
          : _isLoading
              ? const Align(
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Visibility(
                        visible:
                            Provider.of<InternetConnectionStatus>(context) ==
                                InternetConnectionStatus.disconnected,
                        child: Constants.InternetNotConnected(_height * 0.03)),
                    Container(
                      height: _height * 0.2,
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: const Color(0xff002333).withOpacity(0.07)),
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: _sliderModel!.data.length == 0
                              ? Container()
                              : CarouselSlider.builder(
                                  itemCount: _sliderModel!.data.length,
                                  options: CarouselOptions(
                                    height: 400,
                                    aspectRatio: 1,
                                    viewportFraction: 0.95,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.7,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  itemBuilder: (BuildContext context,
                                      int itemIndex, int pageViewIndex) {
                                    return GestureDetector(
                                      onTap: (){
                                        Transitioner(
                                          context: context,
                                          child: BookDetailAuthor(
                                            bookID: _sliderModel!
                                                .data[
                                            itemIndex]
                                                .id
                                                .toString(),
                                          ),
                                          animation: AnimationType
                                              .slideTop, // Optional value
                                          duration: Duration(
                                              milliseconds:
                                              1000), // Optional value
                                          replacement:
                                          false, // Optional value
                                          curveType: CurveType
                                              .decelerate, // Optional value
                                        );
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: _width * 0.03,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    Languages.of(context)!
                                                        .popular,
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: "Alexandria",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                  ),
                                                  Container(
                                                    width: _width * 0.25,
                                                    height: _height * 0.135,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                              _sliderModel!
                                                                  .data[itemIndex]
                                                                  .imagePath
                                                                  .toString(),
                                                            ),
                                                            fit: BoxFit.cover)),
                                                    child: ClipRRect(
                                                      child: Banner(
                                                        message: _sliderModel!
                                                                    .data[
                                                                        itemIndex]
                                                                    .paymentStatus
                                                                    .toString() ==
                                                                "1"
                                                            ? "Free"
                                                            : "Pro ++",
                                                        location:
                                                            BannerLocation.topEnd,
                                                        color: _sliderModel!
                                                                    .data[
                                                                        itemIndex]
                                                                    .paymentStatus
                                                                    .toString() ==
                                                                "1"
                                                            ? Color(0xff00bb23)
                                                            : Colors.red,
                                                        child: CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality.high,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                                  // decoration: BoxDecoration(
                                                                  //   shape: BoxShape.rectangle,
                                                                  //   borderRadius:
                                                                  //   BorderRadius.circular(
                                                                  //       10),
                                                                  //   image: DecorationImage(
                                                                  //       image: imageProvider,
                                                                  //       fit: BoxFit.cover),
                                                                  // ),
                                                                  ),
                                                          imageUrl: _sliderModel!
                                                              .data[itemIndex]
                                                              .imagePath
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CupertinoActivityIndicator(
                                                            color:
                                                                Color(0xFF256D85),
                                                          )),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Center(
                                                                  child: Icon(Icons
                                                                      .error_outline)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox()
                                                ],
                                              ),
                                              SizedBox(
                                                width: _width * 0.05,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(),
                                                    SizedBox(),
                                                    SizedBox(),
                                                    SizedBox(),
                                                    Text(
                                                      _sliderModel!
                                                          .data[itemIndex].title
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff2a2a2a),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "Alexandria",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 14.0),
                                                    ),
                                                    Padding(
                                                      padding: context
                                                                  .watch<
                                                                      UserProvider>()
                                                                  .SelectedLanguage ==
                                                              'English'
                                                          ? EdgeInsets.only(
                                                              right:
                                                                  _width * 0.02)
                                                          : EdgeInsets.only(
                                                              left:
                                                                  _width * 0.02),
                                                      child: Text(
                                                        _sliderModel!
                                                            .data[itemIndex]
                                                            .description
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff676767),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: "Lato",
                                                            fontStyle:
                                                                FontStyle.normal,
                                                            fontSize: 12.0),
                                                        textAlign: TextAlign.left,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        maxLines: 5,
                                                      ),
                                                    ),
                                                    Text(
                                                      _sliderModel!
                                                          .data[itemIndex]
                                                          .categories[0]
                                                          .title
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff3a6c83),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: "Lato",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                    SizedBox(),
                                                    SizedBox(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  })),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _checkInternetConnection();
                        },
                        child: ListView(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(_height * 0.015),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Languages.of(context)!
                                              .recentlyPublish,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: Constants.fontfamily,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (widget.route != "guest") {
                                              Transitioner(
                                                context: context,
                                                child: RecentNovelsScreen(),
                                                animation: AnimationType
                                                    .slideLeft, // Optional value
                                                duration: Duration(
                                                    milliseconds:
                                                        1000), // Optional value
                                                replacement:
                                                    false, // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            } else {
                                              ToastConstant.showToast(context,
                                                  "Please register yourself to Proceed");
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                Languages.of(context)!.seeAll,
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff3a6c83),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Lato",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Color(
                                                  0xff002333,
                                                ),
                                                size: _width * 0.04,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height: _height * 0.23,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _recentModel!.data.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index1) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (widget.route != "guest") {
                                                Transitioner(
                                                  context: context,
                                                  child: BookDetailAuthor(
                                                    bookID: _recentModel!
                                                        .data[index1].id
                                                        .toString(),
                                                  ),
                                                  animation: AnimationType
                                                      .slideTop, // Optional value
                                                  duration: Duration(
                                                      milliseconds:
                                                          1000), // Optional value
                                                  replacement:
                                                      false, // Optional value
                                                  curveType: CurveType
                                                      .decelerate, // Optional value
                                                );
                                              } else {
                                                ToastConstant.showToast(context,
                                                    "Please register yourself to Proceed");
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // width: _width*0.45,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    width: _width * 0.25,
                                                    height: _height * 0.15,
                                                    decoration: BoxDecoration(
                                                      // color: Color(0xff3a6c83),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: ClipRRect(
                                                      child: Banner(
                                                        message: _recentModel!
                                                                    .data[
                                                                        index1]
                                                                    .paymentStatus
                                                                    .toString() ==
                                                                "1"
                                                            ? "Free"
                                                            : "Pro ++",
                                                        location: BannerLocation
                                                            .topEnd,
                                                        color: _recentModel!
                                                                    .data[
                                                                        index1]
                                                                    .paymentStatus
                                                                    .toString() ==
                                                                "1"
                                                            ? Color(0xff00bb23)
                                                            : Colors.red,
                                                        child:
                                                            CachedNetworkImage(
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                          imageUrl:
                                                              _recentModel!
                                                                  .data[index1]
                                                                  .imagePath
                                                                  .toString(),
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CupertinoActivityIndicator(
                                                            color: Color(
                                                                0xFF256D85),
                                                          )),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Center(
                                                                  child: Icon(Icons
                                                                      .error_outline)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    _recentModel!
                                                        .data[index1].title
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Alexandria",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 10.0),
                                                  ),
                                                  Text(
                                                      _recentModel!.data[index1]
                                                          .user[0].username
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff676767),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Lato",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 8.0),
                                                      textAlign: TextAlign.left)
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ],
                              ),
                            ),
                            Container(
                                width: _width,
                                height: 1,
                                decoration: BoxDecoration(
                                    color: const Color(0xffbcbcbc))),
                            ListView.builder(
                              shrinkWrap: true, // outer ListView
                              // reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: _homeModelClass?.data.length,
                              itemBuilder: (_, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            context
                                                            .read<
                                                                UserProvider>()
                                                            .SelectedLanguage ==
                                                        "English" ||
                                                    context
                                                            .read<
                                                                UserProvider>()
                                                            .SelectedLanguage ==
                                                        null
                                                ? _homeModelClass!
                                                    .data[index].title
                                                : _homeModelClass!
                                                    .data[index].titleAr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: Constants.fontfamily,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (widget.route != "guest") {
                                                Transitioner(
                                                  context: context,
                                                  child: SeeAllBookScreen(
                                                    categoriesId:
                                                        _homeModelClass!
                                                            .data[index].id
                                                            .toString(),
                                                  ),
                                                  animation: AnimationType
                                                      .fadeIn, // Optional value
                                                  duration: Duration(
                                                      milliseconds:
                                                          1000), // Optional value
                                                  replacement:
                                                      false, // Optional value
                                                  curveType: CurveType
                                                      .decelerate, // Optional value
                                                );
                                              } else {
                                                ToastConstant.showToast(context,
                                                    "Please register yourself to Proceed");
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  Languages.of(context)!.seeAll,
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff3a6c83),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontFamily: "Lato",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12.0),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Color(
                                                    0xff002333,
                                                  ),
                                                  size: _width * 0.04,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: _height * 0.23,
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: _homeModelClass!
                                              .data[index].books.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index1) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (widget.route != "guest") {
                                                  Transitioner(
                                                    context: context,
                                                    child: BookDetailAuthor(
                                                      bookID: _homeModelClass!
                                                          .data[index]
                                                          .books[index1]
                                                          .id
                                                          .toString(),
                                                    ),
                                                    animation: AnimationType
                                                        .slideTop, // Optional value
                                                    duration: Duration(
                                                        milliseconds:
                                                            1000), // Optional value
                                                    replacement:
                                                        false, // Optional value
                                                    curveType: CurveType
                                                        .decelerate, // Optional value
                                                  );
                                                } else {
                                                  ToastConstant.showToast(
                                                      context,
                                                      "Please register yourself to Proceed");
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      // width: _width*0.45,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      width: _width * 0.25,
                                                      height: _height * 0.15,
                                                      decoration: BoxDecoration(
                                                        // color: Color(0xff3a6c83),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: ClipRRect(
                                                        child: Banner(
                                                          message: _homeModelClass!
                                                                      .data[
                                                                          index]
                                                                      .books[
                                                                          index1]
                                                                      .paymentStatus
                                                                      .toString() ==
                                                                  "1"
                                                              ? "Free"
                                                              : "Pro ++",
                                                          location:
                                                              BannerLocation
                                                                  .topEnd,
                                                          color: _homeModelClass!
                                                                      .data[
                                                                          index]
                                                                      .books[
                                                                          index1]
                                                                      .paymentStatus
                                                                      .toString() ==
                                                                  "1"
                                                              ? Color(
                                                                  0xff00bb23)
                                                              : Colors.red,
                                                          child:
                                                              CachedNetworkImage(
                                                            filterQuality:
                                                                FilterQuality
                                                                    .high,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                            imageUrl:
                                                                _homeModelClass!
                                                                    .data[index]
                                                                    .books[
                                                                        index1]
                                                                    .image
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Center(
                                                                    child:
                                                                        CupertinoActivityIndicator(
                                                              color: Color(
                                                                  0xFF256D85),
                                                            )),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .error_outline)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      _homeModelClass!
                                                          .data[index]
                                                          .books[index1]
                                                          .bookTitle
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff2a2a2a),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "Alexandria",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 10.0),
                                                    ),
                                                    Text(
                                                        _homeModelClass!
                                                            .data[index]
                                                            .books[index1]
                                                            .authorName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: const Color(
                                                                0xff676767),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: "Lato",
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize: 8.0),
                                                        textAlign:
                                                            TextAlign.left)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )),
                                    Container(
                                        width: _width,
                                        height: 1,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffbcbcbc))),
                                  ],
                                );
                              },
                            ),
                            _bannerAd != null
                                ? Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: _bannerAd!.size.width
                                      .toDouble(),
                                  height: _bannerAd!.size.height
                                      .toDouble(),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: AdWidget(ad: _bannerAd!),
                                ),
                              ),
                            )
                                : Container()
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
      // drawer: DrawerCode(),
    );
  }

  Future _checkInternetConnection() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
        _isInternetConnected = true;
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
      _callDashboardDioAPI();
      if (widget.route != "guest") {
        NotificationsCount();
      } else {
        print("guest login");
        context.read<UserProvider>().setNotificationsCount(0);
      }
    }
  }

  Future _callDashboardDioAPI() async {
    final response = await http.get(
      Uri.parse(ApiUtils.SLIDER_API),
      //     headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      // }
    );

    if (response.statusCode == 200) {
      print('home_response${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        print('slider_response ${response.body}');
        var jsonData = jsonDecode(response.body);
        _sliderModel = SliderModel.fromJson(jsonData);
        RecentApiCall();
      } else {
        ToastConstant.showToast(context, jsonData['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future RecentApiCall() async {
    final response = await http.get(
      Uri.parse(ApiUtils.RECENT_API),
      //     headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      // }
    );

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _recentModel = recentModelFromJson(jsonData);
        // setState(() {
        //   _isLoading = false;
        // });
        HOMEApiCall();
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future NotificationsCount() async {
    setState(() {
      _isNotificationsLoading = true;
    });
    final response =
        await http.get(Uri.parse(ApiUtils.NOTIFICATIONS_COUNT), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('notifications_count_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        context.read<UserProvider>().setNotificationsCount(jsonData1['data']);
        setState(() {
          _isNotificationsLoading = false;
          print(
              "notifications count = ${context.read<UserProvider>().getNotificationCount}");
        });
      } else {
        setState(() {
          _isNotificationsLoading = false;
        });
      }
    }
  }

  Future HOMEApiCall() async {
    final response = await http.get(
      Uri.parse(ApiUtils.ALL_HOME_CATEGORIES_API),
      //         headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      //   'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      // }
    );

    if (response.statusCode == 200) {
      print('home_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _homeModelClass = homeModelClassFromJson(jsonData);
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

  void checkUpdate() async {
    final newVersion = NewVersionPlus(
        androidId: "com.appcom.estisharati.novel.flex",
        iOSId: "com.appcom.estisharati.novel.flex.novelflex",
        iOSAppStoreCountry: 'AE');
    final status = await newVersion.getVersionStatus();

    if (status?.canUpdate == true) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status!,
        allowDismissal: true,
        dialogTitle: "UPDATE",
        dialogText:
            "Please update the app from ${status.localVersion} to ${status.storeVersion}",
      );
    }
    print("${status?.storeVersion}");
    print("${status?.appStoreLink}");
  }
}
