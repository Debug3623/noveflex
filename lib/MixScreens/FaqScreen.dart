import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Provider/UserProvider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
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
          title: Text(Languages.of(context)!.faq,
              style: const TextStyle(
                  color: const Color(0xff2a2a2a),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Alexandria",
                  fontStyle: FontStyle.normal,
                  fontSize: 14.0),
              textAlign: TextAlign.left),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: 368,
              height: 694,
              margin: EdgeInsets.all(_width*0.1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: const Color(0xffebf5f9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Languages.of(context)!.joinUs,
                      style: const TextStyle(
                          color: const Color(0xff676767),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Alexandria",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  SizedBox(height: _height*0.02,),
                  Text(
                      Languages.of(context)!.faqText_long,
                      style: const TextStyle(
                          color: const Color(0xff676767),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Alexandria",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0),
                      textAlign: TextAlign.left),
                  SizedBox(height: _height*0.04,),
                  context.read<UserProvider>().SelectedLanguage ==
                      "English" ? Container(
                    height: _height*0.3,
                    width: _width*0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage("assets/quotes_data/faq_image_english_1.jpeg"),
                        fit: BoxFit.cover
                      )
                    ),
                  ) : Container(
                    height: _height*0.3,
                    width: _width*0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage("assets/quotes_data/faq_image_arabic.jpeg"),
                            fit: BoxFit.cover
                        )
                    ),
                  ) ,
                  SizedBox(height: _height*0.04,),
                  Text(
                       Languages.of(context)!.faqText_long_1,
                        style: const TextStyle(
                            color: const Color(0xff676767),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Alexandria",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.left),
                  SizedBox(height: _height*0.04,),
                  GestureDetector(
                    onTap: (){
                      _launchUrl();
                    },
                    child: Center(
                      child: Container(
                        height: _height*0.05,
                        width: _width*0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          color: Colors.black12

                        ),
                        child: Center(
                          child: Text(Languages.of(context)!.readerMore,
                            style: const TextStyle(
                                color:  const Color(0xff2a2a2a),
                                fontWeight: FontWeight.w700,
                                fontFamily: "Alexandria",
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _launchUrl() async {
    var url = Uri.parse("https://novelflex.com/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
