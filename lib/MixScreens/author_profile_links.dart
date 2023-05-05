import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/Constants.dart';
import '../localization/Language/languages.dart';

class AddAuthorProfileLinks extends StatefulWidget {
  const AddAuthorProfileLinks({Key? key}) : super(key: key);

  @override
  State<AddAuthorProfileLinks> createState() => _AddAuthorProfileLinksState();
}

class _AddAuthorProfileLinksState extends State<AddAuthorProfileLinks> {
  final _fbFocusNode = new FocusNode();
  final _ybFocusNode = new FocusNode();
  final _IsFocusNode = new FocusNode();
  final _twFocusNode = new FocusNode();
  final _tkFocusNode = new FocusNode();

  final _fbKey = GlobalKey<FormFieldState>();
  final _ybKey = GlobalKey<FormFieldState>();
  final _IsKey = GlobalKey<FormFieldState>();
  final _twKey = GlobalKey<FormFieldState>();
  final _tkKey = GlobalKey<FormFieldState>();

  TextEditingController _fbController= TextEditingController();
  TextEditingController _ybController= TextEditingController();
  TextEditingController _IsController= TextEditingController();
  TextEditingController _twController= TextEditingController();
  TextEditingController _tkController= TextEditingController();


  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
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
        title: Text(
          Languages.of(context)!.linksText,
            style: const TextStyle(
                color:  const Color(0xff2a2a2a),
                fontWeight: FontWeight.w700,
                fontFamily: "Alexandria",
                fontStyle:  FontStyle.normal,
                fontSize: 14.0
            ),
            textAlign: TextAlign.left
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  height: _height*0.12,
                  width: _width*0.15,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/quotes_data/fb_icon.png")
                    )
                  ),
                ),
                Container(
                  width: _width*0.8,
                  child: TextFormField(
                    key: _fbKey,
                    controller: _fbController,
                    focusNode: _fbFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    // onFieldSubmitted: (_) {
                    //   FocusScope.of(context)
                    //       .requestFocus(_ybFocusNode);
                    // },
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
                            color: Colors.white12,
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
                        hintText: Languages.of(context)!.fbLink,
                        // labelText: Languages.of(context)!.email,
                        hintStyle: const TextStyle(
                          fontFamily: Constants.fontfamily,
                        )),
                  ),
                ),
                SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  height: _height*0.12,
                  width: _width*0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/quotes_data/yb_icon.png")
                      )
                  ),
                ),
                Container(
                  width: _width*0.8,
                  child: TextFormField(
                    key: _ybKey,
                    controller: _ybController,
                    focusNode: _ybFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_ybFocusNode);
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
                            color: Colors.white12,
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
                        hintText: Languages.of(context)!.ybLink,
                        // labelText: Languages.of(context)!.email,
                        hintStyle: const TextStyle(
                          fontFamily: Constants.fontfamily,
                        )),
                  ),
                ),
                SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  height: _height*0.12,
                  width: _width*0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/quotes_data/insta_icon.png")
                      )
                  ),
                ),
                Container(
                  width: _width*0.8,
                  child: TextFormField(
                    key: _IsKey,
                    controller: _IsController,
                    focusNode: _IsFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_IsFocusNode);
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
                            color: Colors.white12,
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
                        hintText: Languages.of(context)!.insLink,
                        // labelText: Languages.of(context)!.email,
                        hintStyle: const TextStyle(
                          fontFamily: Constants.fontfamily,
                        )),
                  ),
                ),
                SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  height: _height*0.12,
                  width: _width*0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/quotes_data/tw_icon.png")
                      )
                  ),
                ),
                Container(
                  width: _width*0.8,
                  child: TextFormField(
                    key: _twKey,
                    controller: _twController,
                    focusNode: _twFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_tkFocusNode);
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
                            color: Colors.white12,
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
                        hintText: Languages.of(context)!.twLink,
                        // labelText: Languages.of(context)!.email,
                        hintStyle: const TextStyle(
                          fontFamily: Constants.fontfamily,
                        )),
                  ),
                ),
                SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Container(
                  height: _height*0.12,
                  width: _width*0.15,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/quotes_data/tk_icon.png")
                      )
                  ),
                ),
                Container(
                  width: _width*0.8,
                  child: TextFormField(
                    key: _tkKey,
                    controller: _tkController,
                    focusNode: _tkFocusNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
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
                            color: Colors.white12,
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
                        hintText: Languages.of(context)!.tkLink,
                        // labelText: Languages.of(context)!.email,
                        hintStyle: const TextStyle(
                          fontFamily: Constants.fontfamily,
                        )),
                  ),
                ),
                SizedBox(),
              ],
            ),
            SizedBox(
              height: _height*0.03,
            ),
            GestureDetector(
              onTap: () {

              },
              child: Container(
                width: _width*0.9,
                height: _height*0.065,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(25)
                      ),
                      boxShadow: [BoxShadow(
                          color: const Color(0x24000000),
                          offset: Offset(0,7),
                          blurRadius: 14,
                          spreadRadius: 0
                      )] ,
                      color: const Color(0xff3a6c83)
                  ),
                child: Center(
                  child: Text(
                    Languages.of(context)!.saved,
                    style: const TextStyle(
                        color:  Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _height*0.08,
            ),
            Visibility(
              visible:  false,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
