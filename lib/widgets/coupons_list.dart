import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/global/data/user_data.dart';

import '../constants/apiconstants.dart';

Color white = Colors.white;
Color black = Colors.black;

class Couponscreen extends StatefulWidget {
  String zoneIDS;
  Couponscreen({Key? key, required this.zoneIDS});

  @override
  State<Couponscreen> createState() => _CouponscreenState();
}

class _CouponscreenState extends State<Couponscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.show();
    getCouppnsSec();
  }

  List couponsLi = [];

  Future getCouppnsSec() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.MultipartRequest('POST', Uri.parse(promoCodesAPI));
    request.fields.addAll({'admin_id': adminId, 'zone_id': widget.zoneIDS});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        couponsLi = decodedMap['data'];
      });
    } else {
      EasyLoading.dismiss();
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F0F5),
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          "Coupon Codes",
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 15,
            color: black,
          ),
        ),
      ),
      body: couponsLi.isEmpty
          ? Center(child: Text("No coupons available"))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text: couponsLi[index]['promo_code'],
                        ));
                        EasyLoading.showToast(
                            "${couponsLi[index]['promo_code']}\n\ncode to clipboard");
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //         " ${couponsLi[index]['promo_code']} code to clipboard")));
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.1), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 1, // blur radius
                              offset:
                                  Offset(0, 1), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            // BoxShadow(
                            //   color: Colors.grey.withOpacity(0.2), //color of shadow
                            //   spreadRadius: 1, //spread radius
                            //   blurRadius: 1, // blur radius
                            //   offset: Offset(-1, 0), // changes position of shadow
                            //   //first paramerter of offset is left-right
                            //   //second parameter is top to down
                            // ),
                            //you can set more BoxShadow() here
                          ],
                          // color: white,
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 150,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 28.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: -45,
                                                  child: Transform.scale(
                                                    scale: 2,
                                                    child: Container(
                                                      height: 6,
                                                      // width: double.infinity,
                                                      // color: black,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                            white.withOpacity(
                                                                0.1),
                                                            white.withOpacity(
                                                                0.2)
                                                          ])),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Transform.rotate(
                                                  angle: -45,
                                                  child: Transform.scale(
                                                    scale: 2,
                                                    child: Container(
                                                      height: 3,
                                                      // width: double.infinity,
                                                      // color: black,
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                            white.withOpacity(
                                                                0.1),
                                                            white.withOpacity(
                                                                0.2)
                                                          ])),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: -60,
                                          bottom: 2,
                                          right: 2,
                                          top: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 22.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      color: Color(0xFFF1F0F5)),
                                                ),
                                                Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      color: Color(0xFFF1F0F5)),
                                                ),
                                                Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      color: Color(0xFFF1F0F5)),
                                                ),
                                                Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      color: Color(0xFFF1F0F5)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: RotatedBox(
                                              quarterTurns: -1,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  '${couponsLi[index]['discount']}% OFF',
                                                  style: TextStyle(
                                                      color: white,
                                                      fontFamily: 'MonS',
                                                      fontSize: 22),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      // width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  couponsLi[index]
                                                      ['promo_code'],
                                                  style: TextStyle(
                                                      color: Color(0xff379237),
                                                      fontFamily: 'MonS',
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  'Copy',
                                                  style: TextStyle(
                                                      color: black,
                                                      fontFamily: 'MonS',
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Save ${couponsLi[index]['discount']}% off on applying this code',
                                              style: TextStyle(
                                                  color: Colors.blue.shade800,
                                                  fontFamily: 'MonM',
                                                  fontSize: 15),
                                            ),
                                            // Divider(
                                            //   color: black.withOpacity(0.2),
                                            // ),
                                            Text(
                                              "Turn 'PAYLESS' into 'MORE FUN' - Travel with zest using our ${couponsLi[index]['promo_code']} coupon code for boundless adventures!",
                                              maxLines: 3,
                                              style: TextStyle(
                                                  color: black.withOpacity(0.4),
                                                  fontFamily: 'MonR',
                                                  fontSize: 11),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
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
                    ),
                  );
                },
                itemCount: couponsLi.length,
              ),
            ),
    );
  }
}
