import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';
import '../Models/AuthorProfileModelEdit.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../localization/Language/languages.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AuthorProfileEditModel? _authorProfileEditModel;
  bool _isLoading = false;
  bool _UploadLoading = false;
  bool _isInternetConnected = true;
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneNumberController;
  File? imageFile;

  @override
  void initState() {
    _checkInternetConnection();
    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _phoneNumberController = new TextEditingController();
    super.initState();
  }


  @override
  void dispose() {
    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _phoneNumberController = new TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
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
      body: SafeArea(
        child: _isInternetConnected
            ? _isLoading
                ? const Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: (){
                                  _getFromGallery();
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: _height * 0.2,
                                      child:  Center(
                                        child: CircleAvatar(
                                          radius: _width*_height*0.00015,
                                          backgroundImage: imageFile == null ? NetworkImage(
                                            _authorProfileEditModel!.data![0]!.imagePath.toString()
                                          ) : AssetImage(imageFile!.path) as ImageProvider,
                                          // child: Icon(
                                          //   Icons.person_pin,
                                          //   size: _height*_width*0.0004,
                                          //   color: Colors.white,
                                          // ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: _width * 0.55,
                                      top: _height * 0.12,
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                color: const Color(0xffebf5f9),
                                child: Column(
                                  children: [
                                    Text(
                                      (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .UserName!),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    Text(
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .UserEmail!,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: const Color(0xff676767),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Alexandria",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _height * 0.03,
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                              width: 427.5,
                              height: 1,
                              decoration: BoxDecoration(
                                  color: const Color(0xffbcbcbc))),
                        ),
                        SizedBox(
                          height: _height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: _width * 0.02, right: _width * 0.02),
                          height: _height * 0.07,
                          width: _width * 0.95,
                          child: TextFormField(
                            // key: _bookTitleKey,
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // labelText: widget.labelText,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: _width * 0.02, right: _width * 0.02),
                          height: _height * 0.07,
                          width: _width * 0.95,
                          child: TextFormField(
                            // key: _bookTitleKey,
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // labelText: widget.labelText,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.03,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: _width * 0.02, right: _width * 0.02),
                          height: _height * 0.07,
                          width: _width * 0.95,
                          child: TextFormField(
                            // key: _bookTitleKey,
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // labelText: widget.labelText,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xFF256D85)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {

                              EDIT_PROFILE_Api();

                          },
                          child: Container(
                            width: 320,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xff3a6c83),
                                  width: 2,
                                )),
                            child: Center(
                              child: Text(
                                Languages.of(context)!.update,
                                style: const TextStyle(
                                    color: const Color(0xff3a6c83),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.03,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDeleteDialog();
                          },
                          child: Container(
                            width: 320,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: const Color(0xff3a6c83),
                                  width: 2,
                                )),
                            child: Center(
                              child: Text(
                                Languages.of(context)!.DeleteAccount,
                                style: const TextStyle(
                                    color: const Color(0xff3a6c83),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _height*0.03,),
                        Visibility(
                          visible: _UploadLoading==true,
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              color: const Color(0xFF256D85),
                              radius: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: Text("No Internet Connection!"),
              ),
      ),
    );
  }

  void showDeleteDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.DeleteAccount,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
            Languages.of(context)!.deleteAccountText,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  Languages.of(context)!.yes,
                  style: TextStyle(fontFamily: Constants.fontfamily),
                ),
                onPressed: ()async{

                  DELETE_PROFILE_Api();
                  Navigator.of(context).pop();


                }),
            CupertinoDialogAction(
              child: Text(
                Languages.of(context)!.no,
                style: TextStyle(fontFamily: Constants.fontfamily),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future ProfileApiCall() async {
    final response =
        await http.get(Uri.parse(ApiUtils.PROFILE_AUTHOR_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('profile_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _authorProfileEditModel = authorProfileEditModelFromJson(jsonData);
        setState(() {
          _isLoading = false;
        });

        _nameController!.text= _authorProfileEditModel!.data![0]!.username.toString();
        _emailController!.text= _authorProfileEditModel!.data![0]!.email.toString();
        _phoneNumberController!.text= _authorProfileEditModel!.data![0]!.phone.toString();
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
      ProfileApiCall();
    }
  }

  Future<void> EDIT_PROFILE_Api() async {

    setState(() {
      _UploadLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };

    var request = http.MultipartRequest('POST',
        Uri.parse(ApiUtils.EDIT_PROFILE_));

    request.fields['username'] = _nameController!.text.trim();
    request.fields['email'] = _emailController!.text.trim();
    request.fields['phone'] = _phoneNumberController!.text.trim();
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'image',imageFile!.path,
        contentType: MediaType('application', 'pdf')
    );


    request.files.add(multipartFile);
    request.headers.addAll(headers);
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var  jsonData = json.decode(response.body);
          if(jsonData['status'] == 200){
            print("multiple  books Uploaded! ");
            print('edit_response ' + response.body);
            setState(() {
              _UploadLoading = false;

            });
            ToastConstant.showToast(context, jsonData['data'] );
            Transitioner(
              context: context,
              child: TabScreen(),
              animation: AnimationType.fadeIn, // Optional value
              duration: Duration(milliseconds: 1000), // Optional value
              replacement: true, // Optional value
              curveType: CurveType.decelerate, // Optional value
            );
          }else{
            ToastConstant.showToast(context, jsonData['data'] );
          }


        }
      });
    });

  }

  Future<void> DELETE_PROFILE_Api() async {

    setState(() {
      _UploadLoading = true;
    });
    final response = await http.get(
      Uri.parse(ApiUtils.DELETE_ACCOUNT_PROFILE_API),
      headers: {
        'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      },
    );

    if (response.statusCode == 200) {
      print('delete_profile_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        setState(() {
          _UploadLoading = false;
        });
        UserProvider userProvider =
        Provider.of<UserProvider>(this.context, listen: false);

        userProvider.setUserToken("");
        userProvider.setUserEmail("");
        userProvider.setUserName("");
        userProvider.setLanguage("");
        Phoenix.rebirth(context);

      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _UploadLoading = false;
        });
      }
    }
  }

  _getFromGallery() async {
    final PickedFile? image =
    await ImagePicker().getImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile = File(image.path);
      setState(() {
        imageFile = File(image.path);
      });
    }
  }
}
