import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/screens/bookride/cancel_ride_opt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apiconstants.dart';
import '../../constants/color_contants.dart';
import '../../global/distance.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/google_key.dart';
import '../../global/map_styles.dart';
import '../../global/pickup_location.dart';
import '../../global/rental_fare_plan.dart';
import '../../global/ride/ride_details.dart';
import '../../widgets/loder_dialg.dart';
import '../../widgets/lott.dart';
import '../auth/loginscreen.dart';
import '../driver_details/driver_details.dart';
import '../home/home_screen.dart';
import 'no_one_accepted.dart';

class ReSearchRide extends StatefulWidget {
  String requestIDS;
  ReSearchRide({Key? key, required this.requestIDS}) : super(key: key);

  @override
  State<ReSearchRide> createState() => _ReSearchRideState();
}

class _ReSearchRideState extends State<ReSearchRide> {
  Future cancelRides(context, reason) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String apiUrl = cancelRide;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": requID.toString(), "cancel_reason": reason},
    );

    // print(userId);
    if (response.statusCode == 200) {
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
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 412) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
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
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  Future rideDetaisl(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String apiUrl = rideStreamData;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": requID.toString()},
    );

    // Fluttertoast.showToast(msg: response.statusCode.toString());

    // print(userId);
    if (response.statusCode == 200) {
      String bookingID = jsonDecode(response.body)["booking_id"].toString();
      String startAddress = jsonDecode(response.body)["s_address"].toString();
      String dropAddress = jsonDecode(response.body)["d_address"].toString();
      String startLat = jsonDecode(response.body)["s_latitude"].toString();
      String startLong = jsonDecode(response.body)["s_longitude"].toString();
      String dropLat = jsonDecode(response.body)["d_latitude"].toString();
      String dropLong = jsonDecode(response.body)["d_longitude"].toString();
      String estimatedFare = jsonDecode(response.body)["final_fare"].toString();
      String driverName =
          jsonDecode(response.body)["provider"]["first_name"].toString();
      String driverEmail =
          jsonDecode(response.body)["provider"]["email"].toString();
      String driverMobile =
          jsonDecode(response.body)["provider"]["mobile"].toString();
      String driverRating =
          jsonDecode(response.body)["provider"]["rating"].toString();
      String driverID = jsonDecode(response.body)["provider"]["id"].toString();
      String vehicleNumber = jsonDecode(response.body)["provider_service"]
              ["service_number"]
          .toString();
      String vehicleModel =
          jsonDecode(response.body)["service_type"].toString();

      String pay = jsonDecode(response.body)["payment_mode"].toString();

      String vehicleName =
          jsonDecode(response.body)["service_model"].toString();
      String driveimage =
          jsonDecode(response.body)["provider"]["avatar"].toString();

      // 'http://ondeindia.com/storage/app/public/' +/

      // print("<=======================Details" +
      //     bookingID +
      //     " " +
      //     startAddress +
      //     " " +
      //     dropAddress +
      //     " " +
      //     startLat +
      //     " " +
      //     startLong +
      //     " " +
      //     dropLat +
      //     " " +
      //     dropLong +
      //     " " +
      //     estimatedFare +
      //     " " +
      //     driverName +
      //     " " +
      //     driverEmail +
      //     " " +
      //     driverRating +
      //     " " +
      //     driverMobile +
      //     "<=======================Details");

      // Fluttertoast.showToast(
      //     msg: "<=======================Details" +
      //         bookingID +
      //         " " +
      //         startAddress +
      //         " " +
      //         dropAddress +
      //         " " +
      //         startLat +
      //         " " +
      //         startLong +
      //         " " +
      //         dropLat +
      //         " " +
      //         dropLong +
      //         " " +
      //         estimatedFare +
      //         " " +
      //         driverName +
      //         " " +
      //         driverEmail +
      //         " " +
      //         driverRating +
      //         " " +
      //         driverMobile +
      //         "<=======================Details");

      print(
          " >>>>>>>>>> Token Details <<<<<<<<<<  $userToken  >>>>>>>>>> Token Details <<<<<<<<<< ");
      // String driverImage =
      //     jsonDecode(response.body)["provider"]["avatar"].toString();

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => DriverDetails(
            bookID: bookingID,
            stAdd: startAddress,
            stLat: startLat,
            requeID: requID!,
            stLong: startLong,
            drAdd: dropAddress,
            drLat: dropLat,
            estFare: estimatedFare,
            drLong: dropLong,
            driName: driverName,
            driEmail: driverEmail,
            driMobile: driverMobile,
            driRate: driverRating,
            driImage: driveimage,
            vehiNum: vehicleNumber,
            vehName: vehicleName,
            vehMod: vehicleModel,
            paymode: pay,
            driID: driverID,
            requestIDS: widget.requestIDS,
          ),
        ),
      );

      // setState(() {
      //   driverLat = drivLat;
      //   driverLongi = drivLong;
      // });

      // _streamSubscription!.cancel();
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
      // Fluttertoast.showToast(msg: response.statusCode.toString());

      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoOneAccept(
              serviceID: serviceID,
              serviceName: serviceName,
              fT: fareType,
              fareP: rentalFarePlan,
            ),
          ));
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 401) {
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
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 412) {
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 401) {
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
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    }
    throw 'Exception';
  }

  //Google Maps Section

  GoogleMapController? mapController; //contrller for Google map
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

  StreamSubscription? _streamSubscription;

  bool _value = false;
  int val = -1;

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

    getDirections(); //fetch direction polylines from Google API

    timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
      rideDetaisl(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          //Map widget from google_maps_flutter package
          zoomGesturesEnabled: true, //enable Zoom in, out on map
          initialCameraPosition: CameraPosition(
            //innital position in map
            target: startLocation, //initial position
            zoom: 12.0, //initial zoom level
          ),
          markers: markers, //markers to show on map
          polylines: Set<Polyline>.of(polylines.values), //polylines
          mapType: MapType.normal, //map type
          onMapCreated: (controller) {
            //method called when map is created
            setState(() {
              mapController = controller;
              mapController!.setMapStyle(mapStyle);
            });
          },
        ),
        Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                  child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    child: Text(
                      "Distance: " + distance.toStringAsFixed(2) + " KM",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Material(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: 320,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Requesting Safe Ride...",
                      style: TextStyle(
                        fontFamily: 'MonS',
                        fontSize: 13,
                        color: kindaBlack,
                      ),
                    ),

                    lottieStru(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        height: 3,
                        child: LinearProgressIndicator(
                          color: secondaryColor,
                          backgroundColor: secondaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 18.0, vertical: 10),
                    //   child: Stack(
                    //     children: [
                    //       Container(
                    //         height: 15,
                    //         width: 370,
                    //         decoration: BoxDecoration(
                    //           color: Color(0xFFBEC2C3),
                    //           borderRadius: BorderRadius.circular(40),
                    //         ),
                    //       ),
                    //       Container(
                    //         height: 15,
                    //         width: 185,
                    //         decoration: BoxDecoration(
                    //           color: secondaryColor,
                    //           borderRadius: BorderRadius.circular(40),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(
                      height: 9,
                    ),
                    InkWell(
                      onTap: () async {
                        // showDialog<void>(
                        //   context: context,
                        //   barrierDismissible:
                        //       false, // user must tap button!
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       title: const Text(
                        //           'Are you Sure you want to cancel...'),
                        //       content: SingleChildScrollView(
                        //         child: ListBody(
                        //           children: [
                        //             Padding(
                        //               padding: EdgeInsets.all(10.0),
                        //               child: TextFormField(
                        //                 controller: _remarkController,
                        //                 minLines: 5,
                        //                 maxLines: 10,
                        //                 keyboardType:
                        //                     TextInputType.multiline,
                        //                 decoration: InputDecoration(
                        //                     hintText: 'Remarks...',
                        //                     hintStyle: TextStyle(
                        //                         color: Colors.grey),
                        //                     border: OutlineInputBorder(
                        //                       borderRadius:
                        //                           BorderRadius.all(
                        //                               Radius.circular(
                        //                                   10)),
                        //                     )),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       actions: <Widget>[
                        //         TextButton(
                        //           child: const Text('no'),
                        //           onPressed: () {
                        //             Navigator.of(context).pop();
                        //           },
                        //         ),
                        //         TextButton(
                        //           child: const Text('Yes, Cancel Ride'),
                        //           onPressed: () {
                        // String _reason =
                        //     _remarkController.text;

                        //           },
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // );
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: CancelRideOptions(
                                  reqID: widget.requestIDS,
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: secondaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              "Cancel Ride...😟",
                              style: TextStyle(
                                fontFamily: 'MonM',
                                fontSize: 15,
                                color: whiteColor,
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
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
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   CupertinoPageRoute(
                    //     builder: (context) => HomeScreen(),
                    //   ),
                    //   (route) => false,
                    // );
                  },
                  child: Material(
                    color: secondaryColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: secondaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
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
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SafeArea(
        //     child: InkWell(
        //       onTap: () {
        //         Navigator.pop(context);
        //       },
        //       child: Material(
        //         color: secondaryColor,
        //         elevation: 4,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(13),
        //         ),
        //         child: Container(
        //           height: 38,
        //           width: 38,
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(50),
        //             color: secondaryColor,
        //           ),
        //           child: const Center(
        //             child: Icon(
        //               Icons.arrow_back,
        //               color: whiteColor,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // )
        // Requesting Ride…Hang Tight  😀
      ],
    ));
  }

  Widget _bottomCancelReason() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.28,
      decoration: const BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
          ),
          color: whiteColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 13,
            ),
            const Text(
              "Are you sure? You want to cancel the ride request...",
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "MonS",
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Expected shorter wait time"),
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
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Driver denied duty on phone call"),
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
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Driver not wearing mask"),
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
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Driver looked unwell"),
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
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Car not sanitized/ UnHygenic"),
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
            const SizedBox(height: 10),
            ListTile(
              title: const Text("My reason is not listed."),
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
    );
  }
}
