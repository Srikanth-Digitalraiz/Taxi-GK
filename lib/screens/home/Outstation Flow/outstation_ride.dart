import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/global/promocode.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/ride_edit/drop_edit.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/ride_edit/pickup_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:spinner_date_time_picker/spinner_date_time_picker.dart';
import 'package:http/http.dart' as http;

import '../../../constants/apiconstants.dart';
import '../../../global/admin_id.dart';
import '../../../global/data/user_data.dart';
import '../../../global/distance.dart';
import '../../../global/fare_type.dart';
import '../../../global/google_key.dart';
import '../../../global/maineta.dart';
import '../../../global/out/out_pack.dart';
import '../../../global/rental_fare_plan.dart';
import '../../../global/wallet.dart';
import '../../../repositories/tripsrepo.dart';
import '../../auth/loginscreen.dart';
import '../../auth/new_auth/login_new.dart';
import '../../auth/new_auth/new_auth_selected.dart';
import '../../bookride/bookride.dart';
import '../Ride Confirm/pick_n_drop.dart';
import '../widget/enter_cupon.dart';
import '../widget/payment_selection.dart';
import '../widget/ride_confirm.dart';

class OutStationRide extends StatefulWidget {
  OutStationRide({Key? key}) : super(key: key);

  @override
  State<OutStationRide> createState() => _OutStationRideState();
}

class _OutStationRideState extends State<OutStationRide> {
  int _selected = 0;
  int _vehicleSelected = 1;
  bool _smoke = true;
  bool _pets = false;
  bool _disabled = false;
  bool _airCondition = true;
  bool _extraLuggage = false;
  bool _child = true;
  int filterVal = 1;
  String cab = '';

  // String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _eta2();
  }

  String _id = "0";
  String _name = "";

  Future scheduleRide(context, schDate, schTime) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String apiUrl = rideRequest;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "admin_id": adminId,
        "s_latitude": pickLat.toStringAsFixed(4),
        "s_longitude": pikLong.toStringAsFixed(4),
        "d_latitude": dropLat.toStringAsFixed(4),
        "d_longitude": dropLong.toStringAsFixed(4),
        "service_type": _id.toString(),
        "distance": distance.toStringAsFixed(4),
        "use_wallet": "1",
        'payment_mode': "CASH",
        "s_address": pickAdd.toString(),
        "d_address": dropadd.toString(),
        "schedule_date": schDate.toString(),
        "schedule_time": schTime.toString(),
        "fare_plan_name": rentalFarePlan.toString(),
        "fare_type": fareType.toString(),
        "fare_setting": fare_setting_plan.toString(),
        "eta": eta.toString(),
      },
    );

    // Fluttertoast.showToast(
    //     msg: "========================>" + response.statusCode.toString());

    // Fluttertoast.showToast(
    //     msg: serviceID +
    //         "   " +
    //         pickLat.toString() +
    //         "   " +
    //         pikLong.toString() +
    //         "   " +
    //         dropLat.toString() +
    //         "   " +
    //         dropLong.toString());

    // print(userId);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Material(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: kindaBlack, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "Your Ride has been scheduled...",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

      Navigator.pop(context);

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
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  String eta = "";

  _eta() async {
    Dio dio = Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$pickLat,$pikLong&destinations=$dropLat,$dropLong&key=$gooAPIKey");
    print(response.data.toString());
    setState(() {
      eta = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    });
  }

  Future bookOutStationRide(context, serviceID, name) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String apiUrl = rideRequest;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "s_latitude": pickLat.toStringAsFixed(4),
        "s_longitude": pikLong.toStringAsFixed(4),
        "d_latitude": dropLat.toStringAsFixed(4),
        "d_longitude": dropLong.toStringAsFixed(4),
        "service_type": serviceID.toString(),
        "distance": distance.toStringAsFixed(4),
        "use_wallet": "1",
        'payment_mode': "CASH",
        "faretype": "outstation",
        "s_address": pickAdd.toString(),
        "d_address": dropadd.toString()
      },
    );

    // Fluttertoast.showToast(
    //     msg: serviceID +
    //         "   " +
    //         pickLat.toString() +
    //         "   " +
    //         pikLong.toString() +
    //         "   " +
    //         dropLat.toString() +
    //         "   " +
    //         dropLong.toString());

    // print(
    //     "---------------------------------------------> Streamed HIT <---------------------------------------------");
    // print(distance.toString() +
    //     "   " +
    //     serviceID +
    //     "   " +
    //     pickLat.toStringAsFixed(4) +
    //     "   " +
    //     pikLong.toStringAsFixed(4) +
    //     "   " +
    //     dropLat.toStringAsFixed(4) +
    //     "   " +
    //     dropLong.toStringAsFixed(4) +
    //     "   " +
    //     pickAdd.toString() +
    //     "   " +
    //     dropadd.toString());

    // print("---------------------------------------------> Status Code HIT <---------------------------------------------" +
    //     response.statusCode.toString() +
    //     "---------------------------------------------> Status Code HIT <---------------------------------------------");

    // print(
    //     "---------------------------------------------> Streamed HIT <---------------------------------------------");

    // Fluttertoast.showToast(
    //     msg: "---------------------------------------------> Status Code HIT <---------------------------------------------" +
    //         response.statusCode.toString() +
    //         "---------------------------------------------> Status Code HIT <---------------------------------------------");

    // print(userId);
    if (response.statusCode == 200) {
      String _requestID = jsonDecode(response.body)["request_id"].toString();

      _token.setString("reqID", _requestID);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookRideSection(
            serviceID: _id,
            serviceName: _name,
          ),
        ),
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
      //             color: primaryColor, borderRadius: BorderRadius.circular(10)),
      //         child: Center(child: Text(jsonDecode(response.body))),
      //       ),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // );
      // Fluttertoast.showToast(msg: "--------> REQ ID  " + _requestID);

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
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  Future<List> getServicesLis(context, eta, promo, dropA) async {
    // await Future.delayed(Duration(minutes: 10));
    SharedPreferences _token = await SharedPreferences.getInstance();
    double tottalDistance = distance + distance;
    var date1 = mainReturnDate.split(' ');
    DateTime date = DateTime.now();
    String date2 = selectedDate == ""
        ? DateFormat('yy-MM-dd').format(date)
        : DateFormat('yy-MM-dd').format(DateTime.parse(selectedDate));

    Fluttertoast.showToast(msg: date2);

    String? userToken = _token.getString('maintoken');
    String apiUrl = estimatedFare;

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

    print(
        "It's a hit==========> $pickLat $pikLong $dropLat $dropLong $pickAdd $dropA $distance $scDate $scTime $rentalFarePlan $fareType $eta $date2 $date2 $promo");
    Fluttertoast.showToast(msg: '${response.statusCode}');
    if (response.statusCode == 200) {
      // print();
      SharedPreferences _zi = await SharedPreferences.getInstance();

      _zi.setString("couZID", jsonDecode(response.body)['zone_id'].toString());
      promo == ""
          ? null
          : Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);

      setState(() {
        serviceLis = jsonDecode(response.body)['Serivces'];
      });

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
    //Book Scheduled Ride

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: Stream.periodic(
                      const Duration(seconds: 10),
                    ),
                    builder: (context, sanp) {
                      // _eta();
                      return Stack(
                        children: [
                          Container(
                            height: 90,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey
                              //         .withOpacity(0.2), //color of shadow
                              //     spreadRadius: 4, //spread radius
                              //     blurRadius: 2, // blur radius
                              //     offset: Offset(
                              //         0, 2), // changes position of shadow
                              //     //first paramerter of offset is left-right
                              //     //second parameter is top to down
                              //   ),
                              //   //you can set more BoxShadow() here
                              // ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.directions_walk,
                                        color: Colors.green,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4.0, bottom: 6.0),
                                          child: Container(
                                            child: VerticalDivider(
                                              color: Colors.black,
                                              thickness: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // scheduleRide(context);
                                        },
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0, right: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditPickUp(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              pickAdd,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'MonM',
                                                fontSize: 11,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditDropLocation(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              dropadd,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'MonM',
                                                fontSize: 11,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                _vehicleDetails()
              ],
            ),
          ),
        ),
      ],
    );
  }

  String eta2 = "";

  _eta2() async {
    Dio dio = Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$pickLat,$pikLong&destinations=$dropLat,$dropLong&key=$gooAPIKey");
    print("ETA------------------__>" + response.data.toString());
    setState(() {
      eta2 = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
      mainETA = eta2;
    });

    // Fluttertoast.showToast(msg: "Duration:- > $eta2");
    // Fluttertoast.showToast(msg: "Distance:- > " + distance.toString());
  }

  Widget _vehicleDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    "Select Ride...",
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 15,
                      color: kindaBlack,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // var date = selectedDate.toString().split(" ");
                  // var date1 = date[0].toString();
                  // var date2 = date[1].toString().split(".");
                  // var mainTime = date2[0].toString();
                  //---------
                  // showDialog(
                  //     barrierDismissible: false,
                  //     context: context,
                  //     builder: (context) {
                  //       var today = DateTime.now();
                  //       return Dialog(
                  //         child: SpinnerDateTimePicker(
                  //           initialDateTime: today,
                  //           maximumDate: today.add(const Duration(days: 7)),
                  //           minimumDate: today,
                  //           mode: CupertinoDatePickerMode.dateAndTime,
                  //           use24hFormat: true,
                  //           didSetTime: (value) {
                  //             setState(() {
                  //               selectedDate = value.toString();
                  //             });
                  //             // getServices(context, eta2, promoCode, dropadd)
                  //             getServicesLis(context, eta2, promoCode, dropadd);
                  //             // Fluttertoast.showToast(msg: "kkk");
                  //           },
                  //         ),
                  //       );
                  //     });
                  //---------
                },
                child: Container(
                  // margin: EdgeInsets.only(top: 20, right: 10),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(0, 1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.alarm,
                          size: 12,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          selectedDate == ""
                              ? "Now"
                              : selectedDate
                                  .replaceAll(RegExp(r'\.0+$'), '')
                                  .replaceAll(RegExp(r'0+$'), '')
                                  .replaceAll(RegExp(r':$'), ''),
                          style: TextStyle(
                            fontFamily: 'MonM',
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
              future: getServices(context, eta, promoCode, dropadd),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: kindaBlack,
                        color: primaryColor,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selected = index;
                              _id = snapshot.data![index]['id'].toString();
                              _name = snapshot.data![index]['name'];
                            });
                            // Fluttertoast.showToast(msg: _id + "  " + _name);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: _selected == index
                                  ? BoxDecoration(
                                      color: whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.2), //color of shadow
                                          spreadRadius: 1, //spread radius
                                          blurRadius: 1, // blur radius
                                          offset: Offset(1,
                                              1), // changes position of shadow
                                          //first paramerter of offset is left-right
                                          //second parameter is top to down
                                        ),
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.2), //color of shadow
                                          spreadRadius: 1, //spread radius
                                          blurRadius: 1, // blur radius
                                          offset: Offset(-1,
                                              -1), // changes position of shadow
                                          //first paramerter of offset is left-right
                                          //second parameter is top to down
                                        ),

                                        //you can set more BoxShadow() here
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  : BoxDecoration(
                                      color: whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.0), //color of shadow
                                          spreadRadius: 0, //spread radius
                                          blurRadius: 0, // blur radius
                                          offset: Offset(0,
                                              0), // changes position of shadow
                                          //first paramerter of offset is left-right
                                          //second parameter is top to down
                                        ),
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.0), //color of shadow
                                          spreadRadius: 0, //spread radius
                                          blurRadius: 0, // blur radius
                                          offset: Offset(0,
                                              0), // changes position of shadow
                                          //first paramerter of offset is left-right
                                          //second parameter is top to down
                                        ),

                                        //you can set more BoxShadow() here
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                              child: Padding(
                                padding: _selected == index
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 8.0)
                                    : const EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                            ),
                                            child: Stack(
                                              children: [
                                                _selected == index
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Container(
                                                          height: 30,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient: LinearGradient(
                                                                colors: [
                                                                  secondaryColor,
                                                                  secondaryColor
                                                                      .withOpacity(
                                                                          0.3),
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                tileMode:
                                                                    TileMode
                                                                        .mirror),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                snapshot.data![index]
                                                            ['vehicle_image'] ==
                                                        null
                                                    ? Image.network(
                                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Circle-icons-car.svg/1200px-Circle-icons-car.svg.png')
                                                    : Image.network(
                                                        "http://ondeindia.com/storage/app/public/" +
                                                            snapshot.data![
                                                                    index][
                                                                'vehicle_image'])
                                                // Image.network(snapshot.data![index]
                                                //             ['vehicle_image'] ==
                                                //         null
                                                //     ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Circle-icons-car.svg/1200px-Circle-icons-car.svg.png'
                                                //     : "http://ondeindia.com/storage/app/public/" +
                                                //         snapshot.data![index]
                                                //             ['vehicle_image']),
                                              ],
                                            )),
                                        SizedBox(height: 5),
                                        Text(
                                          snapshot.data![index]['eta']
                                              .toString(),
                                          style: TextStyle(
                                            color: kindaBlack,
                                            fontSize: 10,
                                            fontFamily: 'MonM',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data![index]['name']
                                                .toString(),
                                            style: TextStyle(
                                              color: secondaryColor,
                                              fontSize: 12,
                                              fontFamily: 'MonS',
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            snapshot.data![index]['description']
                                                .toString(),
                                            style: TextStyle(
                                              color:
                                                  kindaBlack.withOpacity(0.3),
                                              fontSize: 10,
                                              fontFamily: 'MonM',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showModalBottomSheet<void>(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Padding(
                                                      padding:
                                                          MediaQuery.of(context)
                                                              .viewInsets,
                                                      child: rideConfirmSection(
                                                        context,
                                                        snapshot.data![index]
                                                            ['name'],
                                                        snapshot.data![index][
                                                                'estimated_fare']
                                                            .toString(),
                                                        mainETA,
                                                        // snapshot.data![index]['dis']
                                                        //     .toString(),
                                                        snapshot.data![index][
                                                                'running_charge']
                                                            .toString(),
                                                        snapshot.data![index]
                                                            ['description'],

                                                        snapshot.data![index]
                                                            ['vehicle_image'],

                                                        snapshot.data![index]
                                                            ['waiting_charge'],
                                                        snapshot.data![index][
                                                            'service_description'],
                                                        snapshot.data![index]
                                                            ['one'],
                                                        snapshot.data![index]
                                                            ['two'],
                                                        snapshot.data![index]
                                                            ['three'],
                                                        snapshot.data![index]
                                                            ['four'],
                                                        snapshot.data![index]
                                                            ['five'],
                                                        snapshot.data![index]
                                                            ['six'],
                                                        snapshot.data![index]
                                                            ['seven'],
                                                        snapshot.data![index]
                                                            ['eight'],
                                                        snapshot.data![index]
                                                            ['seater'],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 12,
                                                width: 12,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color:
                                                      const Color(0xFFF2F6F9),
                                                ),
                                                child: const Icon(
                                                  Icons.info_outline,
                                                  size: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              snapshot.data![index]
                                                          ['final_fare'] ==
                                                      ""
                                                  ? snapshot.data![index]
                                                              ['estimated_fare']
                                                          .toString() +
                                                      " ₹"
                                                  : snapshot.data![index]
                                                              ['final_fare']
                                                          .toString() +
                                                      " ₹",
                                              style: TextStyle(
                                                color: secondaryColor,
                                                fontSize: 15,
                                                fontFamily: 'MonS',
                                              ),
                                            ),
                                          ],
                                        ),
                                        snapshot.data![index]['final_fare'] ==
                                                ""
                                            ? Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 1,
                                                    fontFamily: 'MonR',
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              )
                                            : Text(
                                                snapshot.data![index]
                                                            ['estimated_fare']
                                                        .toString() +
                                                    " ₹",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontFamily: 'MonR',
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 2, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Divider(),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: PaymentSelection(),
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            paymentMode == "WALLET"
                                                ? Icon(Icons.wallet,
                                                    color:
                                                        Colors.green.shade700)
                                                : Icon(Icons.money_outlined,
                                                    color:
                                                        Colors.green.shade700),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(paymentMode,
                                                style: TextStyle(
                                                  fontFamily: 'MonM',
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  height: 15,
                                  width: 1,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // cuponCode
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: cuponCode(),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/icons/tag.png',
                                              height: 20,
                                              width: 30,
                                              color: Colors.green.shade700),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Coupon",
                                            style: TextStyle(
                                              fontFamily: 'MonM',
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15,
                                  width: 1,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "My Self",
                                          style: TextStyle(
                                            fontFamily: 'MonM',
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //scheduleRide(context, date1, mainTime);
                            selectedDate == ""
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: Colors.black,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if (dropadd != "") {
                                          await bookOutStationRide(
                                              context, _id, _name);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please select Drop Location");
                                        }
                                        // var date = selectedDate.toString().split(" ");
                                        // var date1 = date[0].toString();
                                        // var date2 = date[1].toString().split(".");
                                        // var mainTime = date2[0].toString();
                                        // showFareDialog(context);
                                        // String rideID = snapshot.data![index]['id']
                                        // getRideFare(context, _id, _name);
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Text(
                                            "Select Ride",
                                            style: TextStyle(
                                              fontFamily: 'MonS',
                                              fontSize: 17,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
                                      color: Colors.black,
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        var date =
                                            selectedDate.toString().split(" ");
                                        var date1 = date[0].toString();
                                        var date2 =
                                            date[1].toString().split(".");
                                        var mainTime = date2[0].toString();
                                        // showFareDialog(context);
                                        // String rideID = snapshot.data![index]['id']
                                        // getRideFare(context, _id, _name);

                                        scheduleRide(context, date1, mainTime);

                                        // Fluttertoast.showToast(msg: mainTime);
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Text(
                                            "Select Ride",
                                            style: TextStyle(
                                              fontFamily: 'MonS',
                                              fontSize: 17,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
          const SizedBox(
            height: 50,
          ),
          // _carDetails()
        ],
      ),
    );
  }

  // showFareDialog(BuildContext context) {
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: Text("Cancel"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   Widget continueButton = TextButton(
  //     child: Text("Continue"),
  //     onPressed: () {},
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Ride Fare"),
  //     content: FutureBuilder(
  //         future: getRideFare(context, _id, _name),
  //         builder: (context, AsyncSnapshot snapshot) {
  //           if (!snapshot.hasData) {
  //             return CircularProgressIndicator();
  //           }
  //           return Text(
  //             snapshot.data["estimated_fare"].toString(),
  //           );
  //         }),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  Widget _carDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: const [
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       _vehicleSelected = 1;
          //     });
          //   },
          //   onDoubleTap: () {
          //     setState(() {
          //       filterVal = 2;
          //       cab = 'Mini';
          //     });
          //   },
          //   child: Material(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     elevation: _vehicleSelected == 1 ? 4 : 0,
          //     child: Container(
          //       height: 69,
          //       width: 349,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         border: Border.all(
          //             color: _vehicleSelected == 1
          //                 ? primaryColor
          //                 : Colors.transparent),
          //         color: whiteColor,
          //       ),
          //       child: Row(
          //         children: [
          //           Image.asset(
          //             'assets/vehicles/mini.png',
          //             width: 80,
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "Mini",
          //                 style: TextStyle(
          //                   fontFamily: 'MonS',
          //                   fontSize: 12,
          //                   color: kindaBlack,
          //                 ),
          //               ),
          //               const SizedBox(height: 6),
          //               Text(
          //                 "4 seaters",
          //                 style: TextStyle(
          //                   fontFamily: 'MonR',
          //                   fontSize: 10,
          //                   color: kindaBlack.withOpacity(0.6),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const Spacer(),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 8.0),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.end,
          //               children: [
          //                 Row(
          //                   children: [
          //                     InkWell(
          //                       onTap: () {
          //                         showModalBottomSheet<void>(
          //                           isScrollControlled: true,
          //                           backgroundColor: Colors.transparent,
          //                           shape: RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(20),
          //                           ),
          //                           context: context,
          //                           builder: (BuildContext context) {
          //                             return Padding(
          //                               padding:
          //                                   MediaQuery.of(context).viewInsets,
          //                               child: rideConfirmSection(
          //                                   context,
          //                                   "mini",
          //                                   "200",
          //                                   "Kukatpally",
          //                                   "Madhapur"),
          //                             );
          //                           },
          //                         );
          //                       },
          //                       child: Container(
          //                         height: 20,
          //                         width: 20,
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(50),
          //                           color: const Color(0xFFF2F6F9),
          //                         ),
          //                         child: const Icon(
          //                           Icons.info_outline,
          //                           size: 15,
          //                         ),
          //                       ),
          //                     ),
          //                     const SizedBox(
          //                       width: 5,
          //                     ),
          //                     const Text(
          //                       "₹ 185.00",
          //                       style: TextStyle(
          //                         fontFamily: 'MonS',
          //                         fontSize: 15,
          //                         color: primaryColor,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 6),
          //                 const Text(
          //                   "₹ 220.00",
          //                   style: TextStyle(
          //                     fontFamily: 'MonR',
          //                     fontSize: 7,
          //                     color: kindaBlack,
          //                     decoration: TextDecoration.lineThrough,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           // const SizedBox(
          //           //   width: 5,
          //           // ),
          //           // _vehicleSelected == 1
          //           //     ? Expanded(
          //           //         child: Container(
          //           //           decoration: const BoxDecoration(
          //           //             borderRadius: BorderRadius.only(
          //           //                 topRight: Radius.circular(15),
          //           //                 bottomRight: Radius.circular(15)),
          //           //             color: primaryColor,
          //           //           ),
          //           //           height: 69,
          //           //           width: 45,
          //           //           child: Column(
          //           //             mainAxisAlignment: MainAxisAlignment.center,
          //           //             children: [
          //           //               Icon(Icons.filter_alt_outlined,
          //           //                   color: whiteColor),
          //           //               const Text(
          //           //                 "Filter",
          //           //                 style: TextStyle(
          //           //                   fontFamily: 'MonR',
          //           //                   fontSize: 10,
          //           //                   color: whiteColor,
          //           //                 ),
          //           //               ),
          //           //             ],
          //           //           ),
          //           //         ),
          //           //       )
          //           //     : Container()
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 12,
          // ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       _vehicleSelected = 2;
          //     });
          //   },
          //   onDoubleTap: () {
          //     setState(() {
          //       filterVal = 2;
          //       cab = 'SUV';
          //     });
          //   },
          //   child: Material(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     elevation: _vehicleSelected == 2 ? 4 : 0,
          //     child: Container(
          //       height: 69,
          //       width: 349,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         border: Border.all(
          //             color: _vehicleSelected == 2
          //                 ? primaryColor
          //                 : Colors.transparent),
          //         color: whiteColor,
          //       ),
          //       child: Row(
          //         children: [
          //           Image.asset(
          //             'assets/vehicles/suv.png',
          //             width: 80,
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "SUV",
          //                 style: TextStyle(
          //                   fontFamily: 'MonS',
          //                   fontSize: 12,
          //                   color: kindaBlack,
          //                 ),
          //               ),
          //               const SizedBox(height: 6),
          //               Text(
          //                 "8 seaters",
          //                 style: TextStyle(
          //                   fontFamily: 'MonR',
          //                   fontSize: 10,
          //                   color: kindaBlack.withOpacity(0.6),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const Spacer(),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 8.0),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.end,
          //               children: [
          //                 Row(
          //                   children: [
          // InkWell(
          //   onTap: () {
          //     showModalBottomSheet<void>(
          //       isScrollControlled: true,
          //       backgroundColor: Colors.transparent,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       context: context,
          //       builder: (BuildContext context) {
          //         return Padding(
          //           padding:
          //               MediaQuery.of(context).viewInsets,
          //           child: rideConfirmSection(
          //               context,
          //               "suv",
          //               "200",
          //               "Kukatpally",
          //               "Madhapur"),
          //         );
          //       },
          //     );
          //   },
          //   child: Container(
          //     height: 20,
          //     width: 20,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       color: const Color(0xFFF2F6F9),
          //     ),
          //     child: const Icon(
          //       Icons.info_outline,
          //       size: 15,
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   width: 5,
          // ),
          //                     const Text(
          //                       "₹ 385.00",
          //                       style: TextStyle(
          //                         fontFamily: 'MonS',
          //                         fontSize: 15,
          //                         color: primaryColor,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 6),
          //                 const Text(
          //                   "₹ 420.00",
          //                   style: TextStyle(
          //                     fontFamily: 'MonR',
          //                     fontSize: 7,
          //                     color: kindaBlack,
          //                     decoration: TextDecoration.lineThrough,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           // const SizedBox(
          //           //   width: 5,
          //           // ),
          //           // _vehicleSelected == 2
          //           //     ? Expanded(
          //           //         child: Container(
          //           //           decoration: const BoxDecoration(
          //           //             borderRadius: BorderRadius.only(
          //           //                 topRight: Radius.circular(15),
          //           //                 bottomRight: Radius.circular(15)),
          //           //             color: primaryColor,
          //           //           ),
          //           //           height: 69,
          //           //           width: 45,
          //           //           child: Column(
          //           //             mainAxisAlignment: MainAxisAlignment.center,
          //           //             children: [
          //           //               Icon(Icons.filter_alt_outlined,
          //           //                   color: whiteColor),
          //           //               RippleAnimation(
          //           //                 delay: Duration(milliseconds: 2000),
          //           //                 repeat: true,
          //           //                 color: kindaBlack.withOpacity(0.5),
          //           //                 minRadius: 25,
          //           //                 ripplesCount: 3,
          //           //                 child: Text(
          //           //                   "Filter",
          //           //                   style: TextStyle(
          //           //                     fontFamily: 'MonR',
          //           //                     fontSize: 10,
          //           //                     color: whiteColor,
          //           //                   ),
          //           //                 ),
          //           //               ),
          //           //             ],
          //           //           ),
          //           //         ),
          //           //       )
          //           //     : Container()
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       _vehicleSelected = 3;
          //     });
          //   },
          //   onDoubleTap: () {
          //     setState(() {
          //       filterVal = 2;
          //       cab = 'Bike';
          //     });
          //   },
          //   child: Material(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     elevation: _vehicleSelected == 3 ? 4 : 0,
          //     child: Container(
          //       height: 69,
          //       width: 349,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         border: Border.all(
          //             color: _vehicleSelected == 3
          //                 ? primaryColor
          //                 : Colors.transparent),
          //         color: whiteColor,
          //       ),
          //       child: Row(
          //         children: [
          //           Image.asset(
          //             'assets/vehicles/motorbike.png',
          //             width: 80,
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "Bike",
          //                 style: TextStyle(
          //                   fontFamily: 'MonS',
          //                   fontSize: 12,
          //                   color: kindaBlack,
          //                 ),
          //               ),
          //               const SizedBox(height: 6),
          //               Text(
          //                 "1 seaters",
          //                 style: TextStyle(
          //                   fontFamily: 'MonR',
          //                   fontSize: 10,
          //                   color: kindaBlack.withOpacity(0.6),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const Spacer(),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 8.0),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.end,
          //               children: [
          //                 Row(
          //                   children: [
          //                     Container(
          //                       height: 20,
          //                       width: 20,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(50),
          //                         color: const Color(0xFFF2F6F9),
          //                       ),
          //                       child: const Icon(
          //                         Icons.info_outline,
          //                         size: 15,
          //                       ),
          //                     ),
          //                     const SizedBox(
          //                       width: 5,
          //                     ),
          //                     const Text(
          //                       "₹ 85.00",
          //                       style: TextStyle(
          //                         fontFamily: 'MonS',
          //                         fontSize: 15,
          //                         color: primaryColor,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 6),
          //                 const Text(
          //                   "₹ 120.00",
          //                   style: TextStyle(
          //                     fontFamily: 'MonR',
          //                     fontSize: 7,
          //                     color: kindaBlack,
          //                     decoration: TextDecoration.lineThrough,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           // const SizedBox(
          //           //   width: 5,
          //           // ),
          //           // _vehicleSelected == 3
          //           //     ? Expanded(
          //           //         child: Container(
          //           //           decoration: const BoxDecoration(
          //           //             borderRadius: BorderRadius.only(
          //           //                 topRight: Radius.circular(15),
          //           //                 bottomRight: Radius.circular(15)),
          //           //             color: primaryColor,
          //           //           ),
          //           //           height: 69,
          //           //           width: 45,
          //           //           child: Column(
          //           //             mainAxisAlignment: MainAxisAlignment.center,
          //           //             children: [
          //           //               Icon(Icons.filter_alt_outlined,
          //           //                   color: whiteColor),
          //           //               RippleAnimation(
          //           //                 delay: Duration(milliseconds: 2000),
          //           //                 repeat: true,
          //           //                 color: kindaBlack.withOpacity(0.5),
          //           //                 minRadius: 25,
          //           //                 ripplesCount: 3,
          //           //                 child: Text(
          //           //                   "Filter",
          //           //                   style: TextStyle(
          //           //                     fontFamily: 'MonR',
          //           //                     fontSize: 10,
          //           //                     color: whiteColor,
          //           //                   ),
          //           //                 ),
          //           //               ),
          //           //             ],
          //           //           ),
          //           //         ),
          //           //       )
          //           //     : Container()
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 12,
          // ),
          // InkWell(
          //   onTap: () {
          //     setState(() {
          //       _vehicleSelected = 4;
          //     });
          //   },
          //   onDoubleTap: () {
          //     setState(() {
          //       filterVal = 2;
          //       cab = 'Auto';
          //     });
          //   },
          //   child: Material(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     elevation: _vehicleSelected == 4 ? 4 : 0,
          //     child: Container(
          //       height: 69,
          //       width: 349,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(15),
          //         border: Border.all(
          //             color: _vehicleSelected == 4
          //                 ? primaryColor
          //                 : Colors.transparent),
          //         color: whiteColor,
          //       ),
          //       child: Row(
          //         children: [
          //           Image.asset(
          //             'assets/vehicles/auto.png',
          //             width: 80,
          //           ),
          //           const SizedBox(
          //             width: 15,
          //           ),
          //           Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               const Text(
          //                 "Auto",
          //                 style: TextStyle(
          //                   fontFamily: 'MonS',
          //                   fontSize: 12,
          //                   color: kindaBlack,
          //                 ),
          //               ),
          //               const SizedBox(height: 6),
          //               Text(
          //                 "3 seaters",
          //                 style: TextStyle(
          //                   fontFamily: 'MonR',
          //                   fontSize: 10,
          //                   color: kindaBlack.withOpacity(0.6),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const Spacer(),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 8.0),
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.end,
          //               children: [
          //                 Row(
          //                   children: [
          //                     Container(
          //                       height: 20,
          //                       width: 20,
          //                       decoration: BoxDecoration(
          //                         borderRadius: BorderRadius.circular(50),
          //                         color: const Color(0xFFF2F6F9),
          //                       ),
          //                       child: const Icon(
          //                         Icons.info_outline,
          //                         size: 15,
          //                       ),
          //                     ),
          //                     const SizedBox(
          //                       width: 5,
          //                     ),
          //                     const Text(
          //                       "₹ 125.00",
          //                       style: TextStyle(
          //                         fontFamily: 'MonS',
          //                         fontSize: 15,
          //                         color: primaryColor,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 6),
          //                 const Text(
          //                   "₹ 185.00",
          //                   style: TextStyle(
          //                     fontFamily: 'MonR',
          //                     fontSize: 7,
          //                     color: kindaBlack,
          //                     decoration: TextDecoration.lineThrough,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           // const SizedBox(
          //           //   width: 5,
          //           // ),
          //           // _vehicleSelected == 4
          //           //     ? Expanded(
          //           //         child: Container(
          //           //           decoration: const BoxDecoration(
          //           //             borderRadius: BorderRadius.only(
          //           //                 topRight: Radius.circular(15),
          //           //                 bottomRight: Radius.circular(15)),
          //           //             color: primaryColor,
          //           //           ),
          //           //           height: 69,
          //           //           width: 45,
          //           //           child: Column(
          //           //             mainAxisAlignment: MainAxisAlignment.center,
          //           //             children: [
          //           //               Icon(Icons.filter_alt_outlined,
          //           //                   color: whiteColor),
          //           //               RippleAnimation(
          //           //                 delay: Duration(milliseconds: 2000),
          //           //                 repeat: true,
          //           //                 color: kindaBlack.withOpacity(0.5),
          //           //                 minRadius: 25,
          //           //                 ripplesCount: 3,
          //           //                 child: Text(
          //           //                   "Filter",
          //           //                   style: TextStyle(
          //           //                     fontFamily: 'MonR',
          //           //                     fontSize: 10,
          //           //                     color: whiteColor,
          //           //                   ),
          //           //                 ),
          //           //               ),
          //           //             ],
          //           //           ),
          //           //         ),
          //           //       )
          //           //     : Container()
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
