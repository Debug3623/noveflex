import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:provider/provider.dart';
import '../../Models/GiftAmountModel.dart';
import '../../Models/UserPaymentModel.dart';
import '../../Models/UserWithDrawPaymentModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  UserPaymentModel? _userPaymentModel;
  UserWithDrawPaymentModel? _userWithDrawPaymentModel;
  GiftAmountModel? _giftAmountModel;
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
      appBar: AppBar(
        backgroundColor: const Color(0xff3a6c83),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(Languages.of(context)!.myWallet,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
      ),
      body: _isInternetConnected
          ? _isLoading
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      height: _height * 0.5,
                      width: _width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                        color: const Color(0xff3a6c83),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: _height * 0.3,
                            width: _width * 0.8,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                  "assets/quotes_data/master_card.png"),
                            )),
                          ),
                          SizedBox(
                            height: _height * 0.1,
                          ),
                          Text(
                            Languages.of(context)!.bank1,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(Languages.of(context)!.bank2,
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    Container(
                      height: _height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          Container(
                            height: _height * 0.06,
                            width: _width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xff3a6c83),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Text(Languages.of(context)!.totalAmount,
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Alexandria",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.0),
                                    textAlign: TextAlign.left),
                                SizedBox(),
                                Container(
                                    width: _width * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white70,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "\$ ${_userPaymentModel!.totalAmount.toString()}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )),
                                SizedBox()
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.02,
                          ),
                          Visibility(
                            visible: true,
                            child: Container(
                              height: _height * 0.06,
                              width: _width * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xff3a6c83),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text(Languages.of(context)!.giftAmount,
                                      style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Alexandria",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 15.0),
                                      textAlign: TextAlign.left),
                                  SizedBox(),
                                  Container(
                                      width: _width * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white70,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "\$ ${_giftAmountModel!.totalAmount.toString()}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )),
                                  SizedBox()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.02,
                          ),
                          Container(
                            height: _height * 0.06,
                            width: _width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xff3a6c83),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Text(Languages.of(context)!.withdrawAmount,
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Alexandria",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.0),
                                    textAlign: TextAlign.left),
                                SizedBox(),
                                Container(
                                    width: _width * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white70,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "\$ ${_userWithDrawPaymentModel!.totalAmount.toString()}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )),
                                SizedBox()
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
          : Center(
              child: Constants.InternetNotConnected(_height * 0.03),
            ),

      // floatingActionButton:  FloatingActionButton(
      // onPressed: () {
      //   ToastConstant.showToast(context, "You can collect Payment when Your subscribers reached 50");
      // },
      // child: const Icon(Icons.add),
      //   backgroundColor:Color(0xFF3fa7ca),
      // ),
      //
      // floatingActionButtonLocation:
      // FloatingActionButtonLocation.centerFloat,
    );
  }

  Future PaymentApiCall() async {
    final response =
        await http.get(Uri.parse(ApiUtils.USER_PAYMENT_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('user_payment_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _userPaymentModel = UserPaymentModel.fromJson(jsonData1);
        PaymentWithDrawApiCall();
      } else {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future PaymentWithDrawApiCall() async {
    final response =
        await http.get(Uri.parse(ApiUtils.USER_PAYMENT_WITHDRAW_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('user_payment_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _userWithDrawPaymentModel =
            UserWithDrawPaymentModel.fromJson(jsonData1);
        GiftedAmount();
      } else {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future GiftedAmount() async {
    final response =
    await http.get(Uri.parse(ApiUtils.GIFT_PAYMENT), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('user_payment_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _giftAmountModel =
            GiftAmountModel.fromJson(jsonData1);
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData1['success'].toString());
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
      PaymentApiCall();
    }
  }
}
