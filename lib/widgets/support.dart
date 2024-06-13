import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color_contants.dart';

class Support extends StatefulWidget {
  Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  //What's App Launch

  void launchWhatsApp({
    @required int? phone,
    @required String? message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message!)}";
      } else {
        return "https://send?phone=$phone&text=${Uri.parse(message!)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  void launchDialer({
    @required int? phone,
  }) async {
    if (await canLaunch("tel: $phone")) {
      await launch("tel: $phone");
    } else {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return _customerSupport(context);
  }

  _customerSupport(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 300,
              child: _support()),
        ),
      ),
    );
  }

  Widget _support() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "custcar".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Lottie.asset(
                'assets/animation/customercare.json',
                height: 200,
                width: 200,
              ),
            ),
          ),
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextButton(
                        onPressed: () {
                          launchDialer(phone: 9866600720);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_outlined,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "call".tr,
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 12,
                                color: whiteColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextButton(
                        onPressed: () {
                          launchWhatsApp(
                              message: "query".tr, phone: 9866600720);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_outlined,
                              color: whiteColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "whatsapp".tr,
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 12,
                                color: whiteColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
