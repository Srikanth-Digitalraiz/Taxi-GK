import 'dart:async';
import 'dart:convert';

import 'package:action_slider/action_slider.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/data/user_data.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/out/out.dart';
import 'package:ondeindia/global/out/out_pack.dart';
import 'package:ondeindia/global/promocode.dart';
import 'package:ondeindia/global/ride/ride_details.dart';
import 'package:ondeindia/global/schedule_acc.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/pick_n_drop.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/screens/home/widget/payment_selection.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:spinner_date_time_picker/spinner_date_time_picker.dart';
import 'dart:math';

import '../../../constants/apiconstants.dart';
import '../../../global/admin_id.dart';
import '../../../global/couponcode.dart';
import '../../../global/current_location.dart';
import '../../../global/distance.dart';
import '../../../global/fare_type.dart';
import '../../../global/google_key.dart';
import '../../../global/map_styles.dart';
import '../../../global/pickup_location.dart';
import '../../../global/rental_fare_plan.dart';
import '../../../global/wallet.dart';
import '../../../repositories/tripsrepo.dart';
import '../../auth/loginscreen.dart';
import '../../auth/new_auth/login_new.dart';
import '../../auth/new_auth/new_auth_selected.dart';
import '../../bookride/bookride.dart';
import '../widget/enter_cupon.dart';

class RideConfirm extends StatefulWidget {
  String dropLocation;
  RideConfirm({Key? key, required this.dropLocation}) : super(key: key);

  @override
  State<RideConfirm> createState() => _RideConfirmState();
}

class _RideConfirmState extends State<RideConfirm> {
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

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  BitmapDescriptor? startpinLocationIcon;
  BitmapDescriptor? droppinLocationIcon;

  // BitmapDescriptor? pickup = BitmapDescriptor;

  // BitmapDescriptor? drop;

  // void setCustomePickMarker() async {
  //   pickup = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/images/pickupmarker.png');
  // }

  String googleAPiKey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  // LatLng startLocation = LatLng(27.6683619, 85.3101895);

  LatLng startLocation = LatLng(pickLat, pikLong);
  LatLng endLocation = LatLng(dropLat, dropLong);

  // markerInfo() async {
  //   mapController?.showMarkerInfoWindow(const MarkerId("dropLoc"));
  // }

  Timer? tim;

  @override
  void initState() {
    super.initState();
    tim = Timer.periodic(Duration(seconds: 1), (val) {
      setState(() {});
    });
    getDirections();
    setCustomMapStartPin();
    setCustomMapEndPin();
    _eta();
    // getServicesLis(context, eta, promoCode, widget.dropLocation);
  }

  void setCustomMapStartPin() async {
    startpinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'assets/images/startpoint.png');
  }

  void setCustomMapEndPin() async {
    droppinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'assets/images/droppoint.png');
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      // setCustomePickMarker();
      markers.add(Marker(
        //add start location marker
        markerId: const MarkerId("pickLoc"),
        position: startLocation,
        // icon: BitmapDescriptor.defaultMarkerWithHue(
        // BitmapDescriptor.hueGreen), //Icon for Marker
        // icon: BitmapDescriptor.fromAssetImage(
        //     ImageConfiguration(size: Size(12, 12)),
        //     'assets/images/startpoint.png')
        icon: startpinLocationIcon == null
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            : startpinLocationIcon!,
      ));

      markers.add(Marker(
        //add distination location marker
        markerId: const MarkerId("dropLoc"),
        position: endLocation, //position of marker

        // icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        icon: droppinLocationIcon == null
            ? BitmapDescriptor.defaultMarker
            : droppinLocationIcon!,
      ));
    });

    return markers;
  }

  String eta = "";

  _eta() async {
    Dio dio = Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$pickLat,$pikLong&destinations=$dropLat,$dropLong&key=$gooAPIKey");
    print("ETA------------------__>" + response.data.toString());
    setState(() {
      eta = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    });
  }

  Future scheduleRide(context, schDate, schTime) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    var date1 = mainReturnDate == ''
        ? DateTime.now().toString().split(' ')
        : mainReturnDate.split(' ');
    DateTime date = DateTime.now();
    String date2 = DateFormat('yy-MM-dd').format(date);
    String apiUrl = rideRequest;

    // Fluttertoast.showToast(msg: date1.toString());

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "admin_id": adminId,
        "s_latitude": pickLat.toStringAsFixed(4),
        "s_longitude": pikLong.toStringAsFixed(4),
        "d_latitude": dropLat.toStringAsFixed(4),
        "d_longitude": dropLong.toStringAsFixed(4),
        "service_type": serviceID.toString(),
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
        "current_date": date2,
        'return_date': date1[0].toString(),
        'fareplan': selectedOutName
      },
    );

    // Fluttertoast.showToast(
    //     msg: "========================>" + response.statusCode.toString());

    print("Admin ID: " +
        adminId +
        " \n " +
        "s_latitude: " +
        pickLat.toStringAsFixed(4) +
        " \n " +
        "s_longitude: " +
        pikLong.toStringAsFixed(4) +
        " \n " +
        "d_latitude: " +
        dropLat.toStringAsFixed(4) +
        " \n " +
        "d_longitude: " +
        dropLong.toStringAsFixed(4) +
        " \n " +
        "s_latitude: " +
        pickLat.toStringAsFixed(4) +
        " \n " +
        "serviceType: " +
        serviceID +
        " \n " +
        "distance: " +
        distance.toStringAsFixed(4) +
        " \n " +
        "use_wallet: " +
        "1" +
        " \n " +
        "Payment mode: " +
        "CASH" +
        " \n " +
        "s_address: " +
        pickAdd +
        " \n " +
        "d_address: " +
        dropadd +
        " \n " +
        "schedule_date: " +
        schDate +
        " \n " +
        "schedule_time: " +
        schTime +
        " \n " +
        "fare_plane_name: " +
        rentalFarePlan +
        " \n " +
        "fare_type: " +
        fareType +
        " \n " +
        "fare_setting: " +
        fare_setting_plan +
        " \n " +
        "ETA : " +
        eta);

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
      setState(() {
        fareType = "15";
        rentalFarePlan = "";
        dropadd = "";
        selectedDate = '';
      });
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => HomeScreen(),
          ));

      // Navigator.pop(context);

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
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      gooAPIKey,
      // PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(pickLat, pikLong),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    addPolyLine(polylineCoordinates);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void setInitialLocation() async {
    CameraPosition cPosition = CameraPosition(
      zoom: distance >= 6 ? 13 : 16,
      target: LatLng(currentLat, currentLong),
    );
    mapController!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    tim!.cancel();
    super.dispose();
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

    // Fluttertoast.showToast(msg: date2);

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
    // Fluttertoast.showToast(msg: '${response.statusCode}');
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
    mapController?.showMarkerInfoWindow(const MarkerId("pickLoc"));
    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.1,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapToolbarEnabled: false,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            gestureRecognizers:
                                <Factory<OneSequenceGestureRecognizer>>[
                              new Factory<OneSequenceGestureRecognizer>(
                                () => new EagerGestureRecognizer(),
                              ),
                            ].toSet(),
                            //Map widget from google_maps_flutter package

                            //Map widget from google_maps_flutter package
                            zoomGesturesEnabled:
                                true, //enable Zoom in, out on map
                            initialCameraPosition: CameraPosition(
                              //innital position in map
                              target: startLocation, //initial position
                              zoom: distance >= 6 ? 13 : 16,
                              //initial zoom level
                            ),
                            markers: getmarkers(), //markers to show on map
                            polylines:
                                Set<Polyline>.of(polylines.values), //polylines
                            mapType: MapType.normal, //map type
                            onMapCreated: (controller) {
                              setState(() {
                                mapController = controller;
                                mapController!.setMapStyle(mapStyle);
                              });
                            },
                          ),
                          CustomInfoWindow(
                            controller: _customInfoWindowController,
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.6,
                            offset: 45,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () {
                                setInitialLocation();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.3), //color of shadow
                                        spreadRadius: 2, //spread radius
                                        blurRadius: 2, // blur radius
                                        offset: Offset(
                                            1, 2), // changes position of shadow
                                      ),
                                      //you can set more BoxShadow() here
                                      BoxShadow(
                                        color: Colors.grey
                                            .withOpacity(0.3), //color of shadow
                                        spreadRadius: 2, //spread radius
                                        blurRadius: 2, // blur radius
                                        offset: Offset(
                                            2, 1), // changes position of shadow
                                        //first paramerter of offset is left-right
                                        //second parameter is top to down
                                      ),
                                      //you can set more BoxShadow() here
                                    ],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(Icons.gps_fixed_outlined),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //     bottom: 0,
                    //     left: 0,
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Container(
                    //             child: Card(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Container(
                    //                 child: Text("ETA: " + mainETA,
                    //                     style: TextStyle(
                    //                         fontSize: 10,
                    //                         fontWeight: FontWeight.bold))),
                    //           ),
                    //         )),
                    //         SizedBox(
                    //           height: 1,
                    //         ),
                    //         Container(
                    //             child: Card(
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Container(
                    //                 child: Text(
                    //                     "Distance: " +
                    //                         distance.toStringAsFixed(2) +
                    //                         " KM",
                    //                     style: TextStyle(
                    //                         fontSize: 10,
                    //                         fontWeight: FontWeight.bold))),
                    //           ),
                    //         )),
                    //       ],
                    //     )),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                      child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Select Ride...",
                            style: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 13,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                      sched_acc == false
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                var today = DateTime.now();
                                // var date = selectedDate.toString().split(" ");
                                // var date1 = date[0].toString();
                                // var date2 = date[1].toString().split(".");
                                // var mainTime = date2[0].toString();
                                setState(() {
                                  selectedDate = "";
                                  scDate = '';
                                  scTime = '';
                                });

                                DatePicker.showDateTimePicker(context,
                                    minTime: today,
                                    // minTime: DateTime(2018, 3, 5),
                                    maxTime: today.add(Duration(days: 7)),
                                    showTitleActions: true, onChanged: (date) {
                                  setState(() {
                                    selectedDate =
                                        date == today ? "" : date.toString();
                                    serviceTime =
                                        date == today ? "" : date.toString();
                                  });

                                  // print('change $date in time zone ' +
                                  //     date.timeZoneOffset.inHours.toString());
                                }, onConfirm: (date) async {
                                  var schdate =
                                      selectedDate.toString().split(" ");
                                  var schdate1 = schdate[0].toString();
                                  var schdate2 =
                                      schdate[1].toString().split(".");
                                  var mainTime = schdate2[0].toString();
                                  setState(() {
                                    scDate = schdate1;
                                    scTime = mainTime;
                                  });
                                  // await getServices(
                                  //     context, eta, promoCode, widget.dropLocation);
                                  await getServicesLis(context, eta, promoCode,
                                      widget.dropLocation);
                                  // Fluttertoast.showToast(
                                  //     msg: "Date +   $scDate  +      $scTime");
                                  print('confirm $date');
                                }, currentTime: today);

                                // DatePicker.showDatePicker(context,
                                //     showTitleActions: true,
                                // minTime: DateTime.now(),
                                // // minTime: DateTime(2018, 3, 5),
                                // maxTime: DateTime.now().add(Duration(days: 7)),
                                //     onChanged: (date) {
                                //   print('change $date');
                                // }, onConfirm: (date) {
                                //   print('confirm $date');
                                // },
                                //     currentTime: DateTime.now(),
                                //     locale: LocaleType.en);

                                //----------Risking Part----//
                                // showDialog(
                                //     barrierDismissible: false,
                                //     context: context,
                                //     builder: (context) {
                                //       var today = DateTime.now();
                                //       return Dialog(
                                //         child: SpinnerDateTimePicker(
                                //           initialDateTime: today,
                                //           maximumDate:
                                //               today.add(const Duration(days: 7)),
                                //           minimumDate: today,
                                //           mode: CupertinoDatePickerMode.dateAndTime,
                                //           use24hFormat: true,
                                //           didSetTime: (value) {
                                //             // Fluttertoast.showToast(
                                //             //     msg: today.toIso8601String());
                                //             // if (today.toIso8601String() ==
                                //             //     value.toIso8601String()) {
                                //             //   Fluttertoast.showToast(msg: "True");
                                //             // } else {
                                //             //   Fluttertoast.showToast(msg: "False");
                                //             // }
                                // setState(() {
                                //   selectedDate = value == today
                                //       ? ""
                                //       : value.toString();
                                //   serviceTime = value == today
                                //       ? ""
                                //       : value.toString();
                                // });
                                //           },
                                //         ),
                                //       );
                                //     });
                              },
                              child: Container(
                                // margin: EdgeInsets.only(top: 20, right: 10),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2), //color of shadow
                                      spreadRadius: 1, //spread radius
                                      blurRadius: 1, // blur radius
                                      offset: Offset(
                                          0, 1), // changes position of shadow
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
                                      selectedDate == ""
                                          ? Text(
                                              "Now",
                                              style: TextStyle(
                                                fontFamily: 'MonM',
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Builder(builder: (context) {
                                              return Builder(
                                                  builder: (context) {
                                                DateTime date1 = DateTime.parse(
                                                    selectedDate);
                                                // Format the date to display as "21 May, 08:00 AM"
                                                String formattedDate =
                                                    DateFormat(
                                                            'dd MMM, hh:mm a')
                                                        .format(date1);
                                                return Text(
                                                  formattedDate,
                                                  // selectedDate
                                                  //     .replaceAll(RegExp(r'\.0+$'), '')
                                                  //     .replaceAll(RegExp(r'0+$'), '')
                                                  //     .replaceAll(RegExp(r':$'), ''),
                                                  style: TextStyle(
                                                    fontFamily: 'MonM',
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              });
                                            }),
                                    ],
                                  ),
                                ),
                              ),
                            )
                    ],
                  )),
                ),
                PickNDrop(
                  drop: widget.dropLocation.toString(),
                ),
                // SingleChildScrollView(
                //   child: Column(
                //     children: [

                //       _vehicleDetails(),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          SafeArea(
            child: Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(top: 10, left: 10),
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), //color of shadow
                    spreadRadius: 1, //spread radius
                    blurRadius: 2, // blur radius
                    offset: Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    fareType = "15";
                    out = false;
                    selectedDate = "";
                    scDate = '';
                    scTime = '';
                    serviceLis = [];
                  });
                  // widget.zoomDrawerController.toggle();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   CupertinoPageRoute(builder: (context) => HomeScreen()),
                  //   (route) => false,
                  // );
                  // Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: 100,
          //     color: whiteColor,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Divider(),
          //         Row(
          //           children: [
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   showModalBottomSheet<void>(
          //                     isScrollControlled: true,
          //                     backgroundColor: Colors.transparent,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(20),
          //                     ),
          //                     context: context,
          //                     builder: (BuildContext context) {
          //                       return Padding(
          //                         padding: MediaQuery.of(context).viewInsets,
          //                         child: PaymentSelection(),
          //                       );
          //                     },
          //                   );
          //                 },
          //                 child: Container(
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Image.asset(
          //                         'assets/images/googlepay.png',
          //                         height: 20,
          //                         width: 30,
          //                       ),
          //                       SizedBox(
          //                         width: 5,
          //                       ),
          //                       Text(
          //                         "Google Pay",
          //                         style: TextStyle(
          //                           fontFamily: 'MonM',
          //                           fontSize: 12,
          //                           color: Colors.black,
          //                         ),
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Container(
          //               height: 15,
          //               width: 1,
          //               color: Colors.black.withOpacity(0.3),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   // cuponCode
          //                   showModalBottomSheet<void>(
          //                     isScrollControlled: true,
          //                     backgroundColor: Colors.transparent,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(20),
          //                     ),
          //                     context: context,
          //                     builder: (BuildContext context) {
          //                       return Padding(
          //                         padding: MediaQuery.of(context).viewInsets,
          //                         child: cuponCode(
          //                           context,
          //                         ),
          //                       );
          //                     },
          //                   );
          //                 },
          //                 child: Container(
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Image.asset('assets/icons/tag.png',
          //                           height: 20,
          //                           width: 30,
          //                           color: Colors.green.shade700),
          //                       SizedBox(
          //                         width: 5,
          //                       ),
          //                       Text(
          //                         "Coupon",
          //                         style: TextStyle(
          //                           fontFamily: 'MonM',
          //                           fontSize: 12,
          //                           color: Colors.black,
          //                         ),
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Container(
          //               height: 15,
          //               width: 1,
          //               color: Colors.black.withOpacity(0.3),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Expanded(
          //               child: Container(
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Icon(Icons.person),
          //                     SizedBox(
          //                       width: 5,
          //                     ),
          //                     Text(
          //                       "My Self",
          //                       style: TextStyle(
          //                         fontFamily: 'MonM',
          //                         fontSize: 12,
          //                         color: Colors.black,
          //                       ),
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Container(
          //           width: MediaQuery.of(context).size.width,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(0),
          //             color: Colors.black,
          //           ),
          //           child: InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => BookRideSection(),
          //                 ),
          //               );
          //             },
          //             child: Center(
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
          //                 child: Text(
          //                   "Select Ride",
          //                   style: TextStyle(
          //                     fontFamily: 'MonS',
          //                     fontSize: 17,
          //                     color: whiteColor,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: selectedDate != "" ? 160 : 130,
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: 35,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // Fluttertoast.showToast(msg: paymentMode);
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
                                child: PaymentSelection(),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                paymentMode == "WALLET"
                                    ? Icon(Icons.wallet,
                                        color: Colors.green.shade700)
                                    : Icon(Icons.money_outlined,
                                        color: Colors.green.shade700),
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
                      height: 40,
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: cuponCode(),
                              );
                            },
                          );
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //https://assets1.lottiefiles.com/packages/lf20_xjtsxfxw.json
                              cuponCodes == ""
                                  ? Center(
                                      child:
                                          Icon(Icons.sell_outlined, size: 15))
                                  : Stack(
                                      children: [
                                        Icon(Icons.sell_outlined, size: 15),
                                        // Lottie.network(
                                        //   'https://assets9.lottiefiles.com/packages/lf20_vvhc8yfo.json',
                                        //   height: 30,
                                        //   width: 30,
                                        // ),
                                      ],
                                    ),

                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                coupon == "" ? "Coupon" : cuponCodes,
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
                    // Container(
                    //   height: 15,
                    //   width: 1,
                    //   color: Colors.black.withOpacity(0.3),
                    // ),
                    // SizedBox(
                    //   width: 7,
                    // ),
                    // Expanded(
                    //   child: Container(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(Icons.person),
                    //         SizedBox(
                    //           width: 5,
                    //         ),
                    //         Text(
                    //           "My Self",
                    //           style: TextStyle(
                    //             fontFamily: 'MonM',
                    //             fontSize: 12,
                    //             color: Colors.black,
                    //           ),
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 7,
                    ),
                  ],
                ),
              ),
              SizedBox(height: selectedDate == "" ? 20 : 10),
              selectedDate == ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 60,
                        child: ActionSlider.standard(
                          toggleColor: white,
                          sliderBehavior: SliderBehavior.stretch,
                          height: 60,
                          backgroundColor: Colors.black,
                          child: Center(
                            child: Builder(builder: (context) {
                              var date = selectedDate.toString().split(" ");
                              var date1 = date[0].toString();
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text("Book Ride $serviceName",
                                      style: TextStyle(
                                        fontFamily: 'MonS',
                                        fontSize: 14,
                                        color: whiteColor,
                                      ),
                                      textAlign: TextAlign.center),
                                ),
                              );
                            }),
                          ),
                          action: (controller) async {
                            controller.loading();
                            if (out == true) {
                              controller.reset();
                              if (serviceID == "" || selectedOutPlan == -1) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Please Select a ride and Pack before trying to book");
                              } else if (dropadd != "") {
                                controller.reset();
                                if (selectedOutName == "One Way") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookRideSection(
                                        serviceID: serviceID,
                                        serviceName: serviceName,
                                      ),
                                    ),
                                  );
                                } else {
                                  controller.reset();
                                  if (mainReturnDate == "") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please select return date if you wish to book Outstation Round Trip");
                                  } else {
                                    controller.reset();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookRideSection(
                                          serviceID: serviceID,
                                          serviceName: serviceName,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                controller.reset();
                                Fluttertoast.showToast(
                                    msg: "Please select Drop Location");
                              }
                            } else {
                              controller.reset();
                              if (serviceID == "") {
                                controller.reset();
                                Fluttertoast.showToast(
                                    msg: "Please Select a ride...");
                              } else if (dropadd != "") {
                                controller.reset();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookRideSection(
                                      serviceID: serviceID,
                                      serviceName: serviceName,
                                    ),
                                  ),
                                );
                              } else {
                                controller.reset();
                                Fluttertoast.showToast(
                                    msg: "Please select Drop Location");
                              }
                            }
                            // var date = selectedDate.toString().split(" ");
                            // var date1 = date[0].toString();
                            // var date2 = date[1].toString().split(".");
                            // var mainTime = date2[0].toString();
                            // showFareDialog(context);
                            // String rideID = snapshot.data![index]['id']
                            // getRideFare(context, _id, _name);
                          },
                          // ... //many more parameters
                        ),
                      ),
                    )
                  // ? Container(
                  //     margin: EdgeInsets.symmetric(horizontal: 12),
                  //     width: MediaQuery.of(context).size.width,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(50),
                  //       color: Colors.black,
                  //     ),
                  //     child: InkWell(
                  //       onTap: () async {
                  // if (out == true) {
                  //   if (serviceID == "" || selectedOutPlan == -1) {
                  //     Fluttertoast.showToast(
                  //         msg:
                  //             "Please Select a ride and Pack before trying to book");
                  //   } else if (dropadd != "") {
                  //     if (selectedOutName == "One Way") {
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => BookRideSection(
                  //             serviceID: serviceID,
                  //             serviceName: serviceName,
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       if (mainReturnDate == "") {
                  //         Fluttertoast.showToast(
                  //             msg:
                  //                 "Please select return date if you wish to book Outstation Round Trip");
                  //       } else {
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => BookRideSection(
                  //               serviceID: serviceID,
                  //               serviceName: serviceName,
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //     }
                  //   } else {
                  //     Fluttertoast.showToast(
                  //         msg: "Please select Drop Location");
                  //   }
                  // } else {
                  //   if (serviceID == "") {
                  //     Fluttertoast.showToast(
                  //         msg: "Please Select a ride...");
                  //   } else if (dropadd != "") {
                  //     Navigator.pushReplacement(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => BookRideSection(
                  //           serviceID: serviceID,
                  //           serviceName: serviceName,
                  //         ),
                  //       ),
                  //     );
                  //   } else {
                  //     Fluttertoast.showToast(
                  //         msg: "Please select Drop Location");
                  //   }
                  // }
                  // // var date = selectedDate.toString().split(" ");
                  // // var date1 = date[0].toString();
                  // // var date2 = date[1].toString().split(".");
                  // // var mainTime = date2[0].toString();
                  // // showFareDialog(context);
                  // // String rideID = snapshot.data![index]['id']
                  // // getRideFare(context, _id, _name);
                  //       },
                  //       child: Center(
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 18.0),
                  // child: Text(
                  //   "Book Ride $serviceName",
                  //   style: TextStyle(
                  //     fontFamily: 'MonB',
                  //     fontSize: 15,
                  //     color: whiteColor,
                  //   ),
                  // ),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  : Column(
                      children: [
                        SizedBox(height: 8),
                        Builder(builder: (context) {
                          var date = selectedDate.toString().split(" ");
                          DateTime date1 = DateTime.parse(selectedDate);
                          // Format the date to display as "21 May, 08:00 AM"
                          String formattedDate =
                              DateFormat('dd MMM, hh:mm a').format(date1);
                          return Container(
                              height: 20,
                              color: white,
                              child: Text(
                                "Your pick up will be on $formattedDate",
                                style: TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 14,
                                  color: kindaBlack,
                                  letterSpacing: 1,
                                ),
                              ));
                        }),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 60,
                            child: ActionSlider.standard(
                              toggleColor: white,
                              sliderBehavior: SliderBehavior.stretch,
                              height: 60,
                              backgroundColor: Colors.black,
                              child: Center(
                                child: Builder(builder: (context) {
                                  var date = selectedDate.toString().split(" ");
                                  var date1 = date[0].toString();
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 11.0),
                                      child: Builder(builder: (context) {
                                        var dates =
                                            selectedDate.toString().split(" ");
                                        var dates1 = dates[0].toString();
                                        return Text(
                                          "Schedule $serviceName",
                                          style: TextStyle(
                                            fontFamily: 'MonM',
                                            fontSize: 15,
                                            color: whiteColor,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      }),
                                    ),
                                  );
                                }),
                              ),
                              action: (controller) async {
                                controller.loading();
                                var date = selectedDate.toString().split(" ");
                                var date1 = date[0].toString();
                                var date2 = date[1].toString().split(".");
                                var mainTime = date2[0].toString();

                                var date5 = mainReturnDate == ""
                                    ? DateTime.now().toString().split(' ')
                                    : mainReturnDate.toString().split(' ');
                                var date6 = date5[0].toString();

                                //Dates Comparision
                                DateTime comdate1 = selectedDate == ""
                                    ? DateTime.now()
                                    : DateTime.parse(date1);
                                DateTime comdate2 = DateTime.parse(date6);
                                // showFareDialog(context);
                                // String rideID = snapshot.data![index]['id']
                                // getRideFare(context, _id, _name);
                                if (serviceID == "") {
                                  controller.reset();
                                  Fluttertoast.showToast(
                                      msg: "Please Select a ride...");
                                } else if (serviceID == "" ||
                                    selectedOutPlan == -1) {
                                  controller.reset();
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please Select a ride and Pack before trying to book");
                                } else if (mainReturnDate == "") {
                                  controller.reset();
                                  if (selectedOutName == 'One Way') {
                                    controller.reset();
                                    await scheduleRide(
                                        context, date1, mainTime);
                                  } else {
                                    controller.reset();
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please select return date if you wish to book Outstation Round Trip");
                                  }
                                } else if (comdate2.isBefore(comdate1)) {
                                  controller.reset();
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please make sure your Retun Date is after scheduled date ");
                                } else {
                                  controller.reset();
                                  await scheduleRide(context, date1, mainTime);
                                  //   Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => BookRideSection(
                                  //         serviceID: serviceID,
                                  //         serviceName: serviceName,
                                  //       ),
                                  //     ),
                                  //   );
                                  // }
                                }
                                // var date = selectedDate.toString().split(" ");
                                // var date1 = date[0].toString();
                                // var date2 = date[1].toString().split(".");
                                // var mainTime = date2[0].toString();
                                // showFareDialog(context);
                                // String rideID = snapshot.data![index]['id']
                                // getRideFare(context, _id, _name);
                              },
                              // ... //many more parameters
                            ),
                          ),
                        )
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 12),
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(50),
                        //     color: Colors.black,
                        //   ),
                        //   child: InkWell(
                        //     onTap: () async {
                        // var date = selectedDate.toString().split(" ");
                        // var date1 = date[0].toString();
                        // var date2 = date[1].toString().split(".");
                        // var mainTime = date2[0].toString();

                        // var date5 = mainReturnDate == ""
                        //     ? DateTime.now().toString().split(' ')
                        //     : mainReturnDate.toString().split(' ');
                        // var date6 = date5[0].toString();

                        // //Dates Comparision
                        // DateTime comdate1 = selectedDate == ""
                        //     ? DateTime.now()
                        //     : DateTime.parse(date1);
                        // DateTime comdate2 = DateTime.parse(date6);
                        // // showFareDialog(context);
                        // // String rideID = snapshot.data![index]['id']
                        // // getRideFare(context, _id, _name);
                        // if (serviceID == "") {
                        //   Fluttertoast.showToast(
                        //       msg: "Please Select a ride...");
                        // } else if (serviceID == "" ||
                        //     selectedOutPlan == -1) {
                        //   Fluttertoast.showToast(
                        //       msg:
                        //           "Please Select a ride and Pack before trying to book");
                        // } else if (mainReturnDate == "") {
                        //   if (selectedOutName == 'One Way') {
                        //     await scheduleRide(context, date1, mainTime);
                        //   } else {
                        //     Fluttertoast.showToast(
                        //         msg:
                        //             "Please select return date if you wish to book Outstation Round Trip");
                        //   }
                        // } else if (comdate2.isBefore(comdate1)) {
                        //   Fluttertoast.showToast(
                        //       msg:
                        //           "Please make sure your Retun Date is after scheduled date ");
                        // } else {
                        //   await scheduleRide(context, date1, mainTime);
                        //   //   Navigator.pushReplacement(
                        //   //     context,
                        //   //     MaterialPageRoute(
                        //   //       builder: (context) => BookRideSection(
                        //   //         serviceID: serviceID,
                        //   //         serviceName: serviceName,
                        //   //       ),
                        //   //     ),
                        //   //   );
                        //   // }
                        // }

                        //       // Fluttertoast.showToast(msg: mainTime);
                        //     },
                        //     child: Center(
                        //       child: Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(vertical: 18.0),
                        // child: Builder(builder: (context) {
                        //   var dates =
                        //       selectedDate.toString().split(" ");
                        //   var dates1 = dates[0].toString();
                        //   return Text(
                        //     "Schedule $serviceName",
                        //     style: TextStyle(
                        //       fontFamily: 'MonM',
                        //       fontSize: 15,
                        //       color: whiteColor,
                        //     ),
                        //   );
                        // }),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
