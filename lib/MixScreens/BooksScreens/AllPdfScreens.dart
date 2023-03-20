import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:transitioner/transitioner.dart';
import '../../Models/BoolAllPdfViewModelClass.dart';
import '../../Models/subscriptionModelClass.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/constant.dart';
import '../../Utils/native_dialog.dart';
import '../../Utils/store_config.dart';
import '../../Utils/toast.dart';
import '../../localization/Language/languages.dart';
import '../InAppPurchase/paywall.dart';
import '../InAppPurchase/singletons_data.dart';
import '../StripePayment/StripePayment.dart';
import '../pdfViewerScreen.dart';

class BookAllPDFViewSceens extends StatefulWidget {
  String bookId;
  String bookName;
  String readerId;
  String PaymentStatus;
  BookAllPDFViewSceens(
      {Key? key,
      required this.bookId,
      required this.bookName,
      required this.readerId,
      required this.PaymentStatus})
      : super(key: key);

  @override
  State<BookAllPDFViewSceens> createState() => _BookAllPDFViewSceensState();
}

class _BookAllPDFViewSceensState extends State<BookAllPDFViewSceens> {
  BoolAllPdfViewModelClass? _boolAllPdfViewModelClass;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  SubscriptionModelClass? _subscriptionModelClass;
  Offerings? offerings;

  @override
  void initState() {
    _checkInternetConnection();
    initPlatformState();
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
          title: Text(
            "${widget.bookName.toString()} ${Languages.of(context)!.episodes}",
            style: const TextStyle(
                color: const Color(0xff2a2a2a),
                fontWeight: FontWeight.bold,
                fontFamily: "Neckar",
                fontStyle: FontStyle.normal,
                fontSize: 15.0),
          ),
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
                  : _boolAllPdfViewModelClass!.data.length == 0
                      ? Center(
                          child: Text(
                            Languages.of(context)!.nodata,
                            style: const TextStyle(
                                fontFamily: Constants.fontfamily,
                                color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              top: _height * 0.02,
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _boolAllPdfViewModelClass!.data.length,
                           itemBuilder: (BuildContext context, int index){
                             return GestureDetector(
                               onTap: () {
                                 switch (_boolAllPdfViewModelClass!.data[index].pdfStatus) {
                                   case 1 :
                                   //All chapters Api for free books
                                     Transitioner(
                                       context: context,
                                       child: PdfScreen(
                                         url: _boolAllPdfViewModelClass!
                                             .data[index].lessonPath,
                                         name: _boolAllPdfViewModelClass!
                                             .data[index].lesson
                                             .toString(),
                                       ),
                                       animation: AnimationType
                                           .slideTop, // Optional value
                                       duration: Duration(
                                           milliseconds:
                                           1000), // Optional value
                                       replacement: false, // Optional value
                                       curveType: CurveType
                                           .decelerate, // Optional value
                                     );
                                     break;
                                   case 2:
                                     if (widget.readerId ==
                                         context
                                             .read<UserProvider>()
                                             .UserID
                                             .toString()) {
                                       //paid book but this is the author of this book
                                       Transitioner(
                                         context: context,
                                         child: PdfScreen(
                                           url: _boolAllPdfViewModelClass!
                                               .data[index].lessonPath,
                                           name: _boolAllPdfViewModelClass!
                                               .data[index].lesson
                                               .toString(),
                                         ),
                                         animation: AnimationType
                                             .slideTop, // Optional value
                                         duration: Duration(
                                             milliseconds:
                                             1000), // Optional value
                                         replacement: false, // Optional value
                                         curveType: CurveType
                                             .decelerate, // Optional value
                                       );
                                     } else {
                                       if (_subscriptionModelClass!.success ==
                                           true) {
                                         //Reader or Author Already Subscribe
                                         Transitioner(
                                           context: context,
                                           child: PdfScreen(
                                             url: _boolAllPdfViewModelClass!
                                                 .data[index].lessonPath,
                                             name: _boolAllPdfViewModelClass!
                                                 .data[index].lesson
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
                                         if (Platform.isIOS) {
                                           SubscribeFunction(
                                               _boolAllPdfViewModelClass!
                                                   .data[index].lessonPath,
                                               _boolAllPdfViewModelClass!
                                                   .data[index].lesson
                                                   .toString());
                                         } else {
                                           Transitioner(
                                             context: context,
                                             child: StripePayment(
                                               bookId: widget.bookId,
                                             ),
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
                                         }
                                       }
                                     }
                                     break;
                                   default:
                                     Constants.showToastBlack(context,
                                         "server busy please try again");
                                     break;
                                 }
                               },
                               child: Padding(
                                 padding:
                                 EdgeInsets.all(_height * 0.008),
                                 child: Column(
                                   children: [
                                     Opacity(
                                       opacity : 0.20000000298023224,
                                       child:   Container(
                                           width: 368,
                                           height: 0.5,
                                           decoration: BoxDecoration(
                                               color: const Color(0xff3a6c83)
                                           )
                                       ),
                                     ),
                                     ListTile(
                                       title: _boolAllPdfViewModelClass!.data[index].lesson==null ? Text("${index+1}. ${widget.bookName}",
                                         style: const TextStyle(
                                             color:  const Color(0xff2a2a2a),
                                             fontWeight: FontWeight.w500,
                                             fontFamily: "Alexandria",
                                             fontStyle:  FontStyle.normal,
                                             fontSize: 16.0
                                         ),): Text("$index. ${_boolAllPdfViewModelClass!.data[index].lesson.toString()}",
                                         style: const TextStyle(
                                             color:  const Color(0xff2a2a2a),
                                             fontWeight: FontWeight.w500,
                                             fontFamily: "Alexandria",
                                             fontStyle:  FontStyle.normal,
                                             fontSize: 16.0
                                         ),),
                                       subtitle: Text(DateFormat.yMd('en-IN').format(_boolAllPdfViewModelClass!.data[index].createdAt),
                                       style: TextStyle(
                                         fontSize: 12
                                       ),),
                                       trailing: _boolAllPdfViewModelClass!.data[index].pdfStatus == 1 ?  Column(
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         children: [
                                           Icon(Icons.label_important_outline,color: Colors.red),
                                           Text(Languages.of(context)!.free1,style: TextStyle(
                                             fontSize: 12
                                           ),)
                                         ],
                                       )  :  Column(
                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                                         children: [
                                           Icon(Icons.lock_outline,color: Colors.red,),
                                           Text(Languages.of(context)!.premium1 ,style: TextStyle(
                                               fontSize: 12
                                           ),)
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             );
                           },
                          ),
                        )
              : Center(
                  child: Text("No Internet Connection!"),
                ),
        ));
  }

  Future AllChaptersApiCall() async {
    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookId.toString();
    final response = await http.post(Uri.parse(ApiUtils.ALL_CHAPTERS_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _boolAllPdfViewModelClass = boolAllPdfViewModelClassFromJson(jsonData);
        CHECK_SUBSCRIPTION();
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
    final response = await http.post(Uri.parse(ApiUtils.BOOK_VIEW_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        print("book_view_by_user");
      } else {}
    }
  }

  Future CHECK_SUBSCRIPTION() async {
    final response = await http
        .get(Uri.parse(ApiUtils.USER_CHECK_SUBSCRIPTION_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('subscription_status_response${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        _subscriptionModelClass = SubscriptionModelClass.fromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData['message'].toString());
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
      AllChaptersApiCall();
      BookViewApi();
    }
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey!)
        ..appUserID = null
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey!)
        ..appUserID = null
        ..observerMode = false;
    }
    await Purchases.configure(configuration);

    appData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      (customerInfo.entitlements.all[entitlementID] != null &&
              customerInfo.entitlements.all[entitlementID]!.isActive)
          ? appData.entitlementIsActive = true
          : appData.entitlementIsActive = false;
      // print("Ios subscribtion status ${ customerInfo.entitlements.all[entitlementID]!.isActive}");
      // setState(() {});
    });
  }

  void SubscribeFunction(var lessonPath, var lessonName) async {
    setState(() {
      _isLoading = true;
    });

    // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // //check purchase done or not
    // // if("user_already_paid_and_offer_time is not end"==true){
    // //   //Call pdf Api
    // //   print("purchase_already_done");
    // // }
    //
    // if (customerInfo.entitlements.all[entitlementID] != null &&
    //     customerInfo.entitlements.all[entitlementID]!.isActive == true) {
    //   // appData.currentData = WeatherData.generateData();
    //   //check purchase done or not
    //   //Call pdf Api
    //   print("purchase_already_done");
    //
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
    if (_subscriptionModelClass!.success == true) {
      //call book pdf api
      Transitioner(
        context: context,
        child: PdfScreen(
          url: lessonPath,
          name: lessonName,
        ),
        animation: AnimationType.slideTop, // Optional value
        duration: Duration(milliseconds: 1000), // Optional value
        replacement: false, // Optional value
        curveType: CurveType.decelerate, // Optional value
      );
    } else {
      try {
        offerings = await Purchases.getOfferings();
        print("offers_revenue cat ${offerings?.all.toString()}");
      } on PlatformException catch (e) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: "Error Try Again",
                content: e.message.toString(),
                buttonText: 'OK'));
      }

      setState(() {
        _isLoading = false;
      });

      if (offerings!.current == null) {
        // offerings are empty, show a message to your user
        Constants.showToastBlack(context, "Nothing to Pay");
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings!.current!,
              );
            });
          },
        );
      }
    }
  }
}
