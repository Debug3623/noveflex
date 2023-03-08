import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../../Models/AuthorProfileViewModel.dart';
import 'dart:convert';
import 'dart:io';
import 'package:novelflex/MixScreens/Uploadscreens/UploadDataScreen.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';

import '../../Models/ReaderProfileModel.dart';
import '../../Models/StatusCheckModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../localization/Language/languages.dart';
import '../BooksScreens/AuthorViewByUserScreen.dart';
import '../BooksScreens/BookDetailsAuthor.dart';
import '../Uploadscreens/upload_history_screen.dart';

class HomeProfileScreen extends StatefulWidget {
  const HomeProfileScreen({Key? key}) : super(key: key);

  @override
  State<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends State<HomeProfileScreen> {
  AuthorProfileViewModel? _authorProfileViewModel;
  ReaderProfileModel? _readerProfileModel;
  StatusCheckModel? _statusCheckModel;

  bool _isLoading = false;
  bool _isInternetConnected = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isImageLoading = false;
  File? _cover_imageFile;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: SafeArea(
        child: Container(
          child: _isInternetConnected
              ? _isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : _statusCheckModel!.data[0].type == "Reader"
                      ? Stack(
                          children: [
                            Positioned(
                                child: Container(
                              height: _height * 0.9,
                              color: const Color(0xffebf5f9),
                            )),
                            Positioned(
                              child: Container(
                                height: _height * 0.13,
                                width: _width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            Positioned(
                              left: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'English'
                                  ? _width * 0.05
                                  : 0.0,
                              right: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'Arabic'
                                  ? _width * 0.05
                                  : 0.0,
                              top: _height * 0.05,
                              child: Column(
                                children: [
                                  Container(
                                    height: _height * 0.15,
                                    width: _width * 0.5,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        image: DecorationImage(
                                            image: _readerProfileModel!
                                                .data.profilePhoto ==
                                                ""
                                                ? AssetImage(
                                                "assets/profile_pic.png",)
                                                : NetworkImage(
                                                _readerProfileModel!
                                                    .data.profilePath
                                                    .toString())
                                            as ImageProvider,
                                            fit: BoxFit.cover)),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: _height * 0.02),
                                    child: Text(
                                      _readerProfileModel!.data.username,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: _height * 0.01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/quotes_data/extra_pngs/glasses.png",
                                          color: const Color(0xff002333),
                                          height: _height * 0.03,
                                          width: _width * 0.03,
                                        ),
                                        SizedBox(
                                          width: _width * 0.03,
                                        ),
                                        Text(Languages.of(context)!.reader,
                                            style: const TextStyle(
                                                color: const Color(0xff3a6c83),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Lato",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: _height * 0.35,
                              left: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'English'
                                  ? _width * 0.05
                                  : 0.0,
                              right: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'Arabic'
                                  ? _width * 0.05
                                  : 0.0,
                              child: Container(
                                height: _height * 0.3,
                                width: _width,
                                child: Text(
                                  Languages.of(context)!.following,
                                  style: const TextStyle(
                                      color: const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.4,
                              child: _readerProfileModel
                                          ?.data.following.length ==
                                      0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: _height * 0.1,
                                          left: _width * 0.45,
                                          right: _width * 0.45),
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!.nodata,
                                          style: const TextStyle(
                                              fontFamily: Constants.fontfamily,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: _height * 0.3,
                                      width: _width,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _readerProfileModel!
                                            .data.following.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Transitioner(
                                                context: context,
                                                child: AuthorViewByUserScreen(
                                                    user_id: _readerProfileModel!
                                                      .data
                                                      .following[index]
                                                      .id
                                                      .toString(),
                                                ),
                                                animation: AnimationType.fadeIn,
                                                // Optional value
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                // Optional value
                                                replacement: false,
                                                // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: _width * 0.05,
                                                  right: _width * 0.05),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: _width * 0.22,
                                                    height: _height * 0.12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image:  NetworkImage(
                                                              _readerProfileModel!
                                                                  .data
                                                                  .following[
                                                                      index]
                                                                  .profilePath
                                                                  .toString())),
                                                    ),
                                                  ),
                                                  Text(
                                                    _readerProfileModel!
                                                        .data
                                                        .following[index]
                                                        .username
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      color: Color(0xff313131),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),

                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Positioned(
                              top: _height * 0.32,
                              left: _width * 0.1,
                              right: _width * 0.1,
                              child: Opacity(
                                opacity: 0.20000000298023224,
                                child: Container(
                                    width: 368,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff3a6c83))),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.64,
                              left: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'English'
                                  ? _width * 0.05
                                  : 0.0,
                              right: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'Arabic'
                                  ? _width * 0.05
                                  : 0.0,
                              child: Container(
                                height: _height * 0.3,
                                width: _width,
                                child: Text(
                                  Languages.of(context)!.continueReading,
                                  style: const TextStyle(
                                      color: const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.67,
                              child: _readerProfileModel!.data.books.length ==
                                      0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: _height * 0.15,
                                          left: _width * 0.45,
                                          right: _width * 0.45),
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!.nodata,
                                          style: const TextStyle(
                                              fontFamily: Constants.fontfamily,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: _height * 0.3,
                                      width: _width,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _readerProfileModel!
                                            .data.books.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Transitioner(
                                                context: context,
                                                child: BookDetailAuthor(
                                                  bookID: _readerProfileModel!
                                                      .data.books[index].id
                                                      .toString(),
                                                ),
                                                animation: AnimationType.fadeIn,
                                                // Optional value
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                // Optional value
                                                replacement: false,
                                                // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                      child: Container(
                                                        width: _width * 0.22,
                                                        height: _height * 0.12,
                                                        margin: EdgeInsets.all(
                                                            _width * 0.05),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10.0),
                                                          color: Colors.black,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  _readerProfileModel!
                                                                      .data
                                                                      .books[
                                                                          index]
                                                                      .bookImage
                                                                      .toString())),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: _height * 0.12,
                                                        left: _width * 0.07,
                                                        child: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.white,
                                                          size: _height *
                                                              _width *
                                                              0.00005,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  _readerProfileModel!.data
                                                      .books[index].title
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: Color(0xff313131),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Positioned(
                                child: Container(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                            )),
                          ],
                        )
                      : Stack(
                          children: [
                            Positioned(
                                child: Container(
                              height: _height * 0.9,
                              color: const Color(0xffebf5f9),
                            )),
                            Positioned(
                              child: Container(
                                height: _height * 0.25,
                                width: _width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    image: NetworkImage(
                                      _authorProfileViewModel!
                                          .data.backgroundPath,
                                    ),
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                child: InkWell(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Container(
                                height: _height * 0.25,
                                width: _width,
                                child: Container(
                                  height: _height * 0.05,
                                  width: _width * 0.05,
                                  margin: EdgeInsets.only(
                                      bottom: _height * 0.02,
                                      top: _height * 0.02),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                  ),
                                  child: _isImageLoading
                                      ? const Center(
                                          child: CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.image,
                                            size: _height * _width * 0.00008,
                                            color: Colors.black26,
                                          ),
                                        ),
                                ),
                              ),
                            )),
                            Positioned(
                              left: _width * 0.02,
                              top: _height * 0.21,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: _height * 0.12,
                                    width: _width * 0.23,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        image: DecorationImage(
                                            image: _authorProfileViewModel!
                                                        .data.profilePhoto ==
                                                    ""
                                                ? AssetImage(
                                                    "assets/profile_pic.png")
                                                : NetworkImage(
                                                        _authorProfileViewModel!
                                                            .data.profilePath
                                                            .toString())
                                                    as ImageProvider,
                                            fit: BoxFit.cover)),
                                    // child:  Icon(
                                    //   Icons.person_pin,
                                    //   size: _height * _width * 0.0003,
                                    //   color: Colors.black54,
                                    // ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.02,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: _height * 0.06),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:_width*0.3,
                                          child: Text(
                                            _authorProfileViewModel!
                                                .data.username,
                                            style: const TextStyle(
                                                color: const Color(0xff2a2a2a),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Neckar",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 11.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              Languages.of(context)!.followers,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff3a6c83),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Lato",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              _authorProfileViewModel!
                                                  .data!.followers
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff3a6c83),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Lato",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: _height * 0.07,
                                      left: context
                                                  .read<UserProvider>()
                                                  .SelectedLanguage ==
                                              'English'
                                          ? _width * 0.15
                                          : 0.0,
                                      right: context
                                                  .read<UserProvider>()
                                                  .SelectedLanguage ==
                                              'Arabic'
                                          ? _width * 0.15
                                          : 0.0,
                                    ),
                                    child: GestureDetector(
                                        onTap: () {
                                          Transitioner(
                                            context: context,
                                            child: UploadDataScreen(),
                                            animation: AnimationType.slideLeft,
                                            // Optional value
                                            duration:
                                                Duration(milliseconds: 1000),
                                            // Optional value
                                            replacement: false,
                                            // Optional value
                                            curveType: CurveType
                                                .decelerate, // Optional value
                                          );
                                        },
                                        child: Container(
                                          width: _width * 0.25,
                                          height: _height * 0.04,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff3a6c83),
                                                  width: 1),
                                              color: const Color(0xffebf5f9)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: const Color(0xff3a6c83),
                                              ),
                                              Text(
                                                  Languages.of(context)!
                                                      .publishButton,
                                                  style: const TextStyle(
                                                      color: const Color(
                                                          0xff3a6c83),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontFamily: "Lato",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 10.0),
                                                  textAlign: TextAlign.left)
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: _height * 0.36,
                              left: _width * 0.1,
                              right: _width * 0.1,
                              child: Opacity(
                                opacity: 0.20000000298023224,
                                child: Container(
                                    width: 368,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff3a6c83))),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.4,
                              child: Container(
                                margin: EdgeInsets.all(16.0),
                                height: _height * 0.2,
                                width: _width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: context
                                                  .read<UserProvider>()
                                                  .SelectedLanguage ==
                                              'English'
                                          ? _width * 0.05
                                          : 0.0,
                                      right: context
                                                  .read<UserProvider>()
                                                  .SelectedLanguage ==
                                              'Arabic'
                                          ? _width * 0.05
                                          : 0.0,
                                      top: _height * 0.02),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(Languages.of(context)!.aboutAuthor,
                                          style: const TextStyle(
                                              color: const Color(0xff2a2a2a),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Alexandria",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: _height * 0.01,
                                      ),
                                      Text(
                                        _authorProfileViewModel!
                                            .data.description
                                            .toString(),
                                        style: const TextStyle(
                                            color: const Color(0xff676767),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Lato",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        overflow: TextOverflow.fade,
                                        maxLines: 6,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.64,
                              left: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'English'
                                  ? _width * 0.05
                                  : 0.0,
                              right: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'Arabic'
                                  ? _width * 0.05
                                  : 0.0,
                              child: Container(
                                height: _height * 0.3,
                                width: _width,
                                child: Text(
                                  Languages.of(context)!.novels,
                                  style: const TextStyle(
                                      color: const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.64,
                              left: userProvider.SelectedLanguage == "English"
                                  ? _width * 0.8
                                  : 0.0,
                              right: userProvider.SelectedLanguage == "English"
                                  ? 0.0
                                  : _width * 0.8,
                              child: GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: UploadHistoryscreen(),
                                    animation: AnimationType
                                        .slideTop, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      Languages.of(context)!.editT,
                                      style: const TextStyle(
                                          color: const Color(0xff3a6c83),
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
                            ),
                            Positioned(
                              top: _height * 0.67,
                              child: _authorProfileViewModel!
                                          .data.book.length ==
                                      0
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          _height * _width * 0.0004),
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!
                                              .nouploadhistory,
                                          style: const TextStyle(
                                              fontFamily: Constants.fontfamily,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: _height * 0.3,
                                      width: _width,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _authorProfileViewModel!
                                            .data.book.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Transitioner(
                                                context: context,
                                                child: BookDetailAuthor(
                                                  bookID:
                                                      _authorProfileViewModel!
                                                          .data
                                                          .book[index]
                                                          .id
                                                          .toString(),
                                                ),
                                                animation: AnimationType.fadeIn,
                                                // Optional value
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                // Optional value
                                                replacement: false,
                                                // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: _width * 0.22,
                                                      height: _height * 0.12,
                                                      margin: EdgeInsets.all(
                                                          _width * 0.05),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: Colors.black,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: _authorProfileViewModel!
                                                                        .data
                                                                        .book[
                                                                            index]
                                                                        .imagePath
                                                                        .toString() ==
                                                                    ""
                                                                ? const AssetImage(
                                                                    "assets/quotes_data/manga image.png")
                                                                : NetworkImage(_authorProfileViewModel!
                                                                        .data
                                                                        .book[
                                                                            index]
                                                                        .imagePath
                                                                        .toString())
                                                                    as ImageProvider),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: _height * 0.12,
                                                        left: _width * 0.07,
                                                        child: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.white,
                                                          size: _height *
                                                              _width *
                                                              0.00005,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  _authorProfileViewModel!
                                                      .data!.book![index]!.title
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: Color(0xff313131),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Positioned(
                                child: Container(
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios)),
                            )),
                          ],
                        )
              : Center(
                  child: Constants.InternetNotConnected(_height * 0.03),
                ),
        ),
      ),
    );
  }

  Future AUTHOR_PROFILE() async {
    var map = Map<String, dynamic>();
    map['user_id'] = _statusCheckModel!.data[0].id.toString();

    final response =
        await http.post(Uri.parse(ApiUtils.AUTHOR_BOOKS_DETAILS_API),
            headers: {
              'Authorization':
                  "Bearer ${context.read<UserProvider>().UserToken}",
            },
            body: map);

    if (response.statusCode == 200) {
      print("author_executed");
      print('author_profile${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _authorProfileViewModel = authorProfileViewModelFromJson(jsonData);
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

  Future READER_PROFILE() async {
    final response =
        await http.get(Uri.parse(ApiUtils.READER_PROFILE_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('reader_profile_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _readerProfileModel = readerProfileModelFromJson(jsonData);

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
        if (_statusCheckModel!.data[0].type == "Reader") {
          READER_PROFILE();
        } else {
          AUTHOR_PROFILE();

        }
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

  Future<void> UploadCoverImageApi() async {
    setState(() {
      _isImageLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}"
    };

    var jsonResponse;

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUtils.UPLOAD_BACKGROUND_IMAGE_API));
    request.files.add(http.MultipartFile.fromBytes(
      "background_image",
      File(_cover_imageFile!.path)
          .readAsBytesSync(), //UserFile is my JSON key,use your own and "image" is the pic im getting from my gallary
      filename: "Image.jpg",
      contentType: MediaType('image', 'jpg'),
    ));

    request.headers.addAll(headers);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("Cover Image Uploaded! ");
          print('COVER_image_upload ' + response.body);
          Constants.showToastBlack(
              context, "your background  image updated successfully");
          setState(() {
            _isImageLoading = false;
          });
          _checkInternetConnection();
        }
      });
    });
  }

  _getFromGallery() async {
    final PickedFile? image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _cover_imageFile = File(image.path);
      setState(() {
        _cover_imageFile = File(image.path);
      });
      UploadCoverImageApi();
    }
  }
}
