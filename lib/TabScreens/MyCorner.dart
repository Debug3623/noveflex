import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../MixScreens/BookDetailsAuthor.dart';
import '../Models/LikesBooksModel.dart';
import '../Models/SavedBooksModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';

class MyCorner extends StatefulWidget {
  const MyCorner({Key? key}) : super(key: key);

  @override
  State<MyCorner> createState() => _MyCornerState();
}

class _MyCornerState extends State<MyCorner> {

  SavedBooksModel? _savedBooksModel;
  LikesBooksModel? _likesBooksModel;

  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }
  bool saved = true;
  bool liked = false;
  bool history = false;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        title: Text(Languages.of(context)!.myCorner,
            style: const TextStyle(
                color: const Color(0xff2a2a2a),
                fontWeight: FontWeight.w700,
                fontFamily: "Alexandria",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            textAlign: TextAlign.end),
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saved = true;
                      liked = false;
                      history = false;
                    });
                    _checkInternetConnection();
                  },
                  child: Container(
                      width: _width * 0.25,
                      height: _height * 0.04,
                      child: Center(
                        child: Text(
                          Languages.of(context)!.saved,
                          style: _widgetTextStyle(),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                          color: saved ? Color(0xff3a6c83) : Colors.black54)),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saved = false;
                      liked = true;
                      history = false;
                    });

                    _checkInternetConnectionQ();
                  },
                  child: Container(
                      width: _width * 0.25,
                      height: _height * 0.04,
                      child: Center(
                        child: Text(
                          Languages.of(context)!.liked,
                          style: _widgetTextStyle(),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                          color: liked ? Color(0xff3a6c83) : Colors.black54)),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saved = false;
                      liked = false;
                      history = true;
                    });
                  },
                  child: Container(
                      width: _width * 0.3,
                      height: _height * 0.04,
                      child: Center(
                        child: Text(
                         "",
                          style: _widgetTextStyle(),
                        ),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                          color: history ? Color(0xffebf5f9): Color(0xffebf5f9))),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: _height * 0.02),
              width: _width,
              height: 1,
              decoration: BoxDecoration(color: const Color(0xffbcbcbc))),
          Expanded(
            child: _isInternetConnected
                ? _isLoading
                ? const Align(
              alignment: Alignment.center,
              child: CupertinoActivityIndicator(),
            )
                : saved ? Padding(
              padding:  EdgeInsets.only(top: _height*0.02,left: _width*0.03,right: _width*0.01),
              child: _savedBooksModel!.data!.length== 0 ? Padding(
                padding:
                EdgeInsets.all(_height * _width * 0.0004),
                child: Center(
                  child: Text(
                    Languages.of(context)!.nodata,
                    style: const TextStyle(
                        fontFamily: Constants.fontfamily,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ): GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.78,
                mainAxisSpacing: _height*0.01,
                children: List.generate(_savedBooksModel!.data!.length, (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Transitioner(
                            context: context,
                            child: BookDetailAuthor(
                              bookID: _savedBooksModel!
                                  .data![index]!.id
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
                            width: _width*0.25,
                            height: _height*0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                ),
                              image: DecorationImage(
                                image: NetworkImage(_savedBooksModel!.data![index]!.imagePath.toString()),
                                fit: BoxFit.cover
                              ),
                              color: Colors.green
                            )
                        ),
                      ),
                      SizedBox(height: _height*0.01,),
                      Expanded(
                        child: Text(
                            _savedBooksModel!.data![index]!.title.toString(),
                            style: const TextStyle(
                                color:  const Color(0xff2a2a2a),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Alexandria",
                                fontStyle:  FontStyle.normal,
                                fontSize: 12.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      Expanded(
                          child: Text(
                              _savedBooksModel!.data![index]!.username.toString(),
                          style: const TextStyle(
                              color:  const Color(0xff676767),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Lato",
                              fontStyle:  FontStyle.normal,
                              fontSize: 12.0
                          ),
                          textAlign: TextAlign.left
                      )),
                    ],
                  );
                }),
              ),
            ) : Padding(
              padding:  EdgeInsets.only(top: _height*0.02,left: _width*0.03,right: _width*0.01),
              child:_likesBooksModel!.data!.length== 0 ? Padding(
                padding:
                EdgeInsets.all(_height * _width * 0.0004),
                child: Center(
                  child: Text(
                    Languages.of(context)!.nodata,
                    style: const TextStyle(
                        fontFamily: Constants.fontfamily,
                        color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              ): GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 0.78,
                mainAxisSpacing: _height*0.01,
                children: List.generate(_likesBooksModel!.data!.length, (index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Transitioner(
                            context: context,
                            child: BookDetailAuthor(
                              bookID: _likesBooksModel!
                                  .data![index]!.id
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
                            width: _width*0.25,
                            height: _height*0.15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                image: DecorationImage(
                                    image: NetworkImage(_likesBooksModel!.data![index]!.imagePath.toString()),
                                    fit: BoxFit.cover
                                ),
                                color: Colors.green
                            )
                        ),
                      ),
                      SizedBox(height: _height*0.01,),
                      Expanded(
                        child: Text(
                            _likesBooksModel!.data![index]!.title.toString(),
                            style: const TextStyle(
                                color:  const Color(0xff2a2a2a),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Alexandria",
                                fontStyle:  FontStyle.normal,
                                fontSize: 12.0
                            ),
                            textAlign: TextAlign.left
                        ),
                      ),
                      Expanded(
                          child: Text(
                              _likesBooksModel!.data![index]!.username.toString(),
                              style: const TextStyle(
                                  color:  const Color(0xff676767),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Lato",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 12.0
                              ),
                              textAlign: TextAlign.left
                          )),
                    ],
                  );
                }),
              ),
            )  : Center(
              child: Text("No Internet Connection!"),
            ),
          )
        ],
      ),
    );
  }

  _widgetTextStyle() {
    return const TextStyle(
        color: const Color(0xffffffff),
        fontWeight: FontWeight.w400,
        fontFamily: "Alexandria",
        fontStyle: FontStyle.normal,
        fontSize: 12.0);
  }

  Future SavedBooksApiCall() async {
    final response =
    await http.get(Uri.parse(ApiUtils.SAVED_BOOKS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('saved_books_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _savedBooksModel = savedBooksModelFromJson(jsonData);
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

  Future LikesBooksApiCall() async {
    final response =
    await http.get(Uri.parse(ApiUtils.LIKES_BOOKS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('likes_books_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _likesBooksModel = likesBooksModelFromJson(jsonData);
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
      SavedBooksApiCall();
    }
  }
  Future _checkInternetConnectionQ() async {
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
      LikesBooksApiCall();
    }
  }
}
