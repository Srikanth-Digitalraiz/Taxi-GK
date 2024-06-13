import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/global/wallet.dart';
import 'package:ondeindia/screens/auth/new_auth/new_auth_selected.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/apiconstants.dart';
import '../../global/couponcode.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/out/out.dart';
import '../../global/rental_fare_plan.dart';
import '../../global/ride/ride_details.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';

class RideCompleted extends StatefulWidget {
  final String rideID;
  RideCompleted({Key? key, required this.rideID}) : super(key: key);

  @override
  State<RideCompleted> createState() => _RideCompletedState();
}

class _RideCompletedState extends State<RideCompleted> {
  var value = 3.0;
  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAmountDividend(context);
  }

  String cashes = '';
  String waDaes = '';
  String totFaes = '';

  Future getAmountDividend(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String apiUrl = ridCha;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": widget.rideID, "admin_id": adminId},
    );

    print("Booking Response: ---->" + response.body);

    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: widget.rideID);
      String cashs = jsonDecode(response.body)['rides'][0]
              ['collect_cash_amount']
          .toString();
      String waDas = jsonDecode(response.body)['rides'][0]
              ['collect_wallet_amount']
          .toString();
      String totFas =
          jsonDecode(response.body)['rides'][0]['ride_amount'].toString();

      setState(() {
        cashes = cashs;
        waDaes = waDas;
        totFaes = totFas;
      });

      // return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
    } else if (response.statusCode == 412) {
    } else if (response.statusCode == 500) {
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
    } else if (response.statusCode == 403) {}
    throw 'Exception';
  }

  Future<List> postUserRating(
      String rideID, String ratingCount, String driverComment, context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? userID = _token.getString('personid');
    String apiUrl = userRate;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"rating": ratingCount, "comment": driverComment, "id": rideID},
    );

    // print(userId);
    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Feedback submitted");
      // Fluttertoast.showToast(msg: ratingCount);
      Navigator.pop(context);
      // Fluttertoast.showToast(msg: "Your rating have been submitted");
      setState(() {
        coupon = "";
        serviceID = "";
        serviceTime = "";
        serviceName = "";
        fareType = '15';
        out = false;
        selectedOutPlan = 0;
        selectedOutName = 'One Way';
        paymentMode = 'CASH';

        fareType = "15";
        rentalFarePlan = "";
        dropadd = "";
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: jsonDecode(response.body).toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      Fluttertoast.showToast(msg: jsonDecode(response.body).toString());
    } else if (response.statusCode == 412) {
      Fluttertoast.showToast(msg: jsonDecode(response.body).toString());
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: jsonDecode(response.body).toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      Fluttertoast.showToast(msg: jsonDecode(response.body).toString());
    } else if (response.statusCode == 403) {
      Fluttertoast.showToast(msg: jsonDecode(response.body).toString());
    }
    throw 'Exception';
  }

  screenhome() {
    setState(() {
      coupon = "";
      serviceID = "";
      serviceTime = "";
      serviceName = "";
      fareType = '15';
      out = false;
      selectedOutPlan = 0;
      selectedOutName = 'One Way';
      paymentMode = 'CASH';
    });

    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return screenhome();
      },
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 10.0),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cash to be given",
                        maxLines: 1,
                        style: const TextStyle(
                          color: kindaBlack,
                          fontSize: 15,
                          fontFamily: 'MonM',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Text(
                        "₹ " + cashes + "/-",
                        maxLines: 1,
                        style: const TextStyle(
                          color: kindaBlack,
                          fontSize: 17,
                          fontFamily: 'MonB',
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 5,
                            width: 30,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Amount Debited: ",
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: kindaBlack,
                                      fontSize: 15,
                                      fontFamily: 'MonM',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "₹ " + waDaes + "/-",
                                  // snap.data['walletDebit'].toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: kindaBlack,
                                    fontSize: 15,
                                    fontFamily: 'MonB',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total Fare: ",
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: kindaBlack,
                                      fontSize: 15,
                                      fontFamily: 'MonM',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  "₹ " + totFaes + "/-",
                                  // snap.data['walletDebit'].toString(),
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: kindaBlack,
                                    fontSize: 15,
                                    fontFamily: 'MonB',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("Rate your Ride"),
                          SizedBox(height: 10),
                          Center(
                            child: RatingStars(
                              value: value,
                              onValueChanged: (v) {
                                //
                                setState(() {
                                  value = v;
                                });
                              },
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 30,
                              valueLabelColor: const Color(0xff9b9b9b),
                              valueLabelTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              valueLabelRadius: 10,
                              maxValue: 5,
                              starSpacing: 2,
                              maxValueVisibility: true,
                              valueLabelVisibility: true,
                              animationDuration: Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              valueLabelMargin: const EdgeInsets.only(right: 8),
                              starOffColor: const Color(0xffe7e8ea),
                              starColor: Colors.orange,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 15.0),
                            child: TextFormField(
                              maxLines: 10,
                              controller: _commentController,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                              // ],
                              decoration: InputDecoration(
                                hintText: 'Hi! Rider was polite...',
                                hintStyle: const TextStyle(
                                  fontFamily: 'MonR',
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                label: const Text("Comment"),
                                labelStyle: const TextStyle(
                                    fontFamily: 'MonS',
                                    fontSize: 13,
                                    color: primaryColor),
                                suffixIcon: const Icon(
                                  Icons.mobile_screen_share,
                                  color: primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      const BorderSide(color: Colors.teal),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 18.0, top: 12),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextButton(
                                  onPressed: () async {
                                    showLoaderDialog(
                                        context, "Submitting...", 100);
                                    String driverComment =
                                        _commentController.text;

                                    var rateValue =
                                        value.toString().split('.').toString();

                                    await postUserRating(
                                        widget.rideID,
                                        rateValue[1].toString(),
                                        driverComment,
                                        context);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => TestMap(),
                                    //   ),
                                    // );
                                    // TestMap
                                  },
                                  child: Center(
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(
                                        fontFamily: 'MonM',
                                        fontSize: 15,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
