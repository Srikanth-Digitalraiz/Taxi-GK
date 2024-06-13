import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/distance.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/global/schedule_acc.dart';
import 'package:ondeindia/screens/bookride/bookride.dart';
import 'package:ondeindia/screens/home/Rental%20Flow/rental_drop.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/screens/home/Outstation%20Flow/outstation_main.dart';
import 'package:ondeindia/screens/home/widget/enter_cupon.dart';
import 'package:ondeindia/screens/home/widget/no_partners_poly.dart';
import 'package:ondeindia/screens/home/widget/payment_selection.dart';
import 'package:ondeindia/screens/home/widget/ride_confirm.dart';
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
// import 'package:spinner_date_time_picker/spinner_date_time_picker.dart';

import '../../../constants/apiconstants.dart';
import '../../../global/admin_id.dart';
import '../../../global/current_location.dart';
import '../../../global/data/user_data.dart';
import '../../../global/dropdetails.dart';
import '../../../global/fare_type.dart';
import '../../../global/google_key.dart';
import '../../../global/maineta.dart';
import '../../../global/map_styles.dart';
import '../../../global/out/out.dart';
import '../../../global/outStatus.dart';
import '../../../global/promocode.dart';
import '../../../global/rental_fare_plan.dart';
import '../../../global/wallet.dart';
import '../../../repositories/tripsrepo.dart';
import '../../../widgets/coupons_list.dart';
import '../../auth/loginscreen.dart';
import '../../auth/new_auth/login_new.dart';
import '../../auth/new_auth/new_auth_selected.dart';
import '../Ride Confirm/confirmride.dart';
import '../widget/pickup_widget.dart';

class RentalPage extends StatefulWidget {
  final zoomDrawerController;
  RentalPage({Key? key, required this.zoomDrawerController}) : super(key: key);

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  int _selectedPlan = -1;
  int _selected = -1;
  int _vehicleSelected = 1;
  bool _smoke = true;
  bool _pets = false;
  bool _disabled = false;
  bool _airCondition = true;
  bool _extraLuggage = false;
  bool _child = true;
  int filterVal = 1;
  String cab = '';

  String _id = "0";
  String _name = "";

  //Google Map Things
  String googleApikey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng _currentLatLong = LatLng(currentLat, currentLong);
  String location = "Location Name:";

  //Recenter Button

  void setInitialLocation() async {
    CameraPosition cPosition = CameraPosition(
      zoom: 17,
      target: LatLng(currentLat, currentLong),
    );
    mapController!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  //Expande View

  bool expandeView = false;

  bool showService = false;

  // Service View

  Timer? rentServiceTim;

  List rentalSer = [];

  Future<List> getRentalServices(context, promoCodes) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? planID = _token.getString('planID');
    String apiUrl = estimatedFare;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer $userToken"},
      body: {
        "s_latitude": pickLat.toString(),
        "s_longitude": pikLong.toString(),
        "d_latitude": dropLat.toString(),
        "d_longitude": dropLong.toString(), "s_address": pickAdd,
        "d_address": dropadd,
        "fare_plan": planID.toString(),
        "fare_type": fareType.toString(),
        "schedule_date": scDate,
        "schedule_time": scTime,
        "promo_code": promoCodes,
        // "fare_setting": fare_setting_plan.toString(),
        "distance": distance.toStringAsFixed(4)
        // "s_latitude": pickLat.toString(),
        // "s_longitude": pikLong.toString(),
        // "d_latitude": dropLat.toString(),
        // "d_longitude": dropLong.toString(),
        // "distance": distance.toStringAsFixed(4),
        // "fare_plan": planID.toString(),
        // "fare_type": fareType.toString(),
        // "eta": ""
      },
    );
    debugPrint('movieTitle: ${response.body}');
    // ("Rental Services------------> ${response.body} ");
    if (response.statusCode == 200) {
      setState(() {
        rentalSer = jsonDecode(response.body)["Serivces"];
      });

      return jsonDecode(response.body)["Serivces"];
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

  //Clock

  String selectedDate = "";
  TextEditingController _couponData = TextEditingController();

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
        "schedule_date": schDate,
        "schedule_time": schTime,
        "fare_plan_name": rentalFarePlan.toString(),
        "fare_type": fareType.toString(),
        "fare_setting": fare_setting_plan.toString(),
        "eta": eta2.toString()
        // 'admin_id': adminId,
        // "s_latitude": pickLat.toStringAsFixed(4),
        // "s_longitude": pikLong.toStringAsFixed(4),
        // "d_latitude": dropLat.toStringAsFixed(4),
        // "d_longitude": dropLong.toStringAsFixed(4),
        // "service_type": _id.toString(),
        // "distance": distance.toStringAsFixed(4),
        // "use_wallet": "1",
        // 'payment_mode': paymentMode,
        // "s_address": pickAdd.toString(),
        // "d_address": dropadd.toString(),
        // "schedule_date": schDate.toString(),
        // "schedule_time": schTime.toString(),
        // "fare_plan": rentalFarePlan.toString(),
        // "fare_type": fareType.toString(),
        // "fare_setting": fare_setting_plan.toString()
      },
    );

    print("Rental Ride Schedule Request--------->     \n" +
        pickLat.toStringAsFixed(4) +
        " \n " +
        pikLong.toStringAsFixed(4) +
        " \n " +
        dropLat.toStringAsFixed(4) +
        " \n " +
        dropLong.toStringAsFixed(4) +
        " \n " +
        _id.toString() +
        " \n " +
        rentalFarePlan.toString() +
        " \n " +
        distance.toStringAsFixed(4) +
        " \n " +
        " 1 " +
        " \n " +
        " CASH " +
        " \n " +
        pickAdd.toString() +
        " \n " +
        dropadd.toString() +
        " \n " +
        schDate.toString() +
        " \n " +
        schTime.toString() +
        " \n " +
        fareType.toString() +
        " \n " +
        fare_setting_plan.toString());

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

    // Fluttertoast.showToast(
    //     msg: "------Rental Ride scheduled ride request" +
    //         "  \n  " +
    //         _id.toString() +
    //         " \n " +
    //         rentalFarePlan.toString() +
    //         " \n " +
    //         fareType.toString());

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
      });

      // Navigator.pop(context);
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

  //Google Maps

  PolylinePoints polylinePoints = PolylinePoints();

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
  Timer? timer;
  @override
  void initState() {
    // setCustomePickMarker();
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'PickUp Location ',
        snippet: pickAdd + "  ",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen), //Icon for Marker
      // icon: pickup
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Drop Location ',
        snippet: dropadd + "  ",
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getRentalServices(context, promoCode);

    getDirections(); //fetch direction polylines from Google API

    timer = Timer.periodic(
        eta2 == "" ? Duration(seconds: 15) : Duration(minutes: 15), (Timer t) {
      _eta2();
    });

    rentServiceTim = Timer.periodic(Duration(minutes: 15), (Timer t) {
      getRentalServices(context, promoCode);
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    rentServiceTim?.cancel();
    super.dispose();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      gooAPIKey,
      // PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(pickLat, pikLong),
      // PointLatLng(endLocation.latitude, endLocation.longitude),
      PointLatLng(dropLat, dropLong),
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

  String eta2 = "";

  _eta2() async {
    Dio dio = Dio();
    var response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$pickLat,$pikLong&destinations=$dropLat,$dropLong&key=$gooAPIKey");
    print("ETA------------------__>" + response.data.toString());
    setState(() {
      eta2 = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    });
    // Fluttertoast.showToast(msg: eta2);
  }

  //------------Distance---------//
  getDistance(kilo) async {
    double totalDistance = 0;

    totalDistance += calculateDistance(pickLat, pikLong, dropLat, dropLong);

    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    if (distance <= kilo) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideConfirm(
              dropLocation: dropadd,
            ),
          ));
    } else if (!fareTypeActive.any((element) => element["id"] == 16)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MapSample()));
      // EasyLoading.showToast("No partners available for the selected location");
    } else {
      showModalBottomSheet(
          isDismissible: false,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: outstationWarning(),
            );
          });
    }
  }

  outstationWarning() {
    var dr = dropadd.toString().split(",");
    return Container(
      height: MediaQuery.of(context).size.height / 2.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: whiteColor),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.amber,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Address: ",
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'MonB',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        dropadd + "." + " is out of city limit ",
                        maxLines: 4,
                        style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        "You can continue to book an outstation ride insted",
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'MonM',
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(1, 1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(-1, -1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  // child: Lottie.asset('assets/animation/warning.json',
                  //     fit: BoxFit.cover),
                  // child: Lottie.network(
                  //     "https://assets10.lottiefiles.com/packages/lf20_yd98d4m1.json"),
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: Colors.amber,
                    size: 56,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 29,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () async {
                  setState(() {
                    fareType = "16";
                    outstatus = true;
                    out = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideConfirm(
                        dropLocation: dropadd,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: const Center(
                    child: Text(
                      "Book OutStation Ride",
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: const Center(
                    child: Text(
                      "Change Drop Location",
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
    );
  }

  warningInfo(pack) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: whiteColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.red,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Rental Package warning: ",
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'MonB',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        pack +
                            " this pack can not be selected for the chossen destination from the selected pick up location.",
                        maxLines: 4,
                        style: TextStyle(
                          fontFamily: 'MonM',
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        "Please select a diffrent package according to your convenience",
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'MonM',
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(1, 1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(-1, -1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  // child: Lottie.asset('assets/animation/warning.json',
                  //     fit: BoxFit.cover),
                  // child: Lottie.network(
                  //     "https://assets10.lottiefiles.com/packages/lf20_yd98d4m1.json"),
                  child: Icon(
                    Icons.warning_amber,
                    color: Colors.red,
                    size: 56,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: const Center(
                    child: Text(
                      "Continue",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: fareTypeActive.any((element) => element["id"] == 15)
            ? AppBar(
                backgroundColor: whiteColor,
                titleSpacing: 0,
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        fareType = "15";
                        rentalFarePlan = "";
                        dropadd = "";
                      });
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
                    },
                    icon: Icon(Icons.arrow_back)),
                iconTheme: const IconThemeData(color: Colors.black),
                title: Text(
                  "retal".tr,
                  style: TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              )
            : null,
        // body: Stack(
        //   children: [
        //     SingleChildScrollView(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           const SizedBox(
        //             height: 12,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Material(
        //               elevation: 3,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(40),
        //               ),
        //               child: Container(
        //                 height: 40,
        //                 width: MediaQuery.of(context).size.width,
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(40),
        //                   color: const Color(0xFFF2F6F9),
        //                 ),
        //                 child: Row(
        //                   children: [
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                     Icon(
        //                       Icons.search,
        //                       color: Color(0xFF1473E6),
        //                     ),
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                     Expanded(
        //                       child: Text(
        //                         pickAdd,
        //                         maxLines: 1,
        //                         style: TextStyle(
        //                           fontFamily: 'MonS',
        //                           fontSize: 14,
        //                           color: kindaBlack,
        //                         ),
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ),
        //                     Icon(Icons.location_on_outlined, color: primaryColor),
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 12,
        //           ),
        //           const Padding(
        //             padding: EdgeInsets.only(left: 8.0),
        //             child: Text(
        //               "Vehicle Group",
        //               style: TextStyle(
        //                 fontFamily: 'MonS',
        //                 fontSize: 15,
        //                 color: kindaBlack,
        //               ),
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 20,
        //           ),
        //           _innerOptions(),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           Divider(
        //             color: kindaBlack.withOpacity(0.5),
        //           ),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           _timeSlot(),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           // filterVal == 2 ? _filterSections(cab) : _vehicleDetails()
        //           PickNDrop(
        //             drop: "1 Hour Ride",
        //           ),
        //         ],
        //       ),
        //     ),
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: Container(
        //         height: 100,
        //         color: whiteColor,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.end,
        //           children: [
        //             Divider(),
        //             Row(
        //               children: [
        //                 SizedBox(
        //                   width: 7,
        //                 ),
        //                 Expanded(
        //                   child: InkWell(
        //                     onTap: () {
        //                       showModalBottomSheet<void>(
        //                         isScrollControlled: true,
        //                         backgroundColor: Colors.transparent,
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(20),
        //                         ),
        //                         context: context,
        //                         builder: (BuildContext context) {
        //                           return Padding(
        //                             padding: MediaQuery.of(context).viewInsets,
        //                             child: PaymentSelection(),
        //                           );
        //                         },
        //                       );
        //                     },
        //                     child: Container(
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           Image.asset(
        //                             'assets/images/googlepay.png',
        //                             height: 20,
        //                             width: 30,
        //                           ),
        //                           SizedBox(
        //                             width: 5,
        //                           ),
        //                           Text(
        //                             "Google Pay",
        //                             style: TextStyle(
        //                               fontFamily: 'MonM',
        //                               fontSize: 12,
        //                               color: Colors.black,
        //                             ),
        //                             overflow: TextOverflow.ellipsis,
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: 7,
        //                 ),
        //                 Container(
        //                   height: 15,
        //                   width: 1,
        //                   color: Colors.black.withOpacity(0.3),
        //                 ),
        //                 SizedBox(
        //                   width: 7,
        //                 ),
        //                 Expanded(
        //                   child: InkWell(
        //                     onTap: () {
        //                       // cuponCode
        //                       showModalBottomSheet<void>(
        //                         isScrollControlled: true,
        //                         backgroundColor: Colors.transparent,
        //                         shape: RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.circular(20),
        //                         ),
        //                         context: context,
        //                         builder: (BuildContext context) {
        //                           return Padding(
        //                             padding: MediaQuery.of(context).viewInsets,
        //                             child: cuponCode(
        //                               context,
        //                             ),
        //                           );
        //                         },
        //                       );
        //                     },
        //                     child: Container(
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           Image.asset('assets/icons/tag.png',
        //                               height: 20,
        //                               width: 30,
        //                               color: Colors.green.shade700),
        //                           SizedBox(
        //                             width: 5,
        //                           ),
        //                           Text(
        //                             "Coupon",
        //                             style: TextStyle(
        //                               fontFamily: 'MonM',
        //                               fontSize: 12,
        //                               color: Colors.black,
        //                             ),
        //                             overflow: TextOverflow.ellipsis,
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 15,
        //                   width: 1,
        //                   color: Colors.black.withOpacity(0.3),
        //                 ),
        //                 SizedBox(
        //                   width: 7,
        //                 ),
        //                 Expanded(
        //                   child: Container(
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         Icon(Icons.person),
        //                         SizedBox(
        //                           width: 5,
        //                         ),
        //                         Text(
        //                           "My Self",
        //                           style: TextStyle(
        //                             fontFamily: 'MonM',
        //                             fontSize: 12,
        //                             color: Colors.black,
        //                           ),
        //                           overflow: TextOverflow.ellipsis,
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: 7,
        //                 ),
        //               ],
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Container(
        //               width: MediaQuery.of(context).size.width,
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(0),
        //                 color: Colors.black,
        //               ),
        //               child: Center(
        //                 child: Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 12.0),
        //                   child: Text(
        //                     "Select Ride",
        //                     style: TextStyle(
        //                       fontFamily: 'MonS',
        //                       fontSize: 17,
        //                       color: whiteColor,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: expandeView == false
                    ? fareTypeActive.any((element) => element["id"] != 15) &&
                            fareTypeActive.any((element) => element["id"] == 17)
                        ? MediaQuery.of(context).size.height / 2.5
                        : MediaQuery.of(context).size.height / 4.1
                    : MediaQuery.of(context).size.height / 1.4,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    GoogleMap(
                      scrollGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>[
                        new Factory<OneSequenceGestureRecognizer>(
                          () => new EagerGestureRecognizer(),
                        ),
                      ].toSet(),
                      //Map widget from google_maps_flutter package
                      zoomGesturesEnabled: true, //enable Zoom in, out on map
                      initialCameraPosition: CameraPosition(
                        //innital position in map
                        target: startLocation, //initial position
                        zoom: 17.0, //initial zoom level
                      ),
                      mapType: MapType.normal, //map type
                      onMapCreated: (controller) {
                        //method called when map is created
                        setState(() {
                          mapController = controller;
                          mapController!.setMapStyle(mapStyle);
                        });
                      },
                      onCameraMove: (CameraPosition cameraPositiona) {
                        cameraPosition = cameraPositiona; //when map is dragging
                      },
                      onCameraIdle: () async {
                        //when map drag stops
                        List<Placemark> placemarks =
                            await placemarkFromCoordinates(
                                cameraPosition!.target.latitude,
                                cameraPosition!.target.longitude);
                        setState(() {
                          //get place name from lat and lang
                          location = placemarks.first.street.toString() +
                              ", " +
                              placemarks.first.name.toString() +
                              "," +
                              placemarks.first.subLocality.toString() +
                              "," +
                              placemarks.first.locality.toString() +
                              "," +
                              placemarks.first.postalCode.toString() +
                              "," +
                              placemarks.first.country.toString();

                          pickAdd = location;
                          pickLat = cameraPosition!.target.latitude;
                          pikLong = cameraPosition!.target.longitude;
                        });
                        // Fluttertoast.showToast(
                        //     msg: cameraPosition!.target.latitude
                        //             .toStringAsFixed(4) +
                        //         "    " +
                        //         cameraPosition!.target.longitude
                        //             .toStringAsFixed(4) +
                        //         "    " +
                        //         placemarks.first.postalCode.toString());
                      },
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
                                  //first paramerter of offset is left-right
                                  //second parameter is top to down
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
                    SafeArea(
                      child: Row(
                        children: [
                          fareTypeActive.any((element) => element["id"] == 15)
                              ? SizedBox()
                              : Align(
                                  alignment: Alignment.topLeft,
                                  child: InkWell(
                                    onTap: () {
                                      widget.zoomDrawerController.toggle();
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
                                              color: Colors.grey.withOpacity(
                                                  0.3), //color of shadow
                                              spreadRadius: 2, //spread radius
                                              blurRadius: 2, // blur radius
                                              offset: Offset(1,
                                                  2), // changes position of shadow
                                              //first paramerter of offset is left-right
                                              //second parameter is top to down
                                            ),
                                            //you can set more BoxShadow() here
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.3), //color of shadow
                                              spreadRadius: 2, //spread radius
                                              blurRadius: 2, // blur radius
                                              offset: Offset(2,
                                                  1), // changes position of shadow
                                              //first paramerter of offset is left-right
                                              //second parameter is top to down
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Icon(Icons.menu),
                                      ),
                                    ),
                                  ),
                                ),
                          Spacer(),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  expandeView = !expandeView;
                                });
                                // setInitialLocation();
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
                                        //first paramerter of offset is left-right
                                        //second parameter is top to down
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
                                  child: Icon(Icons.zoom_in_map),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      //picker image on google map
                      child: RippleAnimation(
                        color: Color(0xFF395B64),
                        repeat: true,
                        minRadius: 20,
                        ripplesCount: 3,
                        child: Image.asset(
                          "assets/images/startmark.png",
                          width: 20,
                        ),
                      ),
                    ),

                    // PickUp(),
                  ],
                ),
              ),
              SizedBox(height: 15),
              _innerOptions(),
              SizedBox(height: 15),
              PickUp(),
              _dropWid(context),
              Visibility(
                visible: dropadd == "" ? false : true,
                child: Column(children: [
                  SizedBox(height: 8),
                  _timeSlots(),
                  SizedBox(
                    height: 12,
                  ),
                  showService != true
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "Select Ride",
                                    style: TextStyle(
                                      fontFamily: 'MonS',
                                      fontSize: 15,
                                      color: kindaBlack,
                                    ),
                                  ),
                                ),
                              ),
                              sched_acc == false
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        // var date = selectedDate.toString().split(" ");
                                        // var date1 = date[0].toString();
                                        // var date2 = date[1].toString().split(".");
                                        // var mainTime = date2[0].toString();
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
                                            maxTime:
                                                today.add(Duration(days: 7)),
                                            showTitleActions: true,
                                            onChanged: (date) {
                                          setState(() {
                                            selectedDate = date == today
                                                ? ""
                                                : date.toString();
                                            // serviceTime =
                                            //     date == today ? "" : date.toString();
                                          });
                                          // print('change $date in time zone ' +
                                          //     date.timeZoneOffset.inHours.toString());
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                        }, currentTime: today);
                                        // showDialog(
                                        //     barrierDismissible: false,
                                        //     context: context,
                                        //     builder: (context) {
                                        //       var today = DateTime.now();
                                        //       return Dialog(
                                        //         child: SpinnerDateTimePicker(
                                        //           initialDateTime: today,
                                        //           maximumDate: today
                                        //               .add(const Duration(days: 7)),
                                        //           minimumDate: today,
                                        //           mode: CupertinoDatePickerMode
                                        //               .dateAndTime,
                                        //           use24hFormat: true,
                                        //           didSetTime: (value) {
                                        //             setState(() {
                                        //               selectedDate = value == today
                                        //                   ? ""
                                        //                   : value.toString();
                                        //             });
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
                                              color: Colors.grey.withOpacity(
                                                  0.2), //color of shadow
                                              spreadRadius: 1, //spread radius
                                              blurRadius: 1, // blur radius
                                              offset: Offset(0,
                                                  1), // changes position of shadow
                                              //first paramerter of offset is left-right
                                              //second parameter is top to down
                                            ),
                                            //you can set more BoxShadow() here
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                                  ? Builder(builder: (context) {
                                                      // DateTime date1 =
                                                      //     selectedDate == ""
                                                      //         ? DateTime.now()
                                                      //         : DateTime.parse(
                                                      //             selectedDate);
                                                      // // Format the date to display as "21 May, 08:00 AM"
                                                      // String formattedDate =
                                                      //     DateFormat(
                                                      //             'dd MMM, hh:mm a')
                                                      //         .format(date1);
                                                      return Text(
                                                        // formattedDate,
                                                        "Now",

                                                        style: TextStyle(
                                                          fontFamily: 'MonM',
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                        ),
                                                      );
                                                    })
                                                  : Builder(builder: (context) {
                                                      DateTime date1 =
                                                          selectedDate == ""
                                                              ? DateTime.now()
                                                              : DateTime.parse(
                                                                  selectedDate);
                                                      // Format the date to display as "21 May, 08:00 AM"
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'dd MMM, hh:mm a')
                                                              .format(date1);
                                                      return Text(
                                                        formattedDate,
                                                        style: TextStyle(
                                                          fontFamily: 'MonM',
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                        ),
                                                      );
                                                    }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                  showService != true
                      ? SizedBox()
                      : SizedBox(
                          height: 10,
                        ),
                  showService != true
                      ? SizedBox()
                      : Column(
                          children: [
                            rentalSer.isEmpty
                                ? Align(
                                    child: Center(
                                      child: Container(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator()),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: rentalSer.length,
                                    itemBuilder: ((context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedPlan = index;
                                            _id = rentalSer[index]['id']
                                                .toString();
                                            _name = rentalSer[index]['name'];
                                            fare_setting_plan = rentalSer[index]
                                                    ['fare_setting_id']
                                                .toString();
                                          });
                                          // Fluttertoast.showToast(msg: _id + "  " + _name);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: whiteColor,
                                              boxShadow: [
                                                _selectedPlan == index
                                                    ? BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.2), //color of shadow
                                                        spreadRadius:
                                                            1, //spread radius
                                                        blurRadius:
                                                            2, // blur radius
                                                        offset: Offset(0,
                                                            2), // changes position of shadow
                                                        //first paramerter of offset is left-right
                                                        //second parameter is top to down
                                                      )
                                                    : BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.0), //color of shadow
                                                        spreadRadius:
                                                            0, //spread radius
                                                        blurRadius:
                                                            0, // blur radius
                                                        offset: Offset(0,
                                                            0), // changes position of shadow
                                                        //first paramerter of offset is left-right
                                                        //second parameter is top to down
                                                      ),
                                                //you can set more BoxShadow() here
                                              ],
                                              border: Border.all(
                                                  color: _selectedPlan == index
                                                      ? primaryColor
                                                      : Colors.white,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: _selectedPlan == index
                                                  ? const EdgeInsets.all(8.0)
                                                  : const EdgeInsets.all(0.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            //     boxShadow: [
                                                            //   BoxShadow(
                                                            //     color: Colors
                                                            //         .grey
                                                            //         .withOpacity(
                                                            //             0.2), //color of shadow
                                                            //     spreadRadius:
                                                            //         1, //spread radius
                                                            //     blurRadius:
                                                            //         2, // blur radius
                                                            //     offset: Offset(
                                                            //         0,
                                                            //         2), // changes position of shadow
                                                            //     //first paramerter of offset is left-right
                                                            //     //second parameter is top to down
                                                            //   ),
                                                            //   //you can set more BoxShadow() here
                                                            // ],
                                                            // color:
                                                            //     whiteColor,
                                                            image: DecorationImage(
                                                          image: NetworkImage(rentalSer[
                                                                          index]
                                                                      [
                                                                      'vehicle_image'] ==
                                                                  null
                                                              ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Circle-icons-car.svg/1200px-Circle-icons-car.svg.png'
                                                              : "http://ondeindia.com/storage/app/public/" +
                                                                  rentalSer[
                                                                          index]
                                                                      [
                                                                      'vehicle_image']),
                                                        )),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        rentalSer[index]['eta']
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          rentalSer[index]
                                                                  ['name']
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: kindaBlack,
                                                            fontSize: 15,
                                                            fontFamily: 'MonM',
                                                          ),
                                                        ),
                                                        // SizedBox(height: 5),
                                                        // Text(
                                                        //   "Capacity " +
                                                        //       rentalSer[index]
                                                        //               ['capacity']
                                                        //           .toString(),
                                                        //   style: TextStyle(
                                                        //     color:
                                                        //         kindaBlack.withOpacity(0.5),
                                                        //     fontSize: 10,
                                                        //     fontFamily: 'MonR',
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet<
                                                          void>(
                                                        isScrollControlled:
                                                            true,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Padding(
                                                            padding:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets,
                                                            child:
                                                                rideConfirmSection(
                                                              context,
                                                              rentalSer[index]
                                                                  ['name'],
                                                              rentalSer[index][
                                                                      'estimated_fare']
                                                                  .toString(),
                                                              mainETA,
                                                              // rentalSer[index]['dis']
                                                              //     .toString(),
                                                              rentalSer[index][
                                                                      'running_charge']
                                                                  .toString(),
                                                              rentalSer[index][
                                                                  'description'],

                                                              rentalSer[index][
                                                                  'vehicle_image'],

                                                              rentalSer[index][
                                                                  'waiting_charge'],
                                                              rentalSer[index][
                                                                  'service_description'],
                                                              rentalSer[index]
                                                                  ['one'],
                                                              rentalSer[index]
                                                                  ['two'],
                                                              rentalSer[index]
                                                                  ['three'],
                                                              rentalSer[index]
                                                                  ['four'],
                                                              rentalSer[index]
                                                                  ['five'],
                                                              rentalSer[index]
                                                                  ['six'],
                                                              rentalSer[index]
                                                                  ['seven'],
                                                              rentalSer[index]
                                                                  ['eight'],
                                                              rentalSer[index]
                                                                  ['seater'],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: const Color(
                                                            0xFFF2F6F9),
                                                      ),
                                                      child: const Icon(
                                                        Icons.info_outline,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      // Text(
                                                      //   rentalSer[index][
                                                      //                   'final_fare'] ==
                                                      //               null ||
                                                      //           rentalSer[index]
                                                      //                   [
                                                      //                   'estimated_fare'] ==
                                                      //               null
                                                      //       ? ""
                                                      //       : rentalSer[index]
                                                      //                   [
                                                      //                   'final_fare'] ==
                                                      //               ""
                                                      //           ? rentalSer[
                                                      //                       index]
                                                      //                       [
                                                      //                       'estimated_fare']
                                                      //                   .toString() +
                                                      //               " ₹"
                                                      //           : snapshot
                                                      //                   .data![index]
                                                      //                       ['final_fare']
                                                      //                   .toString() +
                                                      //               " ₹",
                                                      //   style: TextStyle(
                                                      //     color: secondaryColor,
                                                      //     fontSize: 15,
                                                      //     fontFamily: 'MonS',
                                                      //   ),
                                                      // ),
                                                      // rentalSer[index][
                                                      //             'final_fare'] ==
                                                      //         ""
                                                      //     ? Text(
                                                      //         "",
                                                      //         style: TextStyle(
                                                      //             color:
                                                      //                 Colors.grey,
                                                      //             fontSize: 1,
                                                      //             fontFamily:
                                                      //                 'MonR',
                                                      //             decoration:
                                                      //                 TextDecoration
                                                      //                     .lineThrough),
                                                      //       )
                                                      //     : Text(
                                                      //         rentalSer[
                                                      //                     index][
                                                      //                     'estimated_fare']
                                                      //                 .toString() +
                                                      //             " ₹",
                                                      //         style: TextStyle(
                                                      //             color:
                                                      //                 Colors.grey,
                                                      //             fontSize: 12,
                                                      //             fontFamily:
                                                      //                 'MonR',
                                                      //             decoration:
                                                      //                 TextDecoration
                                                      //                     .lineThrough),
                                                      //       ),
                                                      //-----------Main Rental Price
                                                      Text(
                                                        rentalSer[index][
                                                                    'estimated_fare'] ==
                                                                null
                                                            ? "0" + " ₹"
                                                            : rentalSer[index][
                                                                        'estimated_fare']
                                                                    .toString() +
                                                                " ₹",
                                                        style: TextStyle(
                                                          color: secondaryColor,
                                                          fontSize: 15,
                                                          fontFamily: 'MonS',
                                                        ),
                                                      ),
                                                      //------------Main Rental Price-----------
                                                      // SizedBox(height: 5),
                                                      // Text(
                                                      //   snapshot.data![index]['estimated_fare'] == null
                                                      //       ? "0" + " ₹"
                                                      //       : snapshot.data![index]['estimated_fare']
                                                      //               .toString() +
                                                      //           " ₹",
                                                      //   style: TextStyle(
                                                      //     color: kindaBlack.withOpacity(0.5),
                                                      //     fontSize: 10,
                                                      //     fontFamily: 'MonR',
                                                      //     decoration:
                                                      //         TextDecoration.lineThrough,
                                                      //   ),
                                                      // ),
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
                                height: selectedDate != "" ? 170 : 130,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.2), //color of shadow
                                      spreadRadius: 1, //spread radius
                                      blurRadius: 2, // blur radius
                                      offset: Offset(
                                          0, 2), // changes position of shadow
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: PaymentSelection(),
                                                  );
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    paymentMode == "WALLET"
                                                        ? Icon(Icons.wallet,
                                                            color: Colors
                                                                .green.shade700)
                                                        : Icon(
                                                            Icons
                                                                .money_outlined,
                                                            color: Colors.green
                                                                .shade700),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(paymentMode,
                                                        style: TextStyle(
                                                          fontFamily: 'MonM',
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center),
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: _enterCupons(),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/icons/tag.png',
                                                      height: 20,
                                                      width: 30,
                                                      color: Colors
                                                          .green.shade700),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                        // SizedBox(
                                        //   width: 7,
                                        // ),
                                        // Expanded(
                                        //   child: Container(
                                        //     child: Row(
                                        //       mainAxisAlignment:
                                        //           MainAxisAlignment.center,
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
                                        //           overflow:
                                        //               TextOverflow.ellipsis,
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   width: 7,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //scheduleRide(context, date1, mainTime);
                                    selectedDate == ""
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Container(
                                              height: 60,
                                              child: ActionSlider.standard(
                                                toggleColor: white,
                                                sliderBehavior:
                                                    SliderBehavior.stretch,
                                                height: 60,
                                                backgroundColor: Colors.black,
                                                child: Center(
                                                  child: Text(
                                                    "Book Ride $_name",
                                                    style: TextStyle(
                                                      fontFamily: 'MonS',
                                                      fontSize: 17,
                                                      color: whiteColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                action: (controller) async {
                                                  //starts loading animation
                                                  if (_selected == -1) {
                                                    controller.loading();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    controller.failure();
                                                    controller.reset();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please Select a Package");
                                                  } else if (_selectedPlan ==
                                                      -1) {
                                                    controller.loading();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    controller.failure();
                                                    controller.reset();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please Select a Ride");
                                                  } else {
                                                    controller.loading();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    controller.success();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 2));

                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookRideSection(
                                                          serviceID: _id,
                                                          serviceName: _name,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  //starts success animation
                                                },
                                                // ... //many more parameters
                                              ),
                                            ),
                                          )
                                        // ? Container(
                                        //     margin: EdgeInsets.symmetric(
                                        //         horizontal: 12),
                                        //     width: MediaQuery.of(context)
                                        //         .size
                                        //         .width,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(50),
                                        //       color: Colors.black,
                                        //     ),
                                        //     child: InkWell(
                                        //       onTap: () async {
                                        //         // var date = selectedDate.toString().split(" ");
                                        //         // var date1 = date[0].toString();
                                        //         // var date2 = date[1].toString().split(".");
                                        //         // var mainTime = date2[0].toString();
                                        //         // showFareDialog(context);
                                        //         // String rideID = snapshot.data![index]['id']
                                        //         // getRideFare(context, _id, _name);
                                        // if (_selected == -1) {
                                        //   Fluttertoast.showToast(
                                        //       msg:
                                        //           "Please Select a Package");
                                        // } else if (_selectedPlan ==
                                        //     -1) {
                                        //   Fluttertoast.showToast(
                                        //       msg:
                                        //           "Please Select a Ride");
                                        // } else {
                                        //   Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           BookRideSection(
                                        //         serviceID: _id,
                                        //         serviceName: _name,
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                        //       },
                                        //       child: Center(
                                        //         child: Padding(
                                        //           padding: const EdgeInsets
                                        //               .symmetric(
                                        //               vertical: 18.0),
                                        //           child: Text(
                                        //             "Book Ride $_name",
                                        //             style: TextStyle(
                                        //               fontFamily: 'MonS',
                                        //               fontSize: 17,
                                        //               color: whiteColor,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   )
                                        : Column(
                                            children: [
                                              Builder(builder: (context) {
                                                var date = selectedDate
                                                    .toString()
                                                    .split(" ");
                                                DateTime date1 = DateTime.parse(
                                                    selectedDate);
                                                // Format the date to display as "21 May, 08:00 AM"
                                                String formattedDate =
                                                    DateFormat(
                                                            'dd MMM, hh:mm a')
                                                        .format(date1);
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                  height: 60,
                                                  child: ActionSlider.standard(
                                                    toggleColor: white,
                                                    sliderBehavior:
                                                        SliderBehavior.stretch,
                                                    height: 60,
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: Center(
                                                      child: Builder(
                                                          builder: (context) {
                                                        var date = selectedDate
                                                            .toString()
                                                            .split(" ");
                                                        var date1 =
                                                            date[0].toString();
                                                        return Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        18.0),
                                                            child: Text(
                                                                "Schedule $_name",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'MonS',
                                                                  fontSize: 14,
                                                                  color:
                                                                      whiteColor,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    action: (controller) async {
                                                      var date = selectedDate
                                                          .toString()
                                                          .split(" ");
                                                      var date1 =
                                                          date[0].toString();
                                                      var date2 = date[1]
                                                          .toString()
                                                          .split(".");
                                                      var mainTime =
                                                          date2[0].toString();

                                                      if (_selected == -1) {
                                                        controller.loading();
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        controller.failure();
                                                        controller.reset();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Please Select a Package");
                                                      } else if (_selectedPlan ==
                                                          -1) {
                                                        controller.loading();
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        controller.failure();
                                                        controller.reset();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Please Select a Ride");
                                                      } else {
                                                        controller.loading();
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 1));

                                                        // Fluttertoast.showToast(
                                                        //     msg: date1
                                                        //             .toString() +
                                                        //         "   " +
                                                        //         mainTime
                                                        //             .toString());
                                                        showLoaderDialog(
                                                            context,
                                                            "Schedulling Ride...",
                                                            70);
                                                        controller.success();
                                                        await scheduleRide(
                                                            context,
                                                            date1,
                                                            mainTime);
                                                        // await scheduleRide(
                                                        //     context, date1, "");
                                                      }
                                                      //starts success animation
                                                    },
                                                    // ... //many more parameters
                                                  ),
                                                ),
                                              )
                                              // Container(
                                              //   margin: EdgeInsets.symmetric(
                                              //       horizontal: 12),
                                              //   width: MediaQuery.of(context)
                                              //       .size
                                              //       .width,
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(50),
                                              //     color: Colors.black,
                                              //   ),
                                              //   child: InkWell(
                                              //     onTap: () async {
                                              // var date = selectedDate
                                              //     .toString()
                                              //     .split(" ");
                                              // var date1 =
                                              //     date[0].toString();
                                              // var date2 = date[1]
                                              //     .toString()
                                              //     .split(".");
                                              // var mainTime =
                                              //     date2[0].toString();

                                              // if (_selected == -1) {
                                              //   Fluttertoast.showToast(
                                              //       msg:
                                              //           "Please Select a Package");
                                              // } else if (_selectedPlan ==
                                              //     -1) {
                                              //   Fluttertoast.showToast(
                                              //       msg:
                                              //           "Please Select a Ride");
                                              // } else {
                                              //   // Fluttertoast.showToast(
                                              //   //     msg: date1
                                              //   //             .toString() +
                                              //   //         "   " +
                                              //   //         mainTime
                                              //   //             .toString());
                                              //   showLoaderDialog(
                                              //       context,
                                              //       "Schedulling Ride...",
                                              //       10);
                                              //   await scheduleRide(
                                              //       context,
                                              //       date1,
                                              //       mainTime);
                                              //   // await scheduleRide(
                                              //   //     context, date1, "");
                                              // }
                                              //       // showFareDialog(context);
                                              //       // String rideID = snapshot.data![index]['id']
                                              //       // getRideFare(context, _id, _name);

                                              //       // Fluttertoast.showToast(
                                              //       //     msg: mainTime +
                                              //       //         "    " +
                                              //       //         date1);
                                              //     },
                                              // child: Builder(
                                              //     builder: (context) {
                                              //   var date = selectedDate
                                              //       .toString()
                                              //       .split(" ");
                                              //   var date1 =
                                              //       date[0].toString();
                                              //   return Center(
                                              //     child: Padding(
                                              //       padding:
                                              //           const EdgeInsets
                                              //               .symmetric(
                                              //               vertical: 18.0),
                                              //       child: Text(
                                              //         "Schedule $_name",
                                              //         style: TextStyle(
                                              //           fontFamily: 'MonS',
                                              //           fontSize: 14,
                                              //           color: whiteColor,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   );
                                              // }),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )

                  // rentalSer

                  // FutureBuilder(
                  //     future: getRentalServices(context, promoCode),
                  //     builder: (context, AsyncSnapshot<List> snapshot) {
                  //       if (!snapshot.hasData) {
                  //         return const Center(
                  //           child: SizedBox(
                  //             height: 30,
                  //             width: 30,
                  //             child: CircularProgressIndicator(
                  //               backgroundColor: kindaBlack,
                  //               color: primaryColor,
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //       if (snapshot.data!.isEmpty) {
                  //         return const Center(
                  //           child: SizedBox(
                  //             height: 30,
                  //             child: Center(
                  //               child: Text(
                  //                 "No Services Available at the moment",
                  //                 style: TextStyle(
                  //                   fontFamily: 'MonM',
                  //                   fontSize: 12,
                  //                   color: Colors.black,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //       return Column(
                  //         children: [
                  //           ListView.builder(
                  //             scrollDirection: Axis.vertical,
                  //             shrinkWrap: true,
                  //             physics: NeverScrollableScrollPhysics(),
                  //             itemCount: snapshot.data!.length,
                  //             itemBuilder: ((context, index) {
                  //               return InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     _selectedPlan = index;
                  //                     _id = snapshot.data![index]['id']
                  //                         .toString();
                  //                     _name = snapshot.data![index]['name'];
                  //                     fare_setting_plan = snapshot
                  //                         .data![index]['fare_setting_id']
                  //                         .toString();
                  //                   });
                  //                   // Fluttertoast.showToast(msg: _id + "  " + _name);
                  //                 },
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Container(
                  //                     decoration: BoxDecoration(
                  //                       color: whiteColor,
                  //                       boxShadow: [
                  //                         _selectedPlan == index
                  //                             ? BoxShadow(
                  //                                 color: Colors.grey
                  //                                     .withOpacity(
                  //                                         0.2), //color of shadow
                  //                                 spreadRadius:
                  //                                     1, //spread radius
                  //                                 blurRadius:
                  //                                     2, // blur radius
                  //                                 offset: Offset(0,
                  //                                     2), // changes position of shadow
                  //                                 //first paramerter of offset is left-right
                  //                                 //second parameter is top to down
                  //                               )
                  //                             : BoxShadow(
                  //                                 color: Colors.grey
                  //                                     .withOpacity(
                  //                                         0.0), //color of shadow
                  //                                 spreadRadius:
                  //                                     0, //spread radius
                  //                                 blurRadius:
                  //                                     0, // blur radius
                  //                                 offset: Offset(0,
                  //                                     0), // changes position of shadow
                  //                                 //first paramerter of offset is left-right
                  //                                 //second parameter is top to down
                  //                               ),
                  //                         //you can set more BoxShadow() here
                  //                       ],
                  //                       border: Border.all(
                  //                           color: _selectedPlan == index
                  //                               ? primaryColor
                  //                               : Colors.white,
                  //                           width: 2),
                  //                       borderRadius:
                  //                           BorderRadius.circular(10),
                  //                     ),
                  //                     child: Padding(
                  //                       padding: _selectedPlan == index
                  //                           ? const EdgeInsets.all(8.0)
                  //                           : const EdgeInsets.all(0.0),
                  //                       child: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.start,
                  //                         children: [
                  //                           Column(
                  //                             children: [
                  //                               Container(
                  //                                 height: 50,
                  //                                 width: 50,
                  //                                 decoration: BoxDecoration(
                  //                                     borderRadius:
                  //                                         BorderRadius
                  //                                             .circular(80),
                  //                                     boxShadow: [
                  //                                       BoxShadow(
                  //                                         color: Colors.grey
                  //                                             .withOpacity(
                  //                                                 0.2), //color of shadow
                  //                                         spreadRadius:
                  //                                             1, //spread radius
                  //                                         blurRadius:
                  //                                             2, // blur radius
                  //                                         offset: Offset(0,
                  //                                             2), // changes position of shadow
                  //                                         //first paramerter of offset is left-right
                  //                                         //second parameter is top to down
                  //                                       ),
                  //                                       //you can set more BoxShadow() here
                  //                                     ],
                  //                                     color: whiteColor,
                  //                                     image:
                  //                                         DecorationImage(
                  //                                       image: NetworkImage(snapshot
                  //                                                       .data![index]
                  //                                                   [
                  //                                                   'vehicle_image'] ==
                  //                                               null
                  //                                           ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Circle-icons-car.svg/1200px-Circle-icons-car.svg.png'
                  //                                           : "http://ondeindia.com/storage/app/public/" +
                  //                                               snapshot.data![
                  //                                                       index]
                  //                                                   [
                  //                                                   'vehicle_image']),
                  //                                       fit: BoxFit.cover,
                  //                                     )),
                  //                               ),
                  //                               SizedBox(height: 5),
                  //                               Text(
                  //                                 snapshot.data![index]
                  //                                         ['eta']
                  //                                     .toString(),
                  //                                 style: TextStyle(
                  //                                   color: kindaBlack,
                  //                                   fontSize: 10,
                  //                                   fontFamily: 'MonM',
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           SizedBox(
                  //                             width: 10,
                  //                           ),
                  //                           Expanded(
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment
                  //                                       .start,
                  //                               children: [
                  //                                 Text(
                  //                                   snapshot.data![index]
                  //                                           ['name']
                  //                                       .toString(),
                  //                                   style: TextStyle(
                  //                                     color: kindaBlack,
                  //                                     fontSize: 15,
                  //                                     fontFamily: 'MonM',
                  //                                   ),
                  //                                 ),
                  //                                 // SizedBox(height: 5),
                  //                                 // Text(
                  //                                 //   "Capacity " +
                  //                                 //       snapshot.data![index]
                  //                                 //               ['capacity']
                  //                                 //           .toString(),
                  //                                 //   style: TextStyle(
                  //                                 //     color:
                  //                                 //         kindaBlack.withOpacity(0.5),
                  //                                 //     fontSize: 10,
                  //                                 //     fontFamily: 'MonR',
                  //                                 //   ),
                  //                                 // ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           InkWell(
                  //                             onTap: () {
                  //                               showModalBottomSheet<void>(
                  //                                 isScrollControlled: true,
                  //                                 backgroundColor:
                  //                                     Colors.transparent,
                  //                                 shape:
                  //                                     RoundedRectangleBorder(
                  //                                   borderRadius:
                  //                                       BorderRadius
                  //                                           .circular(20),
                  //                                 ),
                  //                                 context: context,
                  //                                 builder: (BuildContext
                  //                                     context) {
                  //                                   return Padding(
                  //                                     padding:
                  //                                         MediaQuery.of(
                  //                                                 context)
                  //                                             .viewInsets,
                  //                                     child:
                  //                                         rideConfirmSection(
                  //                                       context,
                  //                                       snapshot.data![
                  //                                           index]['name'],
                  //                                       snapshot
                  //                                           .data![index][
                  //                                               'estimated_fare']
                  //                                           .toString(),
                  //                                       mainETA,
                  //                                       // snapshot.data![index]['dis']
                  //                                       //     .toString(),
                  //                                       snapshot
                  //                                           .data![index][
                  //                                               'running_charge']
                  //                                           .toString(),
                  //                                       snapshot.data![
                  //                                               index]
                  //                                           ['description'],

                  //                                       snapshot.data![
                  //                                               index][
                  //                                           'vehicle_image'],

                  //                                       snapshot.data![
                  //                                               index][
                  //                                           'waiting_charge'],
                  //                                       snapshot.data![
                  //                                               index][
                  //                                           'service_description'],
                  //                                       snapshot.data![
                  //                                           index]['one'],
                  //                                       snapshot.data![
                  //                                           index]['two'],
                  //                                       snapshot.data![
                  //                                           index]['three'],
                  //                                       snapshot.data![
                  //                                           index]['four'],
                  //                                       snapshot.data![
                  //                                           index]['five'],
                  //                                       snapshot.data![
                  //                                           index]['six'],
                  //                                       snapshot.data![
                  //                                           index]['seven'],
                  //                                       snapshot.data![
                  //                                           index]['eight'],
                  //                                       snapshot.data![
                  //                                               index]
                  //                                           ['seater'],
                  //                                     ),
                  //                                   );
                  //                                 },
                  //                               );
                  //                             },
                  //                             child: Container(
                  //                               height: 20,
                  //                               width: 20,
                  //                               decoration: BoxDecoration(
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(
                  //                                         50),
                  //                                 color: const Color(
                  //                                     0xFFF2F6F9),
                  //                               ),
                  //                               child: const Icon(
                  //                                 Icons.info_outline,
                  //                                 size: 15,
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           const SizedBox(
                  //                             width: 5,
                  //                           ),
                  //                           Column(
                  //                             crossAxisAlignment:
                  //                                 CrossAxisAlignment.end,
                  //                             children: [
                  //                               // Text(
                  //                               //   snapshot.data![index][
                  //                               //                   'final_fare'] ==
                  //                               //               null ||
                  //                               //           snapshot.data![index]
                  //                               //                   [
                  //                               //                   'estimated_fare'] ==
                  //                               //               null
                  //                               //       ? ""
                  //                               //       : snapshot.data![index]
                  //                               //                   [
                  //                               //                   'final_fare'] ==
                  //                               //               ""
                  //                               //           ? snapshot.data![
                  //                               //                       index]
                  //                               //                       [
                  //                               //                       'estimated_fare']
                  //                               //                   .toString() +
                  //                               //               " ₹"
                  //                               //           : snapshot
                  //                               //                   .data![index]
                  //                               //                       ['final_fare']
                  //                               //                   .toString() +
                  //                               //               " ₹",
                  //                               //   style: TextStyle(
                  //                               //     color: secondaryColor,
                  //                               //     fontSize: 15,
                  //                               //     fontFamily: 'MonS',
                  //                               //   ),
                  //                               // ),
                  //                               // snapshot.data![index][
                  //                               //             'final_fare'] ==
                  //                               //         ""
                  //                               //     ? Text(
                  //                               //         "",
                  //                               //         style: TextStyle(
                  //                               //             color:
                  //                               //                 Colors.grey,
                  //                               //             fontSize: 1,
                  //                               //             fontFamily:
                  //                               //                 'MonR',
                  //                               //             decoration:
                  //                               //                 TextDecoration
                  //                               //                     .lineThrough),
                  //                               //       )
                  //                               //     : Text(
                  //                               //         snapshot.data![
                  //                               //                     index][
                  //                               //                     'estimated_fare']
                  //                               //                 .toString() +
                  //                               //             " ₹",
                  //                               //         style: TextStyle(
                  //                               //             color:
                  //                               //                 Colors.grey,
                  //                               //             fontSize: 12,
                  //                               //             fontFamily:
                  //                               //                 'MonR',
                  //                               //             decoration:
                  //                               //                 TextDecoration
                  //                               //                     .lineThrough),
                  //                               //       ),
                  //                               //-----------Main Rental Price
                  //                               Text(
                  //                                 snapshot.data![index][
                  //                                             'estimated_fare'] ==
                  //                                         null
                  //                                     ? "0" + " ₹"
                  //                                     : snapshot
                  //                                             .data![index][
                  //                                                 'estimated_fare']
                  //                                             .toString() +
                  //                                         " ₹",
                  //                                 style: TextStyle(
                  //                                   color: secondaryColor,
                  //                                   fontSize: 15,
                  //                                   fontFamily: 'MonS',
                  //                                 ),
                  //                               ),
                  //                               //------------Main Rental Price-----------
                  //                               // SizedBox(height: 5),
                  //                               // Text(
                  //                               //   snapshot.data![index]['estimated_fare'] == null
                  //                               //       ? "0" + " ₹"
                  //                               //       : snapshot.data![index]['estimated_fare']
                  //                               //               .toString() +
                  //                               //           " ₹",
                  //                               //   style: TextStyle(
                  //                               //     color: kindaBlack.withOpacity(0.5),
                  //                               //     fontSize: 10,
                  //                               //     fontFamily: 'MonR',
                  //                               //     decoration:
                  //                               //         TextDecoration.lineThrough,
                  //                               //   ),
                  //                               // ),
                  //                             ],
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               );
                  //             }),
                  //           ),
                  //           SizedBox(
                  //             height: 20,
                  //           ),
                  //           Align(
                  //             alignment: Alignment.bottomCenter,
                  //             child: Container(
                  //               height: 120,
                  //               decoration: BoxDecoration(
                  //                 color: whiteColor,
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.grey.withOpacity(
                  //                         0.2), //color of shadow
                  //                     spreadRadius: 1, //spread radius
                  //                     blurRadius: 2, // blur radius
                  //                     offset: Offset(0,
                  //                         2), // changes position of shadow
                  //                     //first paramerter of offset is left-right
                  //                     //second parameter is top to down
                  //                   ),
                  //                   //you can set more BoxShadow() here
                  //                 ],
                  //               ),
                  //               child: Column(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.center,
                  //                 children: [
                  //                   Divider(),
                  //                   Row(
                  //                     children: [
                  //                       SizedBox(
                  //                         width: 5,
                  //                       ),
                  //                       Expanded(
                  //                         child: InkWell(
                  //                           onTap: () {
                  //                             showModalBottomSheet<void>(
                  //                               isScrollControlled: true,
                  //                               backgroundColor:
                  //                                   Colors.transparent,
                  //                               shape:
                  //                                   RoundedRectangleBorder(
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(
                  //                                         20),
                  //                               ),
                  //                               context: context,
                  //                               builder:
                  //                                   (BuildContext context) {
                  //                                 return Padding(
                  //                                   padding: MediaQuery.of(
                  //                                           context)
                  //                                       .viewInsets,
                  //                                   child:
                  //                                       PaymentSelection(),
                  //                                 );
                  //                               },
                  //                             );
                  //                           },
                  //                           child: Padding(
                  //                             padding:
                  //                                 const EdgeInsets.all(8.0),
                  //                             child: Container(
                  //                               child: Row(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment
                  //                                         .center,
                  //                                 children: [
                  //                                   paymentMode == "WALLET"
                  //                                       ? Icon(Icons.wallet,
                  //                                           color: Colors
                  //                                               .green
                  //                                               .shade700)
                  //                                       : Icon(
                  //                                           Icons
                  //                                               .money_outlined,
                  //                                           color: Colors
                  //                                               .green
                  //                                               .shade700),
                  //                                   SizedBox(
                  //                                     width: 5,
                  //                                   ),
                  //                                   Text(paymentMode,
                  //                                       style: TextStyle(
                  //                                         fontFamily:
                  //                                             'MonM',
                  //                                         fontSize: 15,
                  //                                         color:
                  //                                             Colors.black,
                  //                                       ),
                  //                                       overflow:
                  //                                           TextOverflow
                  //                                               .ellipsis,
                  //                                       textAlign: TextAlign
                  //                                           .center),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 7,
                  //                       ),
                  //                       Container(
                  //                         height: 15,
                  //                         width: 1,
                  //                         color:
                  //                             Colors.black.withOpacity(0.3),
                  //                       ),
                  //                       SizedBox(
                  //                         width: 7,
                  //                       ),
                  //                       Expanded(
                  //                         child: InkWell(
                  //                           onTap: () {
                  //                             // cuponCode
                  //                             showModalBottomSheet<void>(
                  //                               isScrollControlled: true,
                  //                               backgroundColor:
                  //                                   Colors.transparent,
                  //                               shape:
                  //                                   RoundedRectangleBorder(
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(
                  //                                         20),
                  //                               ),
                  //                               context: context,
                  //                               builder:
                  //                                   (BuildContext context) {
                  //                                 return Padding(
                  //                                   padding: MediaQuery.of(
                  //                                           context)
                  //                                       .viewInsets,
                  //                                   child: _enterCupons(),
                  //                                 );
                  //                               },
                  //                             );
                  //                           },
                  //                           child: Container(
                  //                             child: Row(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment
                  //                                       .center,
                  //                               children: [
                  //                                 Image.asset(
                  //                                     'assets/icons/tag.png',
                  //                                     height: 20,
                  //                                     width: 30,
                  //                                     color: Colors
                  //                                         .green.shade700),
                  //                                 SizedBox(
                  //                                   width: 5,
                  //                                 ),
                  //                                 Text(
                  //                                   "Coupon",
                  //                                   style: TextStyle(
                  //                                     fontFamily: 'MonM',
                  //                                     fontSize: 12,
                  //                                     color: Colors.black,
                  //                                   ),
                  //                                   overflow: TextOverflow
                  //                                       .ellipsis,
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Container(
                  //                         height: 15,
                  //                         width: 1,
                  //                         color:
                  //                             Colors.black.withOpacity(0.3),
                  //                       ),
                  //                       // SizedBox(
                  //                       //   width: 7,
                  //                       // ),
                  //                       // Expanded(
                  //                       //   child: Container(
                  //                       //     child: Row(
                  //                       //       mainAxisAlignment:
                  //                       //           MainAxisAlignment.center,
                  //                       //       children: [
                  //                       //         Icon(Icons.person),
                  //                       //         SizedBox(
                  //                       //           width: 5,
                  //                       //         ),
                  //                       //         Text(
                  //                       //           "My Self",
                  //                       //           style: TextStyle(
                  //                       //             fontFamily: 'MonM',
                  //                       //             fontSize: 12,
                  //                       //             color: Colors.black,
                  //                       //           ),
                  //                       //           overflow:
                  //                       //               TextOverflow.ellipsis,
                  //                       //         ),
                  //                       //       ],
                  //                       //     ),
                  //                       //   ),
                  //                       // ),
                  //                       // SizedBox(
                  //                       //   width: 7,
                  //                       // ),
                  //                     ],
                  //                   ),
                  //                   SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   //scheduleRide(context, date1, mainTime);
                  //                   selectedDate == ""
                  //                       ? Container(
                  //                           width: MediaQuery.of(context)
                  //                               .size
                  //                               .width,
                  //                           decoration: BoxDecoration(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(0),
                  //                             color: Colors.black,
                  //                           ),
                  //                           child: InkWell(
                  //                             onTap: () async {
                  //                               // var date = selectedDate.toString().split(" ");
                  //                               // var date1 = date[0].toString();
                  //                               // var date2 = date[1].toString().split(".");
                  //                               // var mainTime = date2[0].toString();
                  //                               // showFareDialog(context);
                  //                               // String rideID = snapshot.data![index]['id']
                  //                               // getRideFare(context, _id, _name);
                  //                               if (_selected == -1) {
                  //                                 Fluttertoast.showToast(
                  //                                     msg:
                  //                                         "Please Select a Package");
                  //                               } else if (_selectedPlan ==
                  //                                   -1) {
                  //                                 Fluttertoast.showToast(
                  //                                     msg:
                  //                                         "Please Select a Ride");
                  //                               } else {
                  //                                 Navigator.pushReplacement(
                  //                                   context,
                  //                                   MaterialPageRoute(
                  //                                     builder: (context) =>
                  //                                         BookRideSection(
                  //                                       serviceID: _id,
                  //                                       serviceName: _name,
                  //                                     ),
                  //                                   ),
                  //                                 );
                  //                               }
                  //                             },
                  //                             child: Center(
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets
                  //                                         .symmetric(
                  //                                     vertical: 12.0),
                  //                                 child: Text(
                  //                                   "Select Ride",
                  //                                   style: TextStyle(
                  //                                     fontFamily: 'MonS',
                  //                                     fontSize: 17,
                  //                                     color: whiteColor,
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         )
                  //                       : Container(
                  //                           width: MediaQuery.of(context)
                  //                               .size
                  //                               .width,
                  //                           decoration: BoxDecoration(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(0),
                  //                             color: Colors.black,
                  //                           ),
                  //                           child: InkWell(
                  //                             onTap: () async {
                  //                               var date = selectedDate
                  //                                   .toString()
                  //                                   .split(" ");
                  //                               var date1 =
                  //                                   date[0].toString();
                  //                               var date2 = date[1]
                  //                                   .toString()
                  //                                   .split(".");
                  //                               var mainTime =
                  //                                   date2[0].toString();

                  //                               if (_selected == -1) {
                  //                                 Fluttertoast.showToast(
                  //                                     msg:
                  //                                         "Please Select a Package");
                  //                               } else if (_selectedPlan ==
                  //                                   -1) {
                  //                                 Fluttertoast.showToast(
                  //                                     msg:
                  //                                         "Please Select a Ride");
                  //                               } else {
                  //                                 // Fluttertoast.showToast(
                  //                                 //     msg: date1
                  //                                 //             .toString() +
                  //                                 //         "   " +
                  //                                 //         mainTime
                  //                                 //             .toString());
                  //                                 showLoaderDialog(
                  //                                     context,
                  //                                     "Schedulling Ride...",
                  //                                     10);
                  //                                 await scheduleRide(
                  //                                     context,
                  //                                     date1,
                  //                                     mainTime);
                  //                                 // await scheduleRide(
                  //                                 //     context, date1, "");
                  //                               }
                  //                               // showFareDialog(context);
                  //                               // String rideID = snapshot.data![index]['id']
                  //                               // getRideFare(context, _id, _name);

                  //                               // Fluttertoast.showToast(
                  //                               //     msg: mainTime +
                  //                               //         "    " +
                  //                               //         date1);
                  //                             },
                  //                             child: Center(
                  //                               child: Padding(
                  //                                 padding: const EdgeInsets
                  //                                         .symmetric(
                  //                                     vertical: 12.0),
                  //                                 child: Text(
                  //                                   "Select Ride",
                  //                                   style: TextStyle(
                  //                                     fontFamily: 'MonS',
                  //                                     fontSize: 17,
                  //                                     color: whiteColor,
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //     }),
                ]),
              )
            ],
          ),
        ));
  }

  _enterCupons() {
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
                    controller: _couponData,
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
                      if (_couponData.text == "") {
                        Fluttertoast.showToast(
                            msg: "Please enter promocode before applying");
                      } else {
                        setState(() {
                          promoCode = _couponData.text;
                        });
                        if (promoCode != "") {
                          getRentalServices(context, promoCode);
                          Navigator.pop(context);
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

  Widget _timeSlots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), //color of shadow
              spreadRadius: 1, //spread radius
              blurRadius: 2, // blur radius
              offset: Offset(2, 0), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "selectpack".tr,
                style: TextStyle(
                  fontFamily: 'MonS',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 15),
              Container(
                child: FutureBuilder(
                    future: getRentalPacks(context, "17"),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (!snapshot.hasData) {
                        return Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor: primaryColor.withOpacity(0.3),
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 9,
                            mainAxisSpacing: 8,
                            childAspectRatio: 14 / 6),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              SharedPreferences _sharedPlan =
                                  await SharedPreferences.getInstance();
                              String planid =
                                  snapshot.data![index]['id'].toString();
                              // Fluttertoast.showToast(msg: planid.toString());
                              _sharedPlan.setString(
                                  'planID', planid.toString());
                              setState(() {
                                _selected = index;
                                rentalFarePlan =
                                    snapshot.data![index]['id'].toString();
                                showService = true;
                              });
                              // Fluttertoast.showToast(msg: rentalFarePlan);
                              await getRentalServices(context, promoCode);
                              // showModalBottomSheet(
                              //     isDismissible: false,
                              //     backgroundColor: Colors.transparent,
                              //     isScrollControlled: true,
                              //     context: context,
                              //     builder: (context) {
                              //       return Padding(
                              //         padding:
                              //             MediaQuery.of(context).viewInsets,
                              //         child: warningInfo(
                              //             snapshot.data![index]['name']),
                              //       );
                              //     });
                              // var dis =
                              //     snapshot.data![index]['name'].split(" ");
                              // double diss = double.parse(dis[2]);
                              // double totalDistance = 0;

                              // totalDistance += calculateDistance(
                              //     pickLat, pikLong, dropLat, dropLong);

                              // print("-------->" + diss.toString());

                              // setState(() {
                              //   distance = totalDistance;
                              // });

                              // if (totalDistance * 4 <= diss) {
                              // SharedPreferences _sharedPlan =
                              //     await SharedPreferences.getInstance();
                              // String planid =
                              //     snapshot.data![index]['id'].toString();
                              // // Fluttertoast.showToast(msg: planid.toString());
                              // _sharedPlan.setString(
                              //     'planID', planid.toString());
                              // setState(() {
                              //   _selected = index;
                              //   rentalFarePlan =
                              //       snapshot.data![index]['id'].toString();
                              //   showService = true;
                              // });
                              // Fluttertoast.showToast(msg: rentalFarePlan);
                              //   getRentalServices(context, promoCode);
                              // } else {
                              //   // Fluttertoast.showToast(
                              //   //     msg:
                              //   //         "${totalDistance + totalDistance} + ${diss}");
                              //   showModalBottomSheet(
                              //       isDismissible: false,
                              //       backgroundColor: Colors.transparent,
                              //       isScrollControlled: true,
                              //       context: context,
                              //       builder: (context) {
                              //         return Padding(
                              //           padding:
                              //               MediaQuery.of(context).viewInsets,
                              //           child: warningInfo(
                              //               snapshot.data![index]['name']),
                              //         );
                              //       });
                              // }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: index == _selected
                                          ? kindaBlack.withOpacity(0.3)
                                          : Colors.grey.shade300,
                                      width: 3),
                                  color: index == _selected
                                      ? secondaryColor
                                      : Colors.grey.shade400,
                                  boxShadow: [
                                    index == _selected
                                        ? BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.2), //color of shadow
                                            spreadRadius: 1.8, //spread radius
                                            blurRadius: 2, // blur radius
                                            offset: Offset(0,
                                                2), // changes position of shadow
                                            //first paramerter of offset is left-right
                                            //second parameter is top to down
                                          )
                                        : BoxShadow(),
                                    index == _selected
                                        ? BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.2), //color of shadow
                                            spreadRadius: 1, //spread radius
                                            blurRadius: 2, // blur radius
                                            offset: Offset(2,
                                                0), // changes position of shadow
                                            //first paramerter of offset is left-right
                                            //second parameter is top to down
                                          )
                                        : BoxShadow(),
                                    // borderRadius: BorderRadius.circular(50),
                                    // color: kindaBlack,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey
                                    //         .withOpacity(0.2), //color of shadow
                                    //     spreadRadius: 1, //spread radius
                                    //     blurRadius: 1, // blur radius
                                    //     offset: Offset(
                                    //         2, 2), // changes position of shadow
                                    //     //first paramerter of offset is left-right
                                    //     //second parameter is top to down
                                    //   ),
                                    //   BoxShadow(
                                    //     color: Colors.grey
                                    //         .withOpacity(0.2), //color of shadow
                                    //     spreadRadius: 1, //spread radius
                                    //     blurRadius: 1, // blur radius
                                    //     offset: Offset(
                                    //         -2, -2), // changes position of shadow
                                    //     //first paramerter of offset is left-right
                                    //     //second parameter is top to down
                                    //   ),
                                    //   //you can set more BoxShadow() here
                                    // ],]
                                  ]),
                              child: Center(
                                child: Text(
                                  snapshot.data![index]['name'],
                                  style: TextStyle(
                                      fontFamily:
                                          index == _selected ? 'MonS' : 'MonR',
                                      fontSize: index == _selected ? 11 : 10,
                                      color: index == _selected
                                          ? whiteColor
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      // return ListView.builder(
                      //   itemCount: snapshot.data!.length,
                      //   scrollDirection: Axis.horizontal,
                      //   itemBuilder: (context, index) {
                      //     return Align(
                      //       alignment: Alignment.center,
                      //       child: Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 3.0),
                      //         child: InkWell(
                      //           onTap: () async {
                      // SharedPreferences _sharedPlan =
                      //     await SharedPreferences.getInstance();
                      // String planid =
                      //     snapshot.data![index]['id'].toString();
                      // _sharedPlan.setString(
                      //     'planID', planid.toString());
                      // setState(() {
                      //   _selected = index;
                      //   rentalFarePlan =
                      //       snapshot.data![index]['id'].toString();
                      // });
                      //           },
                      //           child: Container(
                      //             height: 50,
                      //             width: 120,
                      //             decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      //     color: index == _selected
                      //         ? primaryColor.withOpacity(0.4)
                      //         : Colors.grey.shade500,
                      //     width: 3),
                      // color: index == _selected
                      //     ? whiteColor
                      //     : Colors.grey.shade500,
                      // boxShadow: [
                      //   index == _selected
                      //       ? BoxShadow(
                      //           color: Colors.grey.withOpacity(
                      //               0.2), //color of shadow
                      //           spreadRadius: 1.8, //spread radius
                      //           blurRadius: 2, // blur radius
                      //           offset: Offset(0,
                      //               2), // changes position of shadow
                      //           //first paramerter of offset is left-right
                      //           //second parameter is top to down
                      //         )
                      //       : BoxShadow(),
                      //   index == _selected
                      //       ? BoxShadow(
                      //           color: Colors.grey.withOpacity(
                      //               0.2), //color of shadow
                      //           spreadRadius: 1, //spread radius
                      //           blurRadius: 2, // blur radius
                      //           offset: Offset(2,
                      //               0), // changes position of shadow
                      //           //first paramerter of offset is left-right
                      //           //second parameter is top to down
                      //         )
                      //       : BoxShadow(),
                      //                 //you can set more BoxShadow() here
                      //               ],
                      //             ),
                      //             child: Center(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(8.0),
                      //                 child: Text(
                      //                   snapshot.data![index]['name'],
                      //                   style: TextStyle(
                      //                     fontFamily: 'MonS',
                      //                     fontSize: 12,
                      //                     color: index == _selected
                      //                         ? kindaBlack
                      //                         : whiteColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _innerOptions() {
    return fareTypeActive.any((element) => element["id"] == 17) &&
            !fareTypeActive.any((element) => element["id"] == 15) &&
            !fareTypeActive.any((element) => element["id"] == 16)
        ? SizedBox()
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              fareTypeActive.any((element) => element["id"] == 15)
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            fareType = "15";
                            rentalFarePlan = "";
                            dropadd = "";
                          });
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
                        },
                        child: Image.asset(
                          'assets/mainpics/citydisable.png',
                        ),
                      ),
                    )
                  : SizedBox(),
              fareTypeActive.any((element) => element["id"] == 17)
                  ? const SizedBox(
                      width: 10,
                    )
                  : SizedBox(),
              fareTypeActive.any((element) => element["id"] == 17)
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          dropadd = "";
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => RentalPage(),
                          //   ),
                          // );
                          // setState(() {
                          //   mainID = 1;
                          // });
                        },
                        child: Image.asset(
                          'assets/mainpics/rentalenable.png',
                        ),
                      ),
                    )
                  : SizedBox(),
              fareTypeActive.any((element) => element["id"] == 16)
                  ? const SizedBox(
                      width: 10,
                    )
                  : SizedBox(),
              fareTypeActive.any((element) => element["id"] == 16)
                  ? Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            fareType = "16";
                            rentalFarePlan = "";
                            dropadd = "";
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OutStationPage(
                                zoomDrawerController:
                                    widget.zoomDrawerController,
                              ),
                            ),
                          );
                          // Navigator.pushAndRemoveUntil(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => OutStationPage(),
                          //   ),
                          //   (route) => false,
                          // );
                          // setState(() {
                          //   mainID = 2;
                          // });
                        },
                        child: Image.asset(
                          'assets/mainpics/outstationdisable.png',
                        ),
                      ),
                    )
                  : SizedBox(),
              const SizedBox(
                width: 5,
              ),
              // Expanded(
              //   child: InkWell(
              //     onTap: () {
              //       // setState(() {
              //       //   mainID = 3;
              //       // });
              //     },
              //     child: Image.asset(
              //       'assets/mainpics/airportdisable.png',
              //     ),
              //   ),
              // ),
            ],
          );
  }

  // Widget _searchWidget() {
  //   return Container(
  //       height: 40,
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
  //       child: Row(
  //         children: [
  //           const Text("From"),
  //           TextFormField(),
  //           const Spacer(),
  //           const Icon(Icons.close)
  //         ],
  //       ));
  // }

  // Widget _searchRentalField() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
  //     child: Card(
  //       color: const Color(0xFFE8F1F5),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       elevation: 2,
  //       child: TextFormField(
  //         keyboardType: TextInputType.name,
  //         // controller: _filter,
  //         autocorrect: true,
  //         cursorColor: kindaBlack,
  //         decoration: const InputDecoration(
  //           hintText: 'Search..',
  //           labelStyle: TextStyle(color: kindaBlack),
  //           prefixIcon: Icon(
  //             Icons.search,
  //             color: primaryColor,
  //           ),
  //           suffixIcon: Icon(
  //             Icons.location_on,
  //             color: Color(0xFF348BF5),
  //           ),
  //           hintStyle: const TextStyle(color: kindaBlack),
  //           filled: true,
  //           fillColor: Color(0xFFE8F1F5),
  //           enabledBorder: const OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(12.0)),
  //             borderSide: BorderSide(color: Color(0xFFE8F1F5), width: 2),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  //             borderSide: BorderSide(color: Color(0xFFE8F1F5), width: 2),
  //           ),
  //         ),
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return 'Field should not be empty';
  //           }
  //           return null;
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _rentalPopularPrices() {
  //   return FutureBuilder(
  //       builder: (context, AsyncSnapshot<List> snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                     height: 100,
  //                     width: 100,
  //                     child: Lottie.asset('assets/animation/loading.json')),
  //                 Text(
  //                   "Loading...",
  //                   style: TextStyle(
  //                     fontFamily: 'MonS',
  //                     fontSize: 13,
  //                     color: kindaBlack,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //         return GridView.builder(
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             crossAxisSpacing: 3,
  //           ),
  //           itemCount: snapshot.data!.length,
  //           itemBuilder: (BuildContext ctx, index) {
  //             return Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Container(
  //                   color: kindaBlack.withOpacity(0.3),
  //                   height: 5,
  //                   width: 5,
  //                 ));
  //           },
  //         );
  //       },
  //       future: getRentalTimeData());
  // }

  Widget _dropWid(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6, bottom: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            dropadd = "";
            showService = false;
            _selected = -1;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchRentalDropLocation(),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
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
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), //color of shadow
                spreadRadius: 1, //spread radius
                blurRadius: 2, // blur radius
                offset: Offset(2, 0), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
              //you can set more BoxShadow() here
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
                child: Row(
                  children: [
                    Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 14.0, vertical: 4),
                        //   child: Container(
                        //     height: 10,
                        //     width: 10,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: primaryColor,
                        //     ),
                        //   ),
                        // ),
                        Icon(
                          Icons.pin_drop_outlined,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          dropadd == "" ? "searchdest".tr : dropadd,
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    // Icon(Icons.search, color: Colors.red)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _timeSlot() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           children: const [
  //             Icon(Icons.time_to_leave),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             Text(
  //               "Select A Pack",
  //               style: TextStyle(
  //                   fontFamily: 'MonS', fontSize: 15, color: kindaBlack),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 10,
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     _selected = 0;
  //                   });
  //                 },
  //                 child: Stack(
  //                   children: [
  //                     Material(
  //                       elevation: 4,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 103,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 0
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 0 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(right: 15.0),
  //                             child: Text(
  //                               "10 Km",
  //                               style: TextStyle(
  //                                 fontFamily: 'MonR',
  //                                 fontSize: 12,
  //                                 color:
  //                                     _selected == 0 ? kindaBlack : whiteColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Material(
  //                       elevation: 1,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 44,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 0
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 0 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "1 hr",
  //                             style: TextStyle(
  //                               fontFamily: 'MonR',
  //                               fontSize: 11,
  //                               color: _selected == 0 ? kindaBlack : whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 14),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     _selected = 1;
  //                   });
  //                 },
  //                 child: Stack(
  //                   children: [
  //                     Material(
  //                       elevation: 4,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 103,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 1
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 1 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(right: 15.0),
  //                             child: Text(
  //                               "20 Km",
  //                               style: TextStyle(
  //                                 fontFamily: 'MonS',
  //                                 fontSize: 12,
  //                                 color:
  //                                     _selected == 1 ? kindaBlack : whiteColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Material(
  //                       elevation: 1,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 44,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 1
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 1 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "2 hr",
  //                             style: TextStyle(
  //                               fontFamily: 'MonS',
  //                               fontSize: 11,
  //                               color: _selected == 1 ? kindaBlack : whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 14),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     _selected = 2;
  //                   });
  //                 },
  //                 child: Stack(
  //                   children: [
  //                     Material(
  //                       elevation: 4,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 103,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 2
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 2 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(right: 15.0),
  //                             child: Text(
  //                               "30 Km",
  //                               style: TextStyle(
  //                                 fontFamily: 'MonR',
  //                                 fontSize: 12,
  //                                 color:
  //                                     _selected == 2 ? kindaBlack : whiteColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Material(
  //                       elevation: 1,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 44,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 2
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 2 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "3 hr",
  //                             style: TextStyle(
  //                               fontFamily: 'MonR',
  //                               fontSize: 11,
  //                               color: _selected == 2 ? kindaBlack : whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     _selected = 3;
  //                   });
  //                 },
  //                 child: Stack(
  //                   children: [
  //                     Material(
  //                       elevation: 4,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 103,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 3
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 3 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(right: 15.0),
  //                             child: Text(
  //                               "40 Km",
  //                               style: TextStyle(
  //                                 fontFamily: 'MonR',
  //                                 fontSize: 12,
  //                                 color:
  //                                     _selected == 3 ? kindaBlack : whiteColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Material(
  //                       elevation: 1,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 44,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 3
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 3 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "4 hr",
  //                             style: TextStyle(
  //                               fontFamily: 'MonR',
  //                               fontSize: 11,
  //                               color: _selected == 3 ? kindaBlack : whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 14),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     _selected = 4;
  //                   });
  //                 },
  //                 child: Stack(
  //                   children: [
  //                     Material(
  //                       elevation: 4,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 103,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 4
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 4 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(right: 15.0),
  //                             child: Text(
  //                               "50 Km",
  //                               style: TextStyle(
  //                                 fontFamily: 'MonS',
  //                                 fontSize: 12,
  //                                 color:
  //                                     _selected == 4 ? kindaBlack : whiteColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Material(
  //                       elevation: 1,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 44,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 4
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 4 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "5 hr",
  //                             style: TextStyle(
  //                               fontFamily: 'MonS',
  //                               fontSize: 11,
  //                               color: _selected == 4 ? kindaBlack : whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 14),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     _selected = 5;
  //                   });
  //                 },
  //                 child: Stack(
  //                   children: [
  //                     Material(
  //                       elevation: 4,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 103,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 5
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 5 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Align(
  //                           alignment: Alignment.centerRight,
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(right: 15.0),
  //                             child: Text(
  //                               "60 Km",
  //                               style: TextStyle(
  //                                 fontFamily: 'MonR',
  //                                 fontSize: 12,
  //                                 color:
  //                                     _selected == 5 ? kindaBlack : whiteColor,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Material(
  //                       elevation: 1,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                       child: Container(
  //                         height: 44,
  //                         width: 44,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: _selected == 5
  //                                   ? primaryColor
  //                                   : Colors.transparent),
  //                           color: _selected == 5 ? whiteColor : kindaBlack,
  //                           borderRadius: BorderRadius.circular(40),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "6 hr",
  //                             style: TextStyle(
  //                               fontFamily: 'MonR',
  //                               fontSize: 11,
  //                               color: _selected == 5 ? kindaBlack : whiteColor,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _vehicleDetails() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           //background color of box
  //           BoxShadow(
  //             color: Colors.grey.shade400,
  //             blurRadius: 20.0, // soften the shadow
  //             spreadRadius: 2.0, //extend the shadow
  //             offset: const Offset(
  //               1.0, // Move to right 10  horizontally
  //               13.0, // Move to bottom 10 Vertically
  //             ),
  //           )
  //         ],
  //         color: whiteColor,
  //       ),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(18.0),
  //             child: Row(
  //               children: const [
  //                 Text(
  //                   "Select Ride...",
  //                   style: TextStyle(
  //                     fontFamily: 'MonS',
  //                     fontSize: 15,
  //                     color: kindaBlack,
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 Text(
  //                   "Telugu",
  //                   style: TextStyle(
  //                     fontFamily: 'MonS',
  //                     fontSize: 12,
  //                     color: primaryColor,
  //                   ),
  //                 ),
  //                 Icon(Icons.arrow_drop_down, color: primaryColor),
  //               ],
  //             ),
  //           ),
  //           _carDetails()
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _carDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _vehicleSelected = 1;
              });
            },
            onDoubleTap: () {
              setState(() {
                filterVal = 2;
                cab = 'Mini';
              });
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: _vehicleSelected == 1 ? 4 : 0,
              child: Container(
                height: 69,
                width: 349,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: _vehicleSelected == 1
                          ? primaryColor
                          : Colors.transparent),
                  color: whiteColor,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/vehicles/mini.png',
                      width: 80,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mini",
                          style: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 12,
                            color: kindaBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "4 seaters",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 10,
                            color: kindaBlack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFF2F6F9),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "₹ 185.00",
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 15,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "₹ 220.00",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 7,
                            color: kindaBlack,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    _vehicleSelected == 1
                        ? Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: primaryColor,
                              ),
                              height: 69,
                              width: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt_outlined,
                                      color: whiteColor),
                                  const Text(
                                    "Filter",
                                    style: TextStyle(
                                      fontFamily: 'MonR',
                                      fontSize: 10,
                                      color: whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _vehicleSelected = 2;
              });
            },
            onDoubleTap: () {
              setState(() {
                filterVal = 2;
                cab = 'SUV';
              });
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: _vehicleSelected == 2 ? 4 : 0,
              child: Container(
                height: 69,
                width: 349,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: _vehicleSelected == 2
                          ? primaryColor
                          : Colors.transparent),
                  color: whiteColor,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/vehicles/suv.png',
                      width: 80,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "SUV",
                          style: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 12,
                            color: kindaBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "8 seaters",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 10,
                            color: kindaBlack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFF2F6F9),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "₹ 385.00",
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 15,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "₹ 420.00",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 7,
                            color: kindaBlack,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    _vehicleSelected == 2
                        ? Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: primaryColor,
                              ),
                              height: 69,
                              width: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt_outlined,
                                      color: whiteColor),
                                  RippleAnimation(
                                    delay: Duration(milliseconds: 2000),
                                    repeat: true,
                                    color: kindaBlack.withOpacity(0.5),
                                    minRadius: 25,
                                    ripplesCount: 3,
                                    child: Text(
                                      "Filter",
                                      style: TextStyle(
                                        fontFamily: 'MonR',
                                        fontSize: 10,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _vehicleSelected = 3;
              });
            },
            onDoubleTap: () {
              setState(() {
                filterVal = 2;
                cab = 'Bike';
              });
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: _vehicleSelected == 3 ? 4 : 0,
              child: Container(
                height: 69,
                width: 349,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: _vehicleSelected == 3
                          ? primaryColor
                          : Colors.transparent),
                  color: whiteColor,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/vehicles/motorbike.png',
                      width: 80,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bike",
                          style: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 12,
                            color: kindaBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "1 seaters",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 10,
                            color: kindaBlack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFF2F6F9),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "₹ 85.00",
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 15,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "₹ 120.00",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 7,
                            color: kindaBlack,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    _vehicleSelected == 3
                        ? Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: primaryColor,
                              ),
                              height: 69,
                              width: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt_outlined,
                                      color: whiteColor),
                                  RippleAnimation(
                                    delay: Duration(milliseconds: 2000),
                                    repeat: true,
                                    color: kindaBlack.withOpacity(0.5),
                                    minRadius: 25,
                                    ripplesCount: 3,
                                    child: Text(
                                      "Filter",
                                      style: TextStyle(
                                        fontFamily: 'MonR',
                                        fontSize: 10,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _vehicleSelected = 4;
              });
            },
            onDoubleTap: () {
              setState(() {
                filterVal = 2;
                cab = 'Auto';
              });
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: _vehicleSelected == 4 ? 4 : 0,
              child: Container(
                height: 69,
                width: 349,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: _vehicleSelected == 4
                          ? primaryColor
                          : Colors.transparent),
                  color: whiteColor,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/vehicles/auto.png',
                      width: 80,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Auto",
                          style: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 12,
                            color: kindaBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "3 seaters",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 10,
                            color: kindaBlack.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color(0xFFF2F6F9),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                size: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "₹ 125.00",
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 15,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "₹ 185.00",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 7,
                            color: kindaBlack,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    _vehicleSelected == 4
                        ? Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                                color: primaryColor,
                              ),
                              height: 69,
                              width: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.filter_alt_outlined,
                                      color: whiteColor),
                                  RippleAnimation(
                                    delay: Duration(milliseconds: 2000),
                                    repeat: true,
                                    color: kindaBlack.withOpacity(0.5),
                                    minRadius: 25,
                                    ripplesCount: 3,
                                    child: Text(
                                      "Filter",
                                      style: TextStyle(
                                        fontFamily: 'MonR',
                                        fontSize: 10,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12.5,
          ),
          Material(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: primaryColor,
              ),
              child: Center(
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
          SizedBox(
            height: 12.5,
          ),
        ],
      ),
    );
  }

  Widget _filterSections(String _cabname) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            //background color of box
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 2.0, //extend the shadow
              offset: const Offset(
                1.0, // Move to right 10  horizontally
                13.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          color: whiteColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        filterVal = 1;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red.shade800,
                    ),
                  ),
                  Text(
                    _cabname + " Info.",
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 15,
                      color: kindaBlack,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Telugu",
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 12,
                      color: primaryColor,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: primaryColor),
                ],
              ),
            ),
            _checkLists()
          ],
        ),
      ),
    );
  }

  Widget _checkLists() {
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            "Smoking",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: kindaBlack,
            ),
          ),
          value: _smoke,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _smoke = value!;
            });
          },
          activeColor: primaryColor,
        ),
        CheckboxListTile(
          title: Text(
            "Carrying Pets",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: kindaBlack,
            ),
          ),
          value: _pets,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _pets = value!;
            });
          },
          activeColor: primaryColor,
        ),
        CheckboxListTile(
          title: Text(
            "Disabled",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: kindaBlack,
            ),
          ),
          value: _disabled,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _disabled = value!;
            });
          },
          activeColor: primaryColor,
        ),
        CheckboxListTile(
          title: Text(
            "Air Condition",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: kindaBlack,
            ),
          ),
          value: _airCondition,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _airCondition = value!;
            });
          },
          activeColor: primaryColor,
        ),
        CheckboxListTile(
          title: Text(
            "Extra Luggage Space",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: kindaBlack,
            ),
          ),
          value: _extraLuggage,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _extraLuggage = value!;
            });
          },
          activeColor: primaryColor,
        ),
        CheckboxListTile(
          title: Text(
            "Child Seat",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: kindaBlack,
            ),
          ),
          value: _child,
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) {
            setState(() {
              _child = value!;
            });
          },
          activeColor: primaryColor,
        ),
        SizedBox(
          height: 12.5,
        ),
        Material(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: primaryColor,
            ),
            child: Center(
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
        SizedBox(
          height: 12.5,
        ),
      ],
    );
  }
}



/*

Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: whiteColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(),
                  Row(
                    children: [
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
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
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/gpay.png',
                                  height: 20,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Google Pay",
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: cuponCode(
                                    context,
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                ],
              ),
            ),
          )

 */
