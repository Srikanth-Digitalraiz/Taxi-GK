import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/current_location.dart';
import 'package:ondeindia/global/out_station_fare_plan.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/auth/new_auth/new_auth_selected.dart';
import 'package:ondeindia/screens/home/Outstation%20Flow/outstation_drop.dart';
import 'package:ondeindia/screens/home/Outstation%20Flow/outstation_ride_confirm.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/confirmride.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
// import 'package:ondeindia/screens/home/outstations/outstation_ride.dart';
// import 'package:ondeindia/screens/home/outstations/outstation_ride_confirm.dart';
import 'package:ondeindia/screens/home/Rental%20Flow/rental.dart';
import 'package:ondeindia/screens/home/widget/enter_cupon.dart';
import 'package:ondeindia/screens/home/widget/payment_selection.dart';
import 'package:ondeindia/screens/home/widget/ride_confirm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../../constants/apiconstants.dart';
import '../../../global/distance.dart';
import '../../../global/dropdetails.dart';
import '../../../global/fare_type.dart';
import '../../../global/map_styles.dart';
import '../../../global/out/out.dart';
import '../../../global/outStatus.dart';
import '../../../global/pickup_location.dart';
import '../../../global/rental_fare_plan.dart';
import '../../auth/loginscreen.dart';
import '../../auth/new_auth/login_new.dart';
import '../../bookride/bookride.dart';
import '../widget/pickup_widget.dart';
import '../widget/searchdroplocation.dart';

class OutStationPage extends StatefulWidget {
  final zoomDrawerController;
  OutStationPage({Key? key, required this.zoomDrawerController})
      : super(key: key);

  @override
  State<OutStationPage> createState() => _OutStationPageState();
}

class _OutStationPageState extends State<OutStationPage> {
  String googleApikey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(currentLat, currentLong);
  String location = "Location Name:";

  //Recenter Button

  void setInitialLocation() async {
    CameraPosition cPosition = CameraPosition(
      zoom: 17,
      target: LatLng(currentLat, currentLong),
    );
    mapController!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  int _selectedPlan = -1;

  final zoomDrawerController = ZoomDrawerController();

  Future<List> getRentalServices(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? planID = _token.getString('planID');
    String apiUrl = estimatedFare;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "s_latitude": pickLat.toString(),
        "s_longitude": pikLong.toString(),
        "d_latitude": dropLat.toString(),
        "d_longitude": dropLong.toString(),
        "distance": distance.toStringAsFixed(4),
        "fare_plan": rentalFarePlan.toString(),
        "fare_type": "16",
      },
    );
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: response.body.toString());

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

  String selectedDate = "";
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
        "s_latitude": pickLat.toStringAsFixed(4),
        "s_longitude": pikLong.toStringAsFixed(4),
        "d_latitude": "",
        "d_longitude": "",
        "service_type": _id.toString(),
        "distance": "",
        "use_wallet": "1",
        'payment_mode': "CASH",
        "s_address": pickAdd.toString(),
        "d_address": "",
        "schedule_date": schDate,
        "schedule_time": schTime,
        "fare_plan_name": rentalFarePlan.toString(),
        "fare_type": fareType.toString(),
        "fare_setting": fare_setting_plan.toString()
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

  //Internet Connection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: fareTypeActive.any((element) => element["id"] == 16) &&
              !fareTypeActive.any((element) => element["id"] == 15) &&
              !fareTypeActive.any((element) => element["id"] == 17)
          ? null
          : AppBar(
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
              backgroundColor: whiteColor,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Text(
                "outstation".tr,
                style: TextStyle(
                  fontFamily: 'MonS',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              titleSpacing: 0,
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  GoogleMap(
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
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
                  SafeArea(
                    child: Align(
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
                  SafeArea(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      fareTypeActive.any((element) => element["id"] == 16) &&
                              !fareTypeActive
                                  .any((element) => element["id"] == 15) &&
                              !fareTypeActive
                                  .any((element) => element["id"] == 17)
                          ? Align(
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
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(Icons.menu),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                      Expanded(child: PickUp()),
                    ],
                  )),
                ],
              ),
              // child: GoogleMap(
              //   initialCameraPosition:
              //       CameraPosition(target: _initialcameraposition, zoom: 14),
              //   mapType: MapType.normal,
              //   zoomControlsEnabled: true,
              //   // onMapCreated: _onMapCreated,
              //   scrollGesturesEnabled: true,
              //   zoomGesturesEnabled: true,
              //   myLocationEnabled: true,
              //   // ignore: prefer_collection_literals
              //   gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              //     // ignore: unnecessary_new
              //     new Factory<OneSequenceGestureRecognizer>(
              //       () => EagerGestureRecognizer(),
              //     ),
              //   ].toSet(),
              // ),
            ),
            SizedBox(
              height: 15,
            ),
            _innerOptions(),
            SizedBox(
              height: 10,
            ),
            _searchField(),
            // SizedBox(
            //   height: 20,
            // ),
            // _timeSlots(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Popular Destinations",
                style: TextStyle(
                  fontFamily: 'MonS',
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            _popularDestinations()
          ],
        ),
      ),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     const Padding(
      //       padding: EdgeInsets.only(left: 8.0),
      //       child: Text(
      //         "Vehicle Group",
      //         style: TextStyle(
      //           fontFamily: 'MonS',
      //           fontSize: 15,
      //           color: kindaBlack,
      //         ),
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     _innerOptions(),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     Divider(
      //       color: kindaBlack,
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     _searchField(),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     Expanded(child: _popularDestinations())
      //   ],
      // ),
    );
  }

  Widget _innerOptions() {
    return fareTypeActive.any((element) => element["id"] == 16) &&
            !fareTypeActive.any((element) => element["id"] == 15) &&
            !fareTypeActive.any((element) => element["id"] == 17)
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
                              builder: (context) => const HomeScreen(),
                            ),
                          );
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
                          setState(() {
                            fareType = "17";
                            rentalFarePlan = "";
                            dropadd = "";
                          });

                          fareTypeActive
                                      .any((element) => element["id"] == 17) &&
                                  fareTypeActive
                                      .any((element) => element["id"] != 15)
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                )
                              : Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RentalPage(
                                      zoomDrawerController:
                                          zoomDrawerController,
                                    ),
                                  ),
                                );
                          // setState(() {
                          //   mainID = 1;
                          // });
                        },
                        child: Image.asset(
                          'assets/mainpics/rentaldisable.png',
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
                          dropadd = "";
                          // setState(() {
                          //   mainID = 2;
                          // });
                        },
                        child: Image.asset(
                          'assets/mainpics/outstationenable.png',
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

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            fareType = "16";
            dropadd = "";
            outstatus = true;
            out = true;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchOutStationDrop(),
              ));
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFF395B64),
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
                          Icons.search,
                          color: whiteColor,
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
                            fontFamily: 'MonS',
                            fontSize: 15,
                            color: Colors.white,
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

  Widget _popularDestinations() {
    return FutureBuilder(
      future: getPopularDestinations(context),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    'assets/animation/loading.json',
                  ),
                ),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 13,
                    color: kindaBlack,
                  ),
                ),
              ],
            ),
          );
        }
        return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext ctx, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    double lat = snapshot.data![index]['latitude'];
                    // double.parse(snapshot.data![index]['latitude']);
                    double long = snapshot.data![index]['lagitude'];
                    String address = snapshot.data![index]['name'].toString();
                    // double.parse(snapshot.data![index]['lagitude']);
                    setState(() {
                      dropadd = address;
                      dropLat = lat;
                      dropLong = long;
                      fareType = "16";
                      outstatus = true;
                      out = true;
                      // pickLat = predictions[index].
                    });
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => RideConfirm(
                                  dropLocation: dropadd,
                                )));
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: ((context) => OutStationRideConfirm()),
                    //   ),
                    // );
                  },
                  child: Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 400,
                          width: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            image: DecorationImage(
                              image: NetworkImage(
                                bannerURL +
                                    snapshot.data![index]['picture'].toString(),
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            color: whiteColor.withOpacity(0.6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  snapshot.data![index]['name'].toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
