import 'package:flutter/material.dart';

import '../constants/color_contants.dart';

showLoaderDialog(BuildContext context, String text, int delay) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(
          color: primaryColor,
          backgroundColor: kindaBlack,
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 7),
          child: Text(
            text,
            style: TextStyle(fontFamily: "MonM", fontSize: 10),
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: delay), () {
        Navigator.pop(context);
      });
      return alert;
    },
  );
}
