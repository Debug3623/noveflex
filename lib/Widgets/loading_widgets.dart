import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
class CustomCard extends StatelessWidget {
  final MoreLoadingGif? gif;
  final String? text;
  const CustomCard({Key? key, this.gif, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Container(
      height: _height*0.15,
      width: _width*0.3,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
            begin:
            Alignment(-0.01018629550933838, -0.01894212305545807),
            end: Alignment(1.6960868120193481, 1.3281718730926514),
            colors: [
              Color(0xff246897),
              Color(0xff1b4a6b),



            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          gif!,
          Text(text!,
              style: const TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Alexandria",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.right)
        ],
      ),
    );
  }
}