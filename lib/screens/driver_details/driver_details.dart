import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/driverdistance.dart';
import 'package:ondeindia/global/driverloaction.dart';
import 'package:ondeindia/screens/auth/loginscreen.dart';
import 'package:ondeindia/screens/bookride/cancel_ride_opt.dart';
import 'package:ondeindia/screens/bookride/research_ride.dart';
import 'package:ondeindia/screens/driver_details/ridecompleted.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/apiconstants.dart';
import '../../global/admin_id.dart';
import '../../global/drive_streamed.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/google_key.dart';
import '../../global/map_styles.dart';
import '../../global/pickup_location.dart';
import '../../global/rental_fare_plan.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';
import '../bookride/ride_complete.dart';
import '../chat/driverchat.dart';

class DriverDetails extends StatefulWidget {
  final String bookID,
      stAdd,
      requeID,
      stLat,
      stLong,
      drAdd,
      drLat,
      drLong,
      driName,
      driEmail,
      driMobile,
      driRate,
      estFare,
      vehiNum,
      vehName,
      vehMod,
      paymode,
      driImage,
      driID,
      requestIDS;
  DriverDetails(
      {Key? key,
      required this.bookID,
      required this.stAdd,
      required this.stLat,
      required this.requeID,
      required this.stLong,
      required this.drAdd,
      required this.drLat,
      required this.drLong,
      required this.driName,
      required this.driEmail,
      required this.driMobile,
      required this.driRate,
      required this.estFare,
      required this.vehiNum,
      required this.vehMod,
      required this.vehName,
      required this.paymode,
      required this.driImage,
      required this.driID,
      required this.requestIDS})
      : super(key: key);

  @override
  State<DriverDetails> createState() => _DriverDetailsState();
}

enum PayMentOptions { Cash, GooglePay }

class _DriverDetailsState extends State<DriverDetails> {
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  bool _value = false;
  int val = -1;

  // BitmapDescriptor? pickup = BitmapDescriptor;

  // BitmapDescriptor? drop;

  // void setCustomePickMarker() async {
  //   pickup = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/images/pickupmarker.png');
  // }

  String googleAPiKey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";

  Set<Marker> markers = Set<Marker>(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  // LatLng startLocation = LatLng(23.6683619, 83.3101895);

  LatLng startLocation = LatLng(pickLat, pikLong);
  LatLng endLocation = LatLng(driverLatitude, driverLongitude);

  // Set<Marker> mapmarkers() {
  //   setState(() {
  //     markers.add(Marker(
  //       //add distination location marker
  //       markerId: MarkerId(startLocation.toString()),
  //       position: startLocation, //position of marker
  //       infoWindow: InfoWindow(
  //         //popup info
  //         title: 'Your PickUp Location ',
  //         snippet: pickAdd + "  ",
  //       ),
  //     ));

  //     markers.add(Marker(
  //       //add distination location marker
  //       markerId: MarkerId(endLocation.toString()),
  //       position: endLocation, //position of marker
  //       infoWindow: InfoWindow(
  //           //popup info

  //           ),
  //     ));
  //   });

  //   return markers;
  // }

  // Set<Marker> getMarkers() {
  //   setState(() {
  //     // setCustomePickMarker();
  //     markers.add(Marker(
  //       //add start location marker
  //       markerId: MarkerId(startLocation.toString()),
  //       position: startLocation, //position of marker
  //       infoWindow: InfoWindow(
  //         //popup info
  //         title: 'Driver Location ',
  //         snippet: "  ",
  //       ),
  //       icon: BitmapDescriptor.fromBytes(
  //         custMar2!,
  //       ),
  //       // icon: pickup
  //     ));

  // markers.add(Marker(
  //   //add distination location marker
  //   markerId: MarkerId(endLocation.toString()),
  //   position: endLocation, //position of marker
  //   infoWindow: InfoWindow(
  //     //popup info
  //     title: 'Your PickUp Location ',
  //     snippet: pickAdd + "  ",
  //   ),
  //   icon: BitmapDescriptor.fromBytes(
  //     custMar!,
  //   ),
  // ));
  //   });
  //   return markers;
  // }

  // Uint8List? custMar;

  // void customMarker() async {
  //   Uint8List bytes = (await NetworkAssetBundle(
  //               Uri.parse('https://i.postimg.cc/zfjMX1Hd/unnamed-1.png'))
  //           .load("https://i.postimg.cc/zfjMX1Hd/unnamed-1.png"))
  //       .buffer
  //       .asUint8List();

  //   setState(() {
  //     custMar = bytes;
  //   });
  // }

  // Uint8List? custMar2;

  // void customMarker2() async {
  //   final ByteData bytes = await rootBundle.load('assets/images/current.png');
  //   final Uint8List list = bytes.buffer.asUint8List();

  //   setState(() {
  //     custMar2 = list;
  //   });
  // }

  Timer? timer;
  Timer? timer2;

  @override
  void initState() {
    getVerificationCode(context);
    timer = Timer.periodic(Duration(seconds: 35), (Timer t) {
      //Driver Location Update//
      getDriverLocation(context);
      _eta();
      getDirections();
    });
    timer2 = Timer.periodic(Duration(seconds: 25), (Timer t) {
      getRideStatus(context);
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  Future cancelRides(context, reason) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String reID = widget.requeID;
    String apiUrl = cancelRide;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": reID, "cancel_reason": reason},
    );
    if (response.statusCode == 200 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Material(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  "Ride Cancelled Successfully...",
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      // );
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
      // Navigator.pop(context);
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
    }
    throw 'Exception';
  }

  Future<List> driverChattingSection(context, comment) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String reID = widget.requeID;
    String apiUrl = driverChatAPI;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        'admin_id': adminId,
        "request_id": reID,
        "provider_id": widget.driID,
        'message': comment ?? ""
      },
    );
    if (response.statusCode == 200) {
      _messageController.clear();

      return jsonDecode(response.body)['data'];
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
    }
    throw 'Exception';
  }

  String eta = "";

  _eta() async {
    Dio dio = Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$pickLat,$pikLong&destinations=$driverLatitude,$driverLongitude&key=$gooAPIKey");
    // print("ETA------------------__>" + response.data.toString());
    // Fluttertoast.showToast(
    //     msg: response.data['rows'][0]['elements'][0]['duration']['text']
    //         .toString());
    setState(() {
      eta = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    });
  }

  Future getDriverLocation(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String reID = widget.requeID;
    String apiUrl = driverLoc;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"id": reID},
    );

    if (response.statusCode == 200) {
      double? lat = jsonDecode(response.body)['Location'][0]['latitude'];
      double? lon = jsonDecode(response.body)['Location'][0]['longitude'];
      setState(() {
        driverLatitude = lat!;
        driverLongitude = lon!;
      });

      //User PickUp Location

      markers.add(Marker(
        markerId: MarkerId(startLocation.toString()),
        position: startLocation,
        infoWindow: InfoWindow(
          title: 'Your PickUp Location ',
          snippet: pickAdd + "  ",
        ),
      ));

      //Driver Location

      markers.add(Marker(
        markerId: MarkerId(endLocation.toString()),
        position: endLocation,
        infoWindow: InfoWindow(
          title: 'Driver Location ',
        ),

        // icon: BitmapDescriptor.fromBytes(
        //   custMar!,
        // ),
      ));

      return jsonDecode(response.body)['Location'];
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
    }
    throw 'Exception';
  }

  String verfiCode = "";

  Future getVerificationCode(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String reID = widget.requeID;
    String apiUrl = dynamicOTP;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": reID, "admin_id": adminId},
    );

    // Fluttertoast.showToast(msg: response.body.toString());

    if (response.statusCode == 200) {
      String? verCode = jsonDecode(response.body)[0]['verification_code'];
      // double? lon = jsonDecode(response.body)['Location'][0]['longitude'];
      setState(() {
        verfiCode = verCode.toString();
      });

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
    }
    throw 'Exception';
  }

  String tim = "";

  String sta = "";

  Future getRideStatus(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String reID = widget.requeID;
    String apiUrl = rideSta;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"id": reID},
    );

    print("===============llłllllllllllllllllll-----------> $reID");
    if (response.statusCode == 200) {
      String rideStatus =
          jsonDecode(response.body)['Status'][0]['status'].toString();

      setState(() {
        sta = rideStatus;
      });

      if (sta == "COMPLETED") {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => RideCompletedMock(serviceID: reID),
          ),
          (route) => false,
        );
      } else if (sta == "CANCELLED") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Material(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Ride has been cancelled",
                    style: TextStyle(color: whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else if (sta == "PROCESSING") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Material(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Ride has been cancelled by driver...Searching for New Driver.",
                        style: TextStyle(
                          color: whiteColor,
                        ),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => ReSearchRide(requestIDS: widget.requestIDS),
          ),
          (route) => false,
        );
      }

      return jsonDecode(response.body);
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

  _chargingAmount() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.2,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        color: whiteColor,
      ),
    );
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      gooAPIKey,
      // PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(startLocation.latitude, startLocation.longitude),
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
      driverDistance = totalDistance;
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

  void launchDialer({
    @required int? phone,
  }) async {
    if (await canLaunch("tel: $phone")) {
      await launch("tel: $phone");
    } else {
      throw 'Could not launch url';
    }
  }

  PayMentOptions? _character = PayMentOptions.Cash;
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  Location _location = Location();

  bool _priceDex = false;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 16.9),
      );
    });
  }

//   Stream<int> generateNumbers = (() async* {
//   await Future<void>.delayed(Duration(seconds: 2));

//   // for (int i = 1; i <= 10; i++) {
//   //   await Future<void>.delayed(Duration(seconds: 1));
//   //   yield i;
//   // }
// })();

  willpo() {
    return Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }

  _launchWhatsapp() async {
    var whatsapp = "+91${widget.driMobile}";
    var whatsappAndroid = Uri.parse(
        "whatsapp://send?phone=$whatsapp&text=Hello,Can i know How much time will it take to reach to my location...Im short on time please hurry.");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return willpo();
      },
      child: Scaffold(
          // body: StreamBuilder(
          //   stream: Stream.periodic(
          //     const Duration(seconds: 50),
          //   ),
          //   builder: (context, snap) {
          //     return
          //   },
          // ),
          body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: startLocation,
              zoom: 14.0,
            ),
            markers: markers,
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
                mapController!.setMapStyle(mapStyle);
              });
            },
          ),

          Visibility(
            visible: _priceDex == true ? true : false,
            child: InkWell(
              onTap: () {
                setState(() {
                  _priceDex = !_priceDex;
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: kindaBlack.withOpacity(0.6),
              ),
            ),
          ),

          //mainDriver Detail
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Visibility(
                            visible: _priceDex == true ? true : false,
                            child: _closeButton()),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              _rideOTP(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // InkWell(
                                    //   onTap: () {
                                    //     Navigator.pushReplacement(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => HomeScreen(),
                                    //       ),
                                    //     );
                                    //   },
                                    //   child: Container(
                                    //     height: 30,
                                    //     width: 120,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius:
                                    //           BorderRadius.circular(10),
                                    //       color:
                                    //           secondaryColor.withOpacity(0.3),
                                    //     ),
                                    //     child: Center(
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: [
                                    //           SizedBox(width: 3),
                                    //           Icon(Icons.add,
                                    //               size: 18, color: kindaBlack),
                                    //           SizedBox(width: 3),
                                    //           Text(
                                    //             "Add Alt. Number",
                                    //             style: TextStyle(
                                    //               fontFamily: 'MonS',
                                    //               fontSize: 10,
                                    //               color: kindaBlack,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: 5),
                                    sta == "ARRIVED" || sta == "PICKEDUP"
                                        ? SizedBox()
                                        : Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: secondaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "On The Way:  $eta",
                                                style: TextStyle(
                                                  fontFamily: 'MonS',
                                                  fontSize: 10,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // setState(() {
                      //   _priceDex = !_priceDex;
                      // });
                    },
                    child: Material(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 182,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    image: DecorationImage(
                                        image: widget.driImage == ''
                                            ? NetworkImage(
                                                'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                                              )
                                            : NetworkImage(
                                                bannerURL + widget.driImage),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.driName,
                                        style: TextStyle(
                                          fontFamily: 'MonS',
                                          fontSize: 13,
                                          color: kindaBlack,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        widget.vehMod,
                                        style: TextStyle(
                                          fontFamily: 'MonR',
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_half_outlined,
                                            color: secondaryColor,
                                            size: 12,
                                          ),
                                          Text(
                                            widget.driRate,
                                            style: TextStyle(
                                              fontFamily: 'MonS',
                                              fontSize: 13,
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.vehName == null
                                          ? ""
                                          : widget.vehName,
                                      style: TextStyle(
                                        fontFamily: 'MonS',
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    //vehName
                                    Text(
                                      widget.vehiNum == null
                                          ? ""
                                          : widget.vehiNum,
                                      style: TextStyle(
                                        fontFamily: 'MonS',
                                        fontSize: 12,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Material(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        int ph = int.parse(
                                            widget.driMobile.toString());
                                        launchDialer(phone: ph);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: whiteColor,
                                        ),
                                        child: Row(
                                          children: const [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.call,
                                              color: secondaryColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Call",
                                                style: TextStyle(
                                                  fontFamily: 'MonS',
                                                  fontSize: 10,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // InkWell(
                                  //   onTap: () async {
                                  //     Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) => DriverChat(
                                  //                 driverName: widget.driName,
                                  //                 rieID: widget.requeID,
                                  //                 phone: widget.driMobile,
                                  //                 driID: widget.driID)));
                                  //     // _launchWhatsapp();
                                  //   },
                                  //   child: Material(
                                  //     elevation: 2,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(40),
                                  //     ),
                                  //     child: Container(
                                  //       height: 40,
                                  //       width: 80,
                                  //       decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(40),
                                  //         color: whiteColor,
                                  //       ),
                                  //       child: Row(
                                  //         children: const [
                                  //           SizedBox(
                                  //             width: 10,
                                  //           ),
                                  //           Icon(
                                  //             Icons.sms_outlined,
                                  //             color: secondaryColor,
                                  //           ),
                                  //           SizedBox(
                                  //             width: 10,
                                  //           ),
                                  //           Expanded(
                                  //             child: Text(
                                  //               "Chat",
                                  //               style: TextStyle(
                                  //                 fontFamily: 'MonS',
                                  //                 fontSize: 10,
                                  //                 color: secondaryColor,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _priceDex = !_priceDex;
                                        });
                                      },
                                      child: Material(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: secondaryColor,
                                          ),
                                          child: Row(
                                            children: const [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.info_outline_rounded,
                                                color: whiteColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Ride Detais",
                                                  style: TextStyle(
                                                    fontFamily: 'MonS',
                                                    fontSize: 10,
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: _priceDex == true ? true : false,
                    child: _pricingDetails())
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              builder: (context) => HomeScreen(),
                            ),
                          );
                          // Navigator.pushReplacement(
                          //   context,
                          //   CupertinoPageRoute(
                          //       builder: (context) => HomeScreen());
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: whiteColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                widget.stAdd,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 13,
                                  color: kindaBlack,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.east_outlined,
                            color: secondaryColor,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                widget.drAdd,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 13,
                                  color: kindaBlack,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  driverChat(driverName) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: secondaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                margin: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteColor,
                ),
                child: Text(
                  "Now Chatting with: " + driverName,
                  style: TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 10,
                    color: secondaryColor,
                  ),
                )),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: whiteColor,
              ),
              child: FutureBuilder(
                  future: driverChattingSection(context, ""),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return snapshot.data![index]['message'] == ""
                            ? SizedBox(
                                height: 0,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      snapshot.data![index]['type'] == "up"
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    snapshot.data![index]['type'] == "pu"
                                        ? SizedBox(
                                            width: 6,
                                          )
                                        : Container(),
                                    snapshot.data![index]['type'] == "pu"
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: snapshot.data![index]
                                                            ['type'] ==
                                                        "pu"
                                                    ? Colors.amber
                                                    : secondaryColor),
                                            child: Icon(Icons.person,
                                                size: 12, color: whiteColor),
                                          )
                                        : Container(),
                                    snapshot.data![index]['type'] == "pu"
                                        ? SizedBox(
                                            width: 6,
                                          )
                                        : Container(),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      decoration: BoxDecoration(
                                        borderRadius: snapshot.data![index]
                                                    ['type'] ==
                                                "up"
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(30))
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30)),
                                        color: snapshot.data![index]['type'] ==
                                                "pu"
                                            ? Colors.amber.withOpacity(0.3)
                                            : secondaryColor.withOpacity(0.3),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 14.0),
                                          child: Flexible(
                                            child: Text(
                                                snapshot.data![index]
                                                    ['message'],
                                                maxLines: 10,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.visible),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    snapshot.data![index]['type'] == "up"
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: secondaryColor),
                                            child: Icon(Icons.person,
                                                size: 12, color: whiteColor),
                                          )
                                        : Container(),
                                  ],
                                ),
                              );
                      },
                    );
                  }),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //color of shadow
                  spreadRadius: 1, //spread radius
                  blurRadius: 1, // blur radius
                  offset: Offset(2, 2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //color of shadow
                  spreadRadius: 1, //spread radius
                  blurRadius: 1, // blur radius
                  offset: Offset(-2, -2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
                //you can set more BoxShadow() here
              ],
              color: whiteColor,
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    int ph = int.parse(widget.driMobile.toString());
                    launchDialer(phone: ph);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(2, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(-2, -2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Icon(
                      Icons.call,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Message..."),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    String _message = _messageController.text;
                    if (_message == "" || _message == null) {
                      Fluttertoast.showToast(
                          msg: "Plesase write a message to send...");
                    } else {
                      showLoaderDialog(context, "Sending...", 20);
                      await driverChattingSection(context, _message);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(2, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(-2, -2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Icon(
                      Icons.send,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _pricingDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Ride Details",
                style: TextStyle(
                  fontFamily: 'MonS',
                  fontSize: 16,
                  color: kindaBlack,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Amount to be paid",
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 12,
                      color: kindaBlack,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "₹ " + "${widget.estFare}" + ".00",
                    style: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 21,
                      color: secondaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Payment By: ",
                        style: TextStyle(
                          fontFamily: 'MonM',
                          fontSize: 14,
                          color: kindaBlack,
                        ),
                      ),
                      Text(
                        widget.paymode,
                        style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 18,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // RadioListTile<PayMentOptions>(
                //   activeColor: secondaryColor,
                //   title: const Text(
                //     'Cash',
                //     style: TextStyle(
                //       fontFamily: 'MonR',
                //       fontSize: 12,
                //       color: kindaBlack,
                //     ),
                //   ),
                //   value: PayMentOptions.Cash,
                //   groupValue: _character,
                //   onChanged: (PayMentOptions? value) {
                //     setState(() {
                //       _character = value;
                //     });
                //   },
                // ),
                // RadioListTile<PayMentOptions>(
                //   activeColor: secondaryColor,
                //   title: const Text(
                //     'Google Pay',
                //     style: TextStyle(
                //       fontFamily: 'MonR',
                //       fontSize: 12,
                //       fontWeight: FontWeight.w500,
                //       color: kindaBlack,
                //     ),
                //   ),
                //   value: PayMentOptions.GooglePay,
                //   groupValue: _character,
                //   onChanged: (PayMentOptions? value) {
                //     setState(() {
                //       _character = value;
                //     });
                //   },
                // ),
              ],
            ),
            Center(child: _cancleRide()),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget _closeButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _priceDex = !_priceDex;
        });
      },
      child: RippleAnimation(
        color: whiteColor,
        repeat: true,
        minRadius: 25,
        ripplesCount: 3,
        child: Image.asset(
          'assets/shapes/map_shape_close.png',
          height: 40,
          width: 40,
        ),
      ),
    );
  }

  Widget _rideOTP() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 5,
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => DriverDetails(
                            bookID: widget.bookID,
                            stAdd: widget.stAdd,
                            requeID: widget.requeID,
                            stLat: widget.stLat,
                            stLong: widget.stLong,
                            drAdd: widget.drAdd,
                            drLat: widget.drLat,
                            drLong: widget.drLong,
                            driName: widget.driName,
                            driEmail: widget.driEmail,
                            driMobile: widget.driMobile,
                            driRate: widget.driRate,
                            estFare: widget.estFare,
                            vehiNum: widget.vehiNum,
                            vehName: widget.vehName,
                            vehMod: widget.vehMod,
                            paymode: widget.paymode,
                            driImage: widget.driImage,
                            driID: widget.driID,
                            requestIDS: widget.requestIDS))));
              },
              child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: whiteColor,
                  ),
                  child: Icon(Icons.gps_fixed_outlined, size: 20)),
            ),
          ),
          SizedBox(height: 5),
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: whiteColor),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "OTP: ",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: kindaBlack,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      verfiCode,
                      style: TextStyle(
                          fontFamily: 'MonB',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: kindaBlack,
                          letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancleRide() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: TextButton(
        onPressed: () {
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
        child: Center(
          child: Text(
            "Cancle Ride",
            style: TextStyle(
              fontFamily: 'MonS',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
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
