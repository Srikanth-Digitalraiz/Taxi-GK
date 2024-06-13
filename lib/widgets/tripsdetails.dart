import 'dart:convert';

import 'package:custom_clippers/custom_clippers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constants/apiconstants.dart';
import '../global/data/user_data.dart';
import '../global/dropdetails.dart';
import '../global/fare_type.dart';
import '../global/rental_fare_plan.dart';
import '../screens/auth/loginscreen.dart';
import '../screens/auth/new_auth/login_new.dart';
import '../screens/auth/new_auth/new_auth_selected.dart';
import '../screens/home/home_screen.dart';

class TripDetails extends StatefulWidget {
  final String tripID,
      map,
      id,
      mode,
      fare,
      paidFare,
      locationFAddress,
      locationTAddress,
      startTime,
      reachedTime,
      driverImage,
      driverName,
      driverContact,
      vehicleName,
      vehicleDes,
      date,
      time,
      driverRate,
      vehicleNumber,
      vehicleImage,
      cancelledby,
      tripType,
      serviceType;

  TripDetails(
      {Key? key,
      required this.map,
      required this.id,
      required this.mode,
      required this.tripID,
      required this.fare,
      required this.paidFare,
      required this.locationFAddress,
      required this.locationTAddress,
      required this.startTime,
      required this.reachedTime,
      required this.driverImage,
      required this.driverName,
      required this.driverContact,
      required this.vehicleName,
      required this.vehicleDes,
      required this.date,
      required this.time,
      required this.driverRate,
      required this.vehicleNumber,
      required this.vehicleImage,
      required this.cancelledby,
      required this.tripType,
      required this.serviceType})
      : super(key: key);

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final TextEditingController _invoiceController =
      TextEditingController(text: userEmail);

  Future<List> hitEmailInvoice(context, id, email) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userID = _sharedData.getString('personid');
    String? userToken = _sharedData.getString('maintoken');
    String apiUrl = emailIn;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"booking_id": id, "email": email},
    );
    // print(userId);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      // String message = jsonDecode(response.body)['Messaga'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Material(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "Invoice has been sent to the provided mail",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      setState(() {
        fareType = "15";
        rentalFarePlan = "";
        dropadd = "";
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      EasyLoading.dismiss();
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 412) {
      EasyLoading.dismiss();
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      EasyLoading.dismiss();
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      EasyLoading.dismiss();
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  Future getServiceName(context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userID = _sharedData.getString('personid');
    String? userToken = _sharedData.getString('maintoken');
    String apiUrl = serviceNa;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"id": widget.serviceType},
    );
    // print(userId);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NewAuthSelection(),
      //     ),
      //     (route) => false);
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
        ),
      );
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.cancelledby != "NONE" ? Colors.red : secondaryColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: widget.cancelledby != "NONE" ? Colors.red : whiteColor,
        titleSpacing: 0,
        iconTheme: IconThemeData(
            color: widget.cancelledby != "NONE" ? Colors.white : Colors.black),
        title: Builder(builder: (context) {
          var date = widget.date;

          var date1 = Jiffy(date).yMMMMd;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date1,
                          style: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 15,
                            color: widget.cancelledby != "NONE"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.tripID,
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 11,
                            color: widget.cancelledby != "NONE"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 15,
                      color: widget.cancelledby != "NONE"
                          ? Colors.white
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.map,
                fit: BoxFit.cover,
              ),
            ),
            ClipPath(
              clipBehavior: Clip.hardEdge,
              clipper: MultipleRoundedPointsClipper(Sides.bottom,
                  numberOfPoints: 25, heightOfPoint: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            widget.driverImage == null
                                ? Image.asset(
                                    'assets/icons/driver.png',
                                    height: 50,
                                    width: 50,
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'http://ondeindia.com/storage/app/public/' +
                                                  widget.driverImage),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.driverName,
                                    style: TextStyle(
                                      fontFamily: 'MonM',
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_half_outlined,
                                        size: 15,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        widget.driverRate,
                                        style: TextStyle(
                                          fontFamily: 'MonM',
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: widget.cancelledby != "NONE"
                                          ? Colors.red
                                          : secondaryColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.tripType,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: 'MonB',
                                        fontSize: 12,
                                        letterSpacing: 1.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                widget.serviceType == ""
                                    ? Container()
                                    : Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: widget.cancelledby != "NONE"
                                                ? Colors.red
                                                : secondaryColor),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FutureBuilder(
                                              future: getServiceName(context),
                                              builder: (context,
                                                  AsyncSnapshot snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container(
                                                    height: 3,
                                                    width: 40,
                                                    child:
                                                        LinearProgressIndicator(
                                                      color: Colors.white,
                                                      backgroundColor:
                                                          whiteColor
                                                              .withOpacity(0.3),
                                                    ),
                                                  );
                                                }
                                                return Text(
                                                    snapshot.data['AllTrips']
                                                        .toString(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontFamily: 'MonB',
                                                      fontSize: 12,
                                                      letterSpacing: 1.0,
                                                      color: Colors.white,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis);
                                              }),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      //"http://ondeindia.com/storage/app/public/"
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      'http://ondeindia.com/storage/app/public/' +
                                          widget.vehicleImage,
                                    ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.vehicleName,
                                          style: TextStyle(
                                            fontFamily: 'MonM',
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              size: 15,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Text(
                                                widget.vehicleDes,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontFamily: 'MonM',
                                                  fontSize: 12,
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  widget.vehicleNumber == ""
                                      ? Container()
                                      : Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  widget.cancelledby != "NONE"
                                                      ? Colors.red
                                                      : secondaryColor),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              widget.vehicleNumber,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontFamily: 'MonB',
                                                fontSize: 12,
                                                letterSpacing: 1.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      //"http://ondeindia.com/storage/app/public/"
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/rupee.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Text(
                              "₹ " + widget.fare + "/-",
                              style: TextStyle(
                                fontFamily: 'MonM',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.locationFAddress,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'MonM',
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                height: 30,
                                child: VerticalDivider(
                                  width: 1,
                                  color: kindaBlack,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.locationTAddress,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'MonM',
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      Text(
                        "Bill Details",
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Your Trip",
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "₹ " + widget.fare,
                            style: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Cupon Saving",
                              style: TextStyle(
                                fontFamily: 'MonR',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "- ₹ " + '0',
                            style: TextStyle(
                              fontFamily: 'MonR',
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Rounded Off",
                              style: TextStyle(
                                fontFamily: 'MonR',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            " ₹ " + '0.0',
                            style: TextStyle(
                              fontFamily: 'MonR',
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Total Bill",
                                  style: TextStyle(
                                    fontFamily: 'MonS',
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                " ₹ " + widget.fare,
                                style: TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            "Includes  ₹0.0 Taxes",
                            style: TextStyle(
                              fontFamily: 'MonR',
                              fontSize: 8,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         "ACF Donation",
                      //         style: TextStyle(
                      //           fontFamily: 'MonR',
                      //           fontSize: 13,
                      //           color: Colors.black,
                      //         ),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //     Text(
                      //       " ₹ " + '1',
                      //       style: TextStyle(
                      //         fontFamily: 'MonR',
                      //         fontSize: 13,
                      //         color: Colors.black,
                      //       ),
                      //       overflow: TextOverflow.ellipsis,
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         "Insurance Premium",
                      //         style: TextStyle(
                      //           fontFamily: 'MonR',
                      //           fontSize: 13,
                      //           color: Colors.black,
                      //         ),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //     Text(
                      //       " ₹ " + '2',
                      //       style: TextStyle(
                      //         fontFamily: 'MonR',
                      //         fontSize: 13,
                      //         color: Colors.black,
                      //       ),
                      //       overflow: TextOverflow.ellipsis,
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //   child: Divider(),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         "Total Payable",
                      //         style: TextStyle(
                      //           fontFamily: 'MonS',
                      //           fontSize: 17,
                      //           color: Colors.black,
                      //         ),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //     Text(
                      //       " ₹ " + widget.fare,
                      //       style: TextStyle(
                      //         fontFamily: 'MonS',
                      //         fontSize: 17,
                      //         color: Colors.black,
                      //       ),
                      //       overflow: TextOverflow.ellipsis,
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 15,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Payment",
                        style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.mode,
                              style: TextStyle(
                                fontFamily: 'MonM',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: secondaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                " ₹ " + widget.fare + " /-",
                                style: TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            widget.cancelledby != "NONE"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: whiteColor),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RichText(
                              maxLines: 2,
                              text: TextSpan(
                                text: "This ride was cancelled by ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'MonR',
                                ),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: widget.cancelledby == "PROVIDER"
                                        ? "Driver"
                                        : "You",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'MonB',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        " ... That's the reason you wont be able to request InVoice",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontFamily: 'MonR',
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                : Container(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: whiteColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Thank you for using OndeIndia 😀",
                  style: TextStyle(
                    fontFamily: 'MonR',
                    fontSize: 10,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            widget.cancelledby != "NONE"
                ? Container()
                : Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                          // secondaryColor.withOpacity(0.2),
                          Color(0xFFEAE3D2).withOpacity(0.4),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: _invoiceSheet(),
                            );
                          },
                        );
                        // Fluttertoast.showToast(msg: "Invoice");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 17,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Email Me Invoice",
                            style: TextStyle(
                              fontFamily: 'MonM',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _invoiceSheet() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 15),
      child: ClipPath(
        clipBehavior: Clip.hardEdge,
        clipper: MultipleRoundedPointsClipper(Sides.vertical,
            numberOfPoints: 20, heightOfPoint: 15),
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: whiteColor,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Please Enter your Email Address in the below provided text field",
                          style: TextStyle(
                            fontFamily: 'MonM',
                            fontSize: 15,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "*You will be recieving your invoice on the email address you enter below...",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 12,
                            // fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: whiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/icons/email_invoice.png',
                                height: 80, width: 80),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(Icons.email_outlined,
                                    size: 15, color: Colors.white),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                      controller: _invoiceController,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "MonM"),
                                      decoration: InputDecoration.collapsed(
                                        hintText: "Enter Email",
                                        hintStyle: TextStyle(
                                            color: kindaBlack.withOpacity(0.7),
                                            fontFamily: "MonR",
                                            fontSize: 12),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Email Address...";
                                        }
                                        return EmailValidator.validate(value)
                                            ? null
                                            : "Please enter valid email address";
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async {
                              String _email = _invoiceController.text;
                              if (_formKey.currentState!.validate()) {
                                EasyLoading.show();
                                await hitEmailInvoice(
                                    context, widget.id, _email);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please fill required email.");
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Send Invoice",
                                  style: TextStyle(
                                    fontFamily: 'MonR',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*

 */
