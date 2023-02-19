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
import '../Models/AuthorProfileViewModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../localization/Language/languages.dart';
import 'BookDetailsAuthor.dart';
import 'Pay/Pay.dart';

class AuthorViewByUserScreen extends StatefulWidget {
  String user_id;
  AuthorViewByUserScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  State<AuthorViewByUserScreen> createState() => _AuthorViewByUserScreenState();
}

class _AuthorViewByUserScreenState extends State<AuthorViewByUserScreen> {
  AuthorProfileViewModel? _authorProfileViewModel;

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
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),

      body: SafeArea(
        child: Container(
          child: _isInternetConnected
              ? _isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
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
                                color: Color(0xFF256D85),
                                image: DecorationImage(
                                    image: _authorProfileViewModel!
                                                .data!.backgroundPath ==
                                            null
                                        ? AssetImage('')
                                        : NetworkImage(
                                            _authorProfileViewModel!
                                                .data!.imagePath
                                                .toString(),
                                          ) as ImageProvider,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          left: _width * 0.05,
                          top: _height * 0.21,
                          child: Row(
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
                                                    .data!.imagePath ==
                                                null
                                            ? AssetImage(
                                                "assets/profile_pic.png")
                                            : NetworkImage(
                                                    _authorProfileViewModel!
                                                        .data!.imagePath
                                                        .toString())
                                                as ImageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: _width * 0.05,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: _height * 0.06),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _authorProfileViewModel!.data!.username!,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      height: _height * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          Languages.of(context)!.followers,
                                          style: const TextStyle(
                                              color: const Color(0xff3a6c83),
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
                                              color: const Color(0xff3a6c83),
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
                                  left:context.read<UserProvider>().SelectedLanguage=='English' ?  _width * 0.15 : 0.0,
                                  right:context.read<UserProvider>().SelectedLanguage=='Arabic' ? _width * 0.15: 0.0,),
                                child: GestureDetector(
                                  onTap: () {
                                    _settingModalBottomSheet(context);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      // Transitioner(
                                      //   context: context,
                                      //   child: Pay(
                                      //     image: _authorProfileViewModel!
                                      //         .data!.imagePath
                                      //         .toString(),
                                      //     name: _authorProfileViewModel!
                                      //         .data!.username
                                      //         .toString(),
                                      //   ),
                                      //   animation: AnimationType
                                      //       .slideLeft, // Optional value
                                      //   duration: Duration(
                                      //       milliseconds:
                                      //           1000), // Optional value
                                      //   replacement: false, // Optional value
                                      //   curveType: CurveType
                                      //       .decelerate, // Optional value
                                      // );
                                    },
                                    child: Container(
                                      width: _width * 0.24,
                                      height: _height * 0.04,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: const Color(0xff3a6c83),
                                              width: 1),
                                          color: Color(0xffebf5f9)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _authorProfileViewModel!
                                                  .data!.isSubscription!
                                              ? Icon(
                                                  Icons
                                                      .notification_add_outlined,
                                                  color:
                                                      const Color(0xff3a6c83))
                                              : Icon(
                                                  Icons.person_add,
                                                  color:
                                                      const Color(0xff3a6c83),
                                                ),
                                          Text(
                                              _authorProfileViewModel!
                                                      .data!.isSubscription!
                                                  ? Languages.of(context)!
                                                      .unfollow_text
                                                  : Languages.of(context)!
                                                      .follow_author,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff3a6c83),
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: "Lato",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                top: _height * 0.02,
                                left:context.read<UserProvider>().SelectedLanguage=='English' ?  _width * 0.05 : 0.0,
                                right:context.read<UserProvider>().SelectedLanguage=='Arabic' ? _width * 0.05: 0.0,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    _authorProfileViewModel!.data!.description
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
                          left:context.read<UserProvider>().SelectedLanguage=='English' ? _width * 0.05 : 0.0,
                          right:context.read<UserProvider>().SelectedLanguage=='Arabic' ? _width * 0.05: 0.0,
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
                          top: _height * 0.67,
                          child: _authorProfileViewModel!.data!.book!.length ==
                                  0
                              ? Padding(
                                  padding:
                                      EdgeInsets.all(_height * _width * 0.0004),
                                  child: Center(
                                    child: Text(
                                      Languages.of(context)!.nouploadhistory,
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
                                        .data!.book!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Transitioner(
                                            context: context,
                                            child: BookDetailAuthor(
                                              bookID: _authorProfileViewModel!
                                                  .data!.book![index]!.id
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
                                                        BorderRadius.circular(
                                                            10.0),
                                                    color: Colors.black,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: _authorProfileViewModel!
                                                                    .data!
                                                                    .book![
                                                                        index]!
                                                                    .imagePath
                                                                    .toString() ==
                                                                ""
                                                            ? const AssetImage(
                                                                "assets/quotes_data/manga image.png")
                                                            : NetworkImage(_authorProfileViewModel!
                                                                    .data!
                                                                    .book![index]!
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
                                              overflow: TextOverflow.ellipsis,
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
    map['user_id'] = widget.user_id.toString();

    final response =
        await http.post(Uri.parse(ApiUtils.AUTHOR_BOOKS_DETAILS_API),
            headers: {
              'Authorization':
                  "Bearer ${context.read<UserProvider>().UserToken}",
            },
            body: map);

    if (response.statusCode == 200) {
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
      AUTHOR_PROFILE();
    }
  }

  // Future<void> UploadCoverImageApi() async {
  //   setState(() {
  //     _isImageLoading = true;
  //   });
  //   Map<String, String> headers = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //     "accesstoken": context.read<UserProvider>().UserToken.toString(),
  //   };
  //
  //   var jsonResponse;
  //
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse(ApiUtils.COVER_IMAGE_API));
  //   request.files.add( http.MultipartFile.fromBytes(
  //     "background_image",
  //     File(imageFileCoverImage!.path)
  //         .readAsBytesSync(), //UserFile is my JSON key,use your own and "image" is the pic im getting from my gallary
  //     filename: "Image.jpg",
  //     contentType: MediaType('image', 'jpg'),
  //   ));
  //
  //   request.headers.addAll(headers);
  //
  //   request.send().then((result) async {
  //     http.Response.fromStream(result).then((response) {
  //       if (response.statusCode == 200) {
  //         print("Cover Image Uploaded! ");
  //         print('profile_image_upload ' + response.body);
  //         Constants.showToastBlack(context, "Cover Image Upload Successfully");
  //         setState(() {
  //           _isImageLoading = false;
  //         });
  //         _checkInternetConnection();
  //       }
  //     });
  //   });
  // }

  _getFromGallery() async {
    final PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (image != null) {
      _cover_imageFile = File(image.path);
      setState(() {
        _cover_imageFile = File(image.path);
      });
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xffebf5f9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (BuildContext bc) {
          var _height = MediaQuery.of(context).size.height;
          var _width = MediaQuery.of(context).size.width;
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add Payment Details"),
                Container(
                  height: _height * 0.1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: _height * 0.02, horizontal: _width * 0.04),
                    child: TextFormField(
                      // key: _emailKey,
                      // controller: _controllerEmail,
                      // focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      // validator: validateEmail,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context)
                      //       .requestFocus(_passwordFocusNode);
                      // },
                      decoration: InputDecoration(
                          errorMaxLines: 3,
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white12,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          hintText: Languages.of(context)!.email,
                          // labelText: Languages.of(context)!.email,
                          hintStyle: const TextStyle(
                            fontFamily: Constants.fontfamily,
                          )),
                    ),
                  ),
                ),
                Container(
                  height: _height * 0.1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: _height * 0.02, horizontal: _width * 0.04),
                    child: TextFormField(
                      // key: _emailKey,
                      // controller: _controllerEmail,
                      // focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      // validator: validateEmail,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context)
                      //       .requestFocus(_passwordFocusNode);
                      // },
                      decoration: InputDecoration(
                          errorMaxLines: 3,
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white12,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          hintText: Languages.of(context)!.email,
                          // labelText: Languages.of(context)!.email,
                          hintStyle: const TextStyle(
                            fontFamily: Constants.fontfamily,
                          )),
                    ),
                  ),
                ),
                Container(
                  height: _height * 0.1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: _height * 0.02, horizontal: _width * 0.04),
                    child: TextFormField(
                      // key: _emailKey,
                      // controller: _controllerEmail,
                      // focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      // validator: validateEmail,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context)
                      //       .requestFocus(_passwordFocusNode);
                      // },
                      decoration: InputDecoration(
                          errorMaxLines: 3,
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white12,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          hintText: Languages.of(context)!.email,
                          // labelText: Languages.of(context)!.email,
                          hintStyle: const TextStyle(
                            fontFamily: Constants.fontfamily,
                          )),
                    ),
                  ),
                ),
                Container(
                  height: _height * 0.1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: _height * 0.02, horizontal: _width * 0.04),
                    child: TextFormField(
                      // key: _emailKey,
                      // controller: _controllerEmail,
                      // focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      // validator: validateEmail,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context)
                      //       .requestFocus(_passwordFocusNode);
                      // },
                      decoration: InputDecoration(
                          errorMaxLines: 3,
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.white12,
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              )),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          hintText: Languages.of(context)!.email,
                          // labelText: Languages.of(context)!.email,
                          hintStyle: const TextStyle(
                            fontFamily: Constants.fontfamily,
                          )),
                    ),
                  ),
                ),
                Container(
                    height: _height * 0.05,
                    width: _width * 0.9,
                    padding: EdgeInsets.symmetric(
                        vertical: _height * 0.02, horizontal: _width * 0.04),
                    decoration: BoxDecoration(
                        color: Color(0xFF256D85),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Pay 1 \$ to Subscribe")),
              ],
            ),
          );
        });
  }
}
