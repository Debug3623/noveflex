import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../Models/BoolAllPdfViewModelClass.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../localization/Language/languages.dart';
import '../pdfViewerScreen.dart';

class BookAllPDFViewSceens extends StatefulWidget {
  String bookId;
  String bookName;
  String readerId;
   BookAllPDFViewSceens({Key? key,required this.bookId,required this.bookName,required this.readerId}) : super(key: key);

  @override
  State<BookAllPDFViewSceens> createState() => _BookAllPDFViewSceensState();
}

class _BookAllPDFViewSceensState extends State<BookAllPDFViewSceens> {
  BoolAllPdfViewModelClass? _boolAllPdfViewModelClass;
  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          backgroundColor: const Color(0xffebf5f9),
          title: Text(widget.bookName.toString(),
            style: const TextStyle(
                color:  const Color(0xff2a2a2a),
                fontWeight: FontWeight.bold,
                fontFamily: "Neckar",
                fontStyle:  FontStyle.normal,
                fontSize: 20.0
            ),),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              )),
        ),
        body: SafeArea(
          child: _isInternetConnected
              ? _isLoading
              ? const Align(
            alignment: Alignment.center,
            child: CupertinoActivityIndicator(),
          )
              :_boolAllPdfViewModelClass!.data!.length==0 ? Center(
                child: Text(
                  Languages.of(context)!
                      .nodata,
                  style: const TextStyle(
                      fontFamily: Constants.fontfamily,
                      color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ): Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount:
                  _boolAllPdfViewModelClass!.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PdfScreen(
                        //           url: _boolAllPdfViewModelClass!
                        //               .data[index]
                        //               .lessonPath,
                        //           name: _boolAllPdfViewModelClass!
                        //               .data[index].lesson.toString(),
                        //         )));

                        // PdfScreen()));
                      },
                      child: Container(

                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 0.5,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0)),
                            ),
                            color: Color(0xFF256D85)),
                        width: _width * 0.9,
                        height: _height * 0.08,
                        margin: EdgeInsets.only(
                            left: _width * 0.02,
                            right: _width * 0.02,
                            top: _height * 0.05),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            _boolAllPdfViewModelClass!.data
                                .length ==
                                0
                                ? const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0),
                                child: Text(
                                    'No PDF Found',
                                    style: TextStyle(
                                      color: const Color(0xffebf5f9),
                                      fontFamily:
                                      Constants
                                          .fontfamily,
                                    )),
                              ),
                            )
                                : Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0),
                                child: Text(
                                   _boolAllPdfViewModelClass!.data[index].lesson.toString(),
                                   style: const TextStyle(
                                    color:  Colors.white,
                                    fontSize: 18,
                                    fontFamily: Constants
                                        .fontfamily,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                  textAlign:
                                  TextAlign.center,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                },
                                icon: const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          )
              : Center(
            child: Text("No Internet Connection!"),
          ),
        ));
  }

  Future AllChaptersApiCall() async {
    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookId.toString();
    final response =
    await http.post(Uri.parse(ApiUtils.ALL_CHAPTERS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
    body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _boolAllPdfViewModelClass = boolAllPdfViewModelClassFromJson(jsonData);

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

  Future BookViewApi() async {
    var map = Map<String, dynamic>();
    map['book_id'] = widget.bookId.toString();
    map['reader_id'] = widget.readerId.toString();
    final response =
    await http.post(Uri.parse(ApiUtils.BOOK_VIEW_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
        body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {

        print("book_view_by_user");

      } else {
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
      AllChaptersApiCall();
      BookViewApi();
    }
  }
}
