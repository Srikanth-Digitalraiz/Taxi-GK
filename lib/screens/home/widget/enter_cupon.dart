import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/maineta.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/apiconstants.dart';
import '../../../global/data/user_data.dart';
import '../../../global/distance.dart';
import '../../../global/fare_type.dart';
import '../../../global/out/out_pack.dart';
import '../../../global/pickup_location.dart';
import '../../../global/promocode.dart';
import '../../../global/rental_fare_plan.dart';
import '../../../widgets/coupons_list.dart';
import '../../auth/loginscreen.dart';
import '../../auth/new_auth/login_new.dart';
import '../../auth/new_auth/new_auth_selected.dart';
import '../Ride Confirm/pick_n_drop.dart';

class cuponCode extends StatefulWidget {
  cuponCode({Key? key}) : super(key: key);

  @override
  State<cuponCode> createState() => _cuponCodeState();
}

class _cuponCodeState extends State<cuponCode> {
  TextEditingController _coupon = TextEditingController();

  Future<List> getServicesLis(context, eta, promo, dropA) async {
    // await Future.delayed(Duration(minutes: 10));
    SharedPreferences _token = await SharedPreferences.getInstance();
    double tottalDistance = distance + distance;
    var date1 = mainReturnDate.split(' ');
    DateTime date = DateTime.now();
    String date2 = selectedDate == ""
        ? DateFormat('yy-MM-dd').format(date)
        : DateFormat('yy-MM-dd').format(DateTime.parse(selectedDate));

    String? userToken = _token.getString('maintoken');
    String apiUrl = estimatedFare;

    // Fluttertoast.showToast(
    //     msg:
    // "New Delayed Hit $dropLat    $dropLong   $pickAdd     $dropA  $distance     $eta $scDate $scTime $rentalFarePlan $fareType $date2 ${date1[0]} $promoCode");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "s_latitude": pickLat.toString(),
        "s_longitude": pikLong.toString(),
        "d_latitude": dropLat.toString(),
        "d_longitude": dropLong.toString(),
        's_address': pickAdd.toString(),
        'd_address': dropA.toString(),
        'distance': distance.toStringAsFixed(4),
        "schedule_date": scDate,
        "schedule_time": scTime,
        "fare_plan": rentalFarePlan.toString(),
        "fare_type": fareType.toString(),
        "eta": eta.toString(),
        "current_date": date2,
        "return_date": date1[0] == "" ? date2 : date1[0].toString(),
        "fareplan": fareType == "16"
            ? selectedOutName == "Round Trip"
                ? "Round Trip"
                : "One Way"
            : "",
        "promo_code": promo
      },
    );

    // print(
    //     "It's a hit promo==========> $pickLat $pikLong $dropLat $dropLong $pickAdd $dropA $distance $scDate $scTime $rentalFarePlan $fareType $eta $date2 $date2 $promo");

    if (response.statusCode == 200) {
      // print("Data--->" +
      //     jsonDecode(response.body)['Serivces'][0]['estimated_fare']
      //         .toString());
      // print();
      SharedPreferences _zi = await SharedPreferences.getInstance();

      _zi.setString("couZID", jsonDecode(response.body)['zone_id'].toString());

      setState(() {
        serviceLis = jsonDecode(response.body)['Serivces'];
      });
      promo == ""
          ? null
          : Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);

      Navigator.pop(context);

      return jsonDecode(response.body)['Serivces'];
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
      return jsonDecode(response.body)['Serivces'];
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 412) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
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
      height: 210,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: secondaryColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Enter Coupon Code",
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryColor.withOpacity(0.5),
                      fontFamily: "MonS",
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences _dyz =
                        await SharedPreferences.getInstance();
                    String? zonD = _dyz.getString("couZID");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Couponscreen(zoneIDS: zonD!)),
                    );
                  },
                  child: Text(
                    "Available Coupons",
                    style: TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                      fontFamily: "MonS",
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: whiteColor,
                    border: Border.all(color: secondaryColor.withOpacity(0.1))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                  child: TextFormField(
                    enabled: true,
                    controller: _coupon,
                    autofillHints: const [AutofillHints.email],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontFamily: "MonM",
                      letterSpacing: 1.0,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: "Enter Coupon",
                      hintStyle: TextStyle(
                          letterSpacing: 1.0,
                          color: kindaBlack.withOpacity(0.3),
                          fontFamily: "MonR",
                          fontSize: 12),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.grey.withOpacity(0.5)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),

                          // side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryColor,
                                fontFamily: "MonM",
                                letterSpacing: 1.0,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),

                          // side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_coupon.text == "") {
                        Fluttertoast.showToast(
                            msg: "Please enter promocode before applying");
                      } else {
                        setState(() {
                          promoCode = _coupon.text;
                        });
                        if (promoCode != "") {
                          getServicesLis(context, mainETA, promoCode, dropadd);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Apply',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryColor,
                                fontFamily: "MonM",
                                letterSpacing: 1.0,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
