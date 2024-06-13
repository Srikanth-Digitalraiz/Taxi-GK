import 'dart:convert';

import 'package:custom_clippers/custom_clippers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/auth/new_auth/new_auth_selected.dart';
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../constants/apiconstants.dart';
import '../global/dropdetails.dart';
import '../global/fare_type.dart';
import '../global/rental_fare_plan.dart';
import '../screens/auth/loginscreen.dart';
import '../screens/auth/new_auth/login_new.dart';
import '../screens/bookride/cancel_ride_opt.dart';
import '../screens/home/home_screen.dart';

class UpComingDetail extends StatefulWidget {
  final String tripID,
      map,
      fare,
      bookID,
      locationFAddress,
      locationTAddress,
      scheduledTime,
      scheduledDate,
      driverImage,
      driverName,
      driverContact,
      vehicleName,
      vehicleDes,
      driverRate,
      vehicleNumber,
      vehicleImage;

  UpComingDetail(
      {Key? key,
      required this.map,
      required this.tripID,
      required this.bookID,
      required this.fare,
      required this.locationFAddress,
      required this.locationTAddress,
      required this.scheduledTime,
      required this.scheduledDate,
      required this.driverImage,
      required this.driverName,
      required this.driverContact,
      required this.vehicleName,
      required this.vehicleDes,
      required this.driverRate,
      required this.vehicleNumber,
      required this.vehicleImage})
      : super(key: key);

  @override
  State<UpComingDetail> createState() => _UpComingDetailState();
}

class _UpComingDetailState extends State<UpComingDetail> {
  final TextEditingController _invoiceController = TextEditingController();

  bool _value = false;
  int val = -1;

  Future cancelRides(context, reason) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String apiUrl = cancelRide;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": widget.bookID, "cancel_reason": reason},
    );
    setState(() {
      fareType = "15";
      rentalFarePlan = "";
      dropadd = "";
    });
    // Fluttertoast.showToast(
    //     msg: response.statusCode.toString() +
    //         "\n" +
    //         reason +
    //         "\n" +
    //         widget.bookID);
    // print(userId);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      //   (route) => false,
      // );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Material(
      //       elevation: 3,
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       child: Container(
      //         height: 60,
      //         decoration: BoxDecoration(
      //             color: primaryColor, borderRadius: BorderRadius.circular(10)),
      //         child: Center(child: Text(jsonDecode(response.body))),
      //       ),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // );
      Fluttertoast.showToast(msg: response.body.toString());

      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 412) {
      Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: whiteColor,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Builder(builder: (context) {
          var date = widget.scheduledDate;

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
                            color: Colors.black,
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
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.scheduledTime,
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
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
                      widget.driverName == ""
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/driver.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                      widget.driverName == "" ? SizedBox() : Divider(),
                      //"http://ondeindia.com/storage/app/public/"
                      widget.driverName == ""
                          ? SizedBox()
                          : Padding(
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
                                  Column(
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
                                          Text(
                                            widget.vehicleDes,
                                            style: TextStyle(
                                              fontFamily: 'MonM',
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                      widget.driverName == ""
                          ? SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "ACF Donation",
                              style: TextStyle(
                                fontFamily: 'MonR',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            " ₹ " + '1',
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Insurance Premium",
                              style: TextStyle(
                                fontFamily: 'MonR',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            " ₹ " + '2',
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Payable",
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 17,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            " ₹ " + widget.fare,
                            style: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
                              "Payable",
                              style: TextStyle(
                                fontFamily: 'MonM',
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
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
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
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                    // primaryColor.withOpacity(0.2),
                    Color(0xFFEAE3D2).withOpacity(0.4),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: CancelRideOptions(
                            reqID: widget.bookID,
                          ),
                        );
                      });
                  // showModalBottomSheet(
                  //     backgroundColor: Colors.transparent,
                  //     isScrollControlled: true,
                  //     context: context,
                  //     builder: (context) {
                  //       return Padding(
                  //         padding: MediaQuery.of(context).viewInsets,
                  //         child: _bottomCancelReason(),
                  //       );
                  //     });
                  // showModalBottomSheet<void>(
                  //   isScrollControlled: true,
                  //   backgroundColor: Colors.transparent,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return Padding(
                  //       padding: MediaQuery.of(context).viewInsets,
                  //       child: _invoiceSheet(),
                  //     );
                  //   },
                  // );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 17,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cancel Ride",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _invoiceSheet() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 25),
      child: ClipPath(
        clipBehavior: Clip.hardEdge,
        clipper: MultipleRoundedPointsClipper(Sides.vertical,
            numberOfPoints: 20, heightOfPoint: 15),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            color: primaryColor,
          ),
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
                    color: whiteColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Please Enter your Email Address in the below provided text field",
                  style: TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
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
                    color: whiteColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 15),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.email_outlined,
                            size: 15, color: Colors.grey.shade600),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _invoiceController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: "MonM"),
                            decoration: InputDecoration.collapsed(
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                  color: kindaBlack.withOpacity(0.7),
                                  fontFamily: "MonR",
                                  fontSize: 12),
                            ),
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a valid email",
                          ),
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
                          fontFamily: 'MonS',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomCancelReason() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.28,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
          color: whiteColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 13,
            ),
            Text(
              "Are you sure? You want to cancel the ride request...",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "MonS",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Expected shorter wait time"),
              leading: Radio(
                value: 1,
                groupValue: val,
                onChanged: (int? value) {
                  setState(() {
                    val = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Driver denied duty on phone call"),
              leading: Radio(
                value: 2,
                groupValue: val,
                onChanged: (int? value) {
                  setState(() {
                    val = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Driver not wearing mask"),
              leading: Radio(
                value: 3,
                groupValue: val,
                onChanged: (int? value) {
                  setState(() {
                    val = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Driver looked unwell"),
              leading: Radio(
                value: 4,
                groupValue: val,
                onChanged: (int? value) {
                  setState(() {
                    val = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("Car not sanitized/ UnHygenic"),
              leading: Radio(
                value: 5,
                groupValue: val,
                onChanged: (int? value) {
                  setState(() {
                    val = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text("My reason is not listed."),
              leading: Radio(
                value: 6,
                groupValue: val,
                onChanged: (int? value) {
                  setState(() {
                    val = value!;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
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
                          msg: "Please select your reason for cancellation...");
                    } else {
                      showLoaderDialog(context, "Cancelling your Request", 15);
                      await cancelRides(context, reason);
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
    );
  }
}

/*

 */
