import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../../Models/BookReviewModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../ad_helper.dart';
import '../../localization/Language/languages.dart';


class ShowAllReviewScreen extends StatefulWidget {
  String? bookId;
  String bookName;
  String bookImage;
  ShowAllReviewScreen({required this.bookId,required this.bookName,required this.bookImage});

  @override
  State<ShowAllReviewScreen> createState() => _ShowAllReviewScreenState();
}

class _ShowAllReviewScreenState extends State<ShowAllReviewScreen> {
  bool _isLoading = false;
  bool _isInternetConnected = true;
  BookReviewModel? _bookReviewModel;
  String? token;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    token= context.read<UserProvider>().UserToken;
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
      _callReviewAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          toolbarHeight: _height * 0.07,
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.black,
            ),
          ),
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
                  Text(
                    widget.bookName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: Constants.fontfamily,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              child: IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>GiveReviewScreen()));
                  showDialog(
                    context: context,
                    barrierDismissible:
                    true, // set to false if you want to force a rating
                    builder: (context) => Dialogue(context),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              width: 5.0,
            )
          ],
        ),
        body: _isInternetConnected == false
            ? SafeArea(
          child: Center(
            child:  Column(
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
          ),
        )
            : _isLoading
            ? const Align(
            alignment: Alignment.center,
            child: const Center(
              child: CupertinoActivityIndicator(
              ),
            )
        )
            : _bookReviewModel!.data.length==0
            ?  Center(
              child: Text(
                  Languages.of(context)!.noReview,
                  style:
                  TextStyle(
                    color: Colors
                        .black,
                    fontFamily:
                    Constants
                        .fontfamily,
                  )),
            )
            : ListView.builder(
            itemCount: _bookReviewModel!.data.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, index) {
              return GFListTile(
                  color: Colors.black12,
                  avatar: GFAvatar(
                    // backgroundColor: Colors.bl,
                    backgroundImage:
                    NetworkImage(_bookReviewModel!
                        .data[index].profilePhoto
                        .toString()),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _bookReviewModel!.data[index].username
                          .toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: Constants.fontfamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                  subTitleText: _bookReviewModel!
                      .data[index].comment
                      .toString(),
                  icon: Column(
                    children: [
                      const Icon(
                        Icons.star_rate,
                        color: Colors.amberAccent,
                      ),
                      // Text(
                      //   _bookReviewModel!.data[index].status
                      //       .toString(),
                      //   style: const TextStyle(
                      //     fontFamily: Constants.fontfamily,
                      //   ),
                      // ),
                    ],
                  )
              );
            }));
  }

  Future _callReviewAPI() async {
    setState(() {
      _isLoading = true;
      _isInternetConnected = true;
    });

    var map =  Map<String, dynamic>();
    map['book_id'] =  widget.bookId.toString();

    final response = await http.post(
      Uri.parse(ApiUtils.SEE_ALL_REVIEWS_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
      body: map,
    );

    if (response.statusCode == 200) {
      print('book_review_response under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      var jsonData1 = response.body;
      if (jsonData['status'] == 200) {
        _bookReviewModel = bookReviewModelFromJson(jsonData1);
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget Dialogue(var context){
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  RatingDialog(
      title:  Text(
        widget.bookName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: Constants.fontfamily,
        ),
      ),
      image:  Container(
        height:_height*0.15,
        width: _width*0.1,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(widget.bookImage),
            fit: BoxFit.fitHeight
          ),
        ),
      ),
      submitButtonText: 'Submit',
      commentHint: ' Write Comment Here ',
      onCancelled: () => print('cancelled'),
      starColor: Colors.yellow,
      // starSize: 0.0,
      onSubmitted: (response) {
        _addCommentAPI(response.comment,context);
         print('rating: ${response.rating}, comment: ${response.comment}');

      },
    );
  }

  Future _addCommentAPI(String comments,var context) async {
    setState(() {
      _isLoading = true;
      _isInternetConnected = true;
    });
    var map =  Map<String, dynamic>();
    map['book_id'] =  widget.bookId.toString();
    map['comment'] = comments.toString().trim();
    final response = await http.post(
      Uri.parse(
          ApiUtils.ADD_REVIEW_API),
      headers: {
        'Authorization': "Bearer $token",
      },
      body: map,
    );

    if (response.statusCode == 200) {
      print('review_response under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      if(jsonData['status'] == 200)
      {
        Constants.showToastBlack(context, "Thanks! for Review");
        setState(() {
          _callReviewAPI();
        });
      }else{
        ToastConstant.showToast(context,jsonData['message'].toString());
      }

    } else {
      print("error_occur");

    }
  }
}

