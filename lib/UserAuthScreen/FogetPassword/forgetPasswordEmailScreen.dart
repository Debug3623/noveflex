import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/forgetPasswordModelEmail.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';
import 'NewPasswordScreen.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordEmailScreen> createState() => _ForgetPasswordEmailScreenState();
}

class _ForgetPasswordEmailScreenState extends State<ForgetPasswordEmailScreen> {

  TextEditingController? _controllerEmail;
  var _emailFocusNode = new FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  var _emailKey = GlobalKey<FormFieldState>();

  ForgetPasswordModelEmail? forgetPasswordModelEmail;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: _height*0.2,),
                  Container(
                    width: _width * 0.5,
                    height: _height * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.lock,
                      color: const Color(0xff3a6c83),
                      size: _height * _width * 0.0003,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 0.03),
                    child: Text(Languages.of(context)!.resetPasswordtxt,
                        style: const TextStyle(
                            color: const Color(0xff3a6c83),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: _height * 0.03),
                      child: Text(
                          Languages.of(context)!.resetPasswordtxt2,
                          style: const TextStyle(
                              color: const Color(0xff002333),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.center)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: _width * 0.05,
                        right: _width * 0.05,
                        top: _height * 0.05),
                    child: TextFormField(
                      key: _emailKey,
                      controller: _controllerEmail,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      validator: validateEmail,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus();
                      },
                      decoration: InputDecoration(
                          errorMaxLines: 3,
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF256D85),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
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
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
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
                  Container(
                    margin: EdgeInsets.only(top: _height * 0.06),
                    child: ResuableMaterialButtonSmall(
                      onpress: () async {
                        _checkInternetConnection();

                      },
                      buttonname: Languages.of(context)!.continuebtn,
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: Padding(
                      padding: EdgeInsets.only(top: _height * 0.1),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Email';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = new RegExp(pattern);
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  Future _checkInternetConnection() async {
    // if (this.mounted) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    // }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      ToastConstant.showToast(context, "Internet Not Connected");
      // if (this.mounted) {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }
    } else {
      _callResetPassword1stAPI();
    }
  }

  Future _callResetPassword1stAPI() async {
    setState(() {
      _isLoading = true;
    });

    var map = Map<String, dynamic>();
    map['email'] = _controllerEmail!.text.trim();

    final response = await http.post(
      Uri.parse(ApiUtils.FORGET_PASSWORD_API),
      body: map,
    );

    var jsonData;

    switch (response.statusCode) {
      case 200:
      //Success

        var jsonData = json.decode(response.body);

        if (jsonData['status'] == 200) {
          forgetPasswordModelEmail = ForgetPasswordModelEmail.fromJson(jsonData);
          print('forget_response: $jsonData');
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              NewPasswordScreen(token: forgetPasswordModelEmail!.user!.accessToken.toString(),)), (Route<dynamic> route) => false);
          setState(() {
            _isLoading = false;
          });
        } else {
          ToastConstant.showToast(context, "Sorry You have not register yet!");
          setState(() {
            _isLoading = false;
          });
        }

        break;
      case 401:
        jsonData = json.decode(response.body);
        print('jsonData 401: $jsonData');
        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_401);

        break;
      case 404:
        jsonData = json.decode(response.body);
        print('jsonData 404: $jsonData');

        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_404);

        break;
      case 400:
        jsonData = json.decode(response.body);
        print('jsonData 400: $jsonData');

        ToastConstant.showToast(context, 'Email already Exist.');

        break;
      case 405:
        jsonData = json.decode(response.body);
        print('jsonData 405: $jsonData');
        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_405);

        break;
      case 422:
      //Unprocessable Entity
        jsonData = json.decode(response.body);
        print('jsonData 422: $jsonData');

        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_422);
        break;
      case 500:
        jsonData = json.decode(response.body);
        print('jsonData 500: $jsonData');

        ToastConstant.showToast(context, ToastConstant.ERROR_MSG_500);

        break;
      default:
        jsonData = json.decode(response.body);
        print('jsonData failed: $jsonData');

        ToastConstant.showToast(context, "Login Failed Try Again");
    }

    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
