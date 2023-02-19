import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:credit_card_form/credit_card_form.dart';
// import 'package:credit_card_scanner/credit_card_scanner.dart';
// import 'package:credit_card_scanner/models/card_details.dart';
// import 'package:credit_card_scanner/models/card_scan_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/MixScreens/StripePayment/scan_option_config_widget.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import 'package:http/http.dart' as http;
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';
import '../BookDetailsAuthor.dart';
import 'CardScanner.dart';

class StripePayment extends StatefulWidget {
  String bookId;
   StripePayment({Key? key,required this.bookId}) : super(key: key);

  @override
  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  // CardDetails? _cardDetails;
  // CardScanOptions scanOptions = const CardScanOptions(
  //   scanCardHolderName: true,
  //   enableLuhnCheck: false,
  //   enableDebugLogs: true,
  //   scanExpiryDate: true,
  //   validCardsToScanBeforeFinishingScan: 5,
  //   possibleCardHolderNamePositions: [
  //     CardHolderNameScanPosition.aboveCardNumber,
  //   ],
  // );
  //
  // Future<void> scanCard() async {
  //   final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
  //   if ( !mounted || cardDetails == null ) return;
  //   setState(() {
  //     _cardDetails = cardDetails;
  //   });
  // }
  bool _isLoading = false;
  bool _isInternetConnected = true;
  String? cardNumber;
  String? cardHolderName;
  String? expMonth;
  String? expYear;
  String? cvV;
  String? amount= "3";

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color(0xffebf6f9),
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
      ),
      body:SafeArea(
        child: Column(
          children: [
            SizedBox(height: _height*0.03,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CreditCardForm(
                theme: CreditCardDarkTheme(),
                onChanged: (CreditCardResult result) {

                  cardNumber=result.cardNumber;
                  cardHolderName=result.cardHolderName;
                  expMonth=result.expirationMonth;
                  expYear=result.expirationYear;
                  cvV=result.cvc;

                  print(result.cardNumber);
                  print(result.cardHolderName);
                  print(result.expirationMonth);
                  print(result.expirationYear);
                  print(result.cardType);
                  print(result.cvc);
                },
              ),
            ),
            SizedBox(height: _height*0.2,),
            Container(
              margin: EdgeInsets.only(top: _height * 0.03),
              child: ResuableMaterialButtonSmall(
                onpress: () {
                  if(cardHolderName!.isNotEmpty && cardNumber!.isNotEmpty && expMonth!.isNotEmpty &&
                  expYear!.isNotEmpty && cvV!.isNotEmpty){
                    _checkInternetConnection();
                  }else{
                    Constants.showToastBlack(context, "Please fill all the Fields with Correct information");
                  }

                },
                buttonname: Languages.of(context)!.Subscribe,
              ),
            ),
            Visibility(
               visible: _isLoading,
               child : Padding(
                 padding:  EdgeInsets.only(top: _height*0.1),
                 child: const Center(
              child: CupertinoActivityIndicator(),
            ),
               )),
            // Container(
            //   margin: EdgeInsets.only(top: _height * 0.03),
            //   child: ResuableMaterialButtonSmall(
            //     onpress: () {
            //       scanCard();
            //     },
            //     buttonname: Languages.of(context)!.scan,
            //   ),
            // ),
            SizedBox(),
          ],
        ),
      ),
    );
  }

  Future StripeApiCall() async {

    var map = Map<String, dynamic>();
    map['cardno'] = cardNumber;
    map['month'] = expMonth;
    map['year'] = expYear;
    map['cvv'] = cvV;
    map['amount'] = amount;
    map['payment_method'] = "1";
    map['name'] = cardHolderName;
    final response =
    await http.post(Uri.parse(ApiUtils.STRIPE_PAYMENT_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
      body: map
    );

    if (response.statusCode == 200) {
      print('payment_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        Subscribe();
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future Subscribe() async {

    var map = Map<String, dynamic>();
    map['amount'] = amount;

    final response =
    await http.post(Uri.parse(ApiUtils.USER_SUBSCRIPTION_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
        body: map
    );

    if (response.statusCode == 200) {
      print('subscribe_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        Transitioner(
          context: context,
          child: BookDetailAuthor(bookID: widget.bookId,),
          animation: AnimationType
              .slideLeft, // Optional value
          duration: Duration(
              milliseconds: 1000), // Optional value
          replacement: false, // Optional value
          curveType:
          CurveType.decelerate, // Optional value
        );
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
      StripeApiCall();
    }
  }
}
