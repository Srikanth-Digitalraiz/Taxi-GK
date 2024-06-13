import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apiconstants.dart';
import '../../constants/color_contants.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/rental_fare_plan.dart';
import '../../widgets/loder_dialg.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';
import '../home/home_screen.dart';

class CancelRideOptions extends StatefulWidget {
  String reqID;
  CancelRideOptions({Key? key, required this.reqID}) : super(key: key);

  @override
  State<CancelRideOptions> createState() => _CancelRideOptionsState();
}

enum CancelReason {
  reason1,
  reason2,
  reason3,
  reason4,
  reason5,
  reason6,
  reason7
}

class _CancelRideOptionsState extends State<CancelRideOptions> {
  //Cancel Reason
  CancelReason mainReason = CancelReason.reason1;
  //Cancel Reason
  int val = 1;
  String reason = "Expected shorter wait time";
  //Cancel Reason
  Future cancelRides(context, reason) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String apiUrl = cancelRide;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": widget.reqID, "cancel_reason": reason},
    );
    // Fluttertoast.showToast(
    //     msg: reason! +
    //         " " +
    //         response.statusCode.toString() +
    //         " " +
    //         widget.reqID);

    // print(userId);
    if (response.statusCode == 200) {
      setState(() {
        fareType = "15";
        rentalFarePlan = "";
        dropadd = "";
      });

      // Navigator.pushReplacement(
      // context,
      // MaterialPageRoute(
      //   builder: (context) => const HomeScreen(),
      // ));
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Material(
      //       elevation: 3,
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       child: Container(
      //         height: 60,
      //         decoration: BoxDecoration(
      //             color: secondaryColor, borderRadius: BorderRadius.circular(10)),
      //         child: Center(child: Text(jsonDecode(response.body))),
      //       ),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // );
      // Fluttertoast.showToast(msg: response.body.toString());

      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 412) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        color: whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 4,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: secondaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  "Are you sure? You want to cancel the ride request",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "MonM",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                RadioListTile(
                    title: const Text(
                      "Expected shorter wait time",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: CancelReason.reason1,
                    groupValue: mainReason,
                    activeColor: secondaryColor,
                    onChanged: (CancelReason? value) async {
                      setState(() {
                        mainReason = value!;
                        reason = "Expected shorter wait time";
                        val = 1;
                      });
                    }),
                RadioListTile(
                    title: const Text(
                      "Driver denied duty on phone call",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: CancelReason.reason2,
                    groupValue: mainReason,
                    activeColor: secondaryColor,
                    onChanged: (CancelReason? value) async {
                      setState(() {
                        mainReason = value!;
                        reason = "Driver denied duty on phone call";
                        val = 2;
                      });
                    }),
                RadioListTile(
                    title: const Text(
                      "Driver not wearing mask",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: CancelReason.reason3,
                    groupValue: mainReason,
                    activeColor: secondaryColor,
                    onChanged: (CancelReason? value) async {
                      setState(() {
                        mainReason = value!;
                        reason = "Driver not wearing mask";
                        val = 3;
                      });
                    }),
                RadioListTile(
                    title: const Text(
                      "Driver looked unwell",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: CancelReason.reason4,
                    groupValue: mainReason,
                    activeColor: secondaryColor,
                    onChanged: (CancelReason? value) async {
                      setState(() {
                        mainReason = value!;
                        reason = "Driver looked unwell";
                        val = 4;
                      });
                    }),
                RadioListTile(
                    title: const Text(
                      "Car not sanitized/ UnHygenic",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: CancelReason.reason5,
                    groupValue: mainReason,
                    activeColor: secondaryColor,
                    onChanged: (CancelReason? value) async {
                      setState(() {
                        mainReason = value!;
                        reason = "Car not sanitized/ UnHygenic";
                        val = 5;
                      });
                    }),
                RadioListTile(
                    title: const Text(
                      "My reason is not listed.",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: CancelReason.reason6,
                    groupValue: mainReason,
                    activeColor: secondaryColor,
                    onChanged: (CancelReason? value) async {
                      setState(() {
                        mainReason = value!;
                        reason = "My reason is not listed.";
                        val = 6;
                      });
                    }),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () async {
                        String reason = val == 1
                            ? "Expected shorter wait time"
                            : val == 2
                                ? "Driver denied duty on phone call"
                                : val == 3
                                    ? "Driver not wearing mask"
                                    : val == 4
                                        ? "Driver looked unwell"
                                        : val == 5
                                            ? "Car not sanitized/ UnHygenic"
                                            : "My reason is not listed.";
                        if (val == -1) {
                          Fluttertoast.showToast(
                              msg:
                                  "Please select your reason for cancellation...");
                        } else {
                          showLoaderDialog(
                              context, "Cancelling your Request", 15);
                          cancelRides(context, reason);
                        }
                      },
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.4,
                        child: const Center(
                          child: Text(
                            "Cancel Ride",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'MonS',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
