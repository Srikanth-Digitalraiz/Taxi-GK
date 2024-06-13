import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:location/location.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/global/driverloaction.dart';
import 'package:ondeindia/global/fare_type.dart';
import 'package:ondeindia/global/google_key.dart';
import 'package:ondeindia/global/map_styles.dart';
import 'package:ondeindia/global/rental_fare_plan.dart';
import 'package:ondeindia/global/wallet.dart';
import 'package:ondeindia/screens/bookride/cancel_ride_opt.dart';
import 'package:ondeindia/screens/bookride/no_one_accepted.dart';
import 'package:ondeindia/screens/driver_details/driver_details.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/widgets/lott.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../constants/apiconstants.dart';
import '../../global/distance.dart';
import '../../global/dropdetails.dart';
import '../../global/out/out_pack.dart';
import '../../global/pickup_location.dart';
import '../../global/promocode.dart';
import '../../widgets/loder_dialg.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';
import '../home/widget/tryagain.dart';
import 'no_drivers_found.dart';

class BookRideSection extends StatefulWidget {
  final String serviceID, serviceName;
  BookRideSection(
      {Key? key, required this.serviceID, required this.serviceName})
      : super(key: key);

  @override
  State<BookRideSection> createState() => _BookRideSectionState();
}

class _BookRideSectionState extends State<BookRideSection> {
  final TextEditingController _remarkController = TextEditingController();
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  bool dialogApp = false;

  bool buttonEnablem = false;

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
  BitmapDescriptor? startpinLocationIcon;
  BitmapDescriptor? droppinLocationIcon;
  bool _value = false;
  int val = -1;
  Timer? timer;

  @override
  void initState() {
    // setCustomePickMarker();
    _eta();
    Fluttertoast.showToast(msg: rentalFarePlan.toString());

    Timer(const Duration(seconds: 2), () {
      if (rentalFarePlan == "") {
        EasyLoading.showToast("Can not request ride. Please try again");
        setState(() {
          fareType = "15";
          rentalFarePlan = "";
          dropadd = "";
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } else {
        // EasyLoading.showToast(mainReturnDate);
        bookRide(context, widget.serviceID, widget.serviceName);
      }
    });
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
    // setCustomMapStartPin();
    // setCustomMapEndPin();
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

  void setCustomMapStartPin() async {
    startpinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: const Size(1, 1)),
        'assets/images/startpoint.png');
  }

  void setCustomMapEndPin() async {
    droppinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: const Size(1, 1)),
        'assets/images/droppoint.png');
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

  String requestID = "";

  Future bookRide(context, serviceID, name) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    var date1 = mainReturnDate.split(' ');
    DateTime date = DateTime.now();
    String date2 = DateFormat('yy-MM-dd').format(date);
    double mainDistance = mainReturnDate == "" ? distance : distance + distance;
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
        "distance": mainDistance.toStringAsFixed(4),
        "use_wallet": "1",
        'payment_mode': paymentMode,
        "s_address": pickAdd.toString(),
        "d_address": dropadd.toString(),
        "fare_plan_name": rentalFarePlan.toString(),
        "fare_type": fareType.toString(),
        "fare_setting": fare_setting_plan.toString(),
        "eta": eta.toString(),
        "current_date": date2,
        'return_date': date1[0].toString(),
        'admin_id': adminId,
        "promo_code": promoCode,
        'fareplan': selectedOutName
        // "fareplan": fareType == "16"
        //     ? mainReturnDate == ""
        //         ? "One Way"55
        //         : "Round Trip"
        //     : ""
      },
    );

    // Fluttertoast.showToast(
    //     msg: date1[0].toString() + "   " + response.statusCode.toString());

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

    print(
        "---------------------------------------------> Streamed HIT <---------------------------------------------   " +
            pickLat.toStringAsFixed(4) +
            " " +
            pikLong.toStringAsFixed(4) +
            " " +
            dropLat.toStringAsFixed(4) +
            " " +
            dropLong.toStringAsFixed(4) +
            " " +
            serviceID.toString() +
            " " +
            distance.toStringAsFixed(4) +
            " " +
            "1" +
            " " +
            paymentMode +
            " " +
            pickAdd.toString() +
            " " +
            dropadd.toString() +
            " " +
            rentalFarePlan.toString() +
            " " +
            fareType.toString() +
            " " +
            fare_setting_plan.toString() +
            " " +
            eta.toString() +
            " " +
            adminId +
            " " +
            date2.toString() +
            " " +
            " " +
            date1[0].toString() +
            " " +
            selectedOutName);

    // print("---------------------------------------------> Streamed HIT <---------------------------------------------   " +
    //     response.statusCode.toString() +
    //     "   " +
    //     distance.toString() +
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
    //     dropadd.toString() +
    //     "   " +
    //     rentalFarePlan.toString() +
    //     "    " +
    //     fareType +
    //     "   " +
    //     fare_setting_plan +
    //     "    " +
    //     serviceID +
    //     "    " +
    //     eta +
    //     "---------------------------------------------> Streamed HIT <---------------------------------------------   ");

    // print("---------------------------------------------> Status Code HIT <---------------------------------------------" +
    //     response.statusCode.toString() +
    //     "         " +
    //     response.body.toString() +
    //     "---------------------------------------------> Status Code HIT <---------------------------------------------");

    // print(
    //     "---------------------------------------------> Streamed HIT <---------------------------------------------");

    // Fluttertoast.showToast(
    //     msg: "---------------------------------------------> Status Code HIT <---------------------------------------------" +
    //         response.body.toString() +
    //         "---------------------------------------------> Status Code HIT <---------------------------------------------");

    // // print(userId);
    // Fluttertoast.showToast(msg: "--------> RENTAL ID  " + rentalFarePlan);
    print("Booking Area Status Code" +
        response.body.toString() +
        " " +
        response.statusCode.toString());
    if (response.statusCode == 200) {
      String _requestID = jsonDecode(response.body)["request_id"].toString();

      // Fluttertoast.showToast(
      //     msg: "-------------->>>-------->>>========>>>" + _requestID);

      _token.setString("reqID", _requestID);
      String? tt = _token.getString('reqID');

      // Fluttertoast.showToast(msg: "Cancwl ID:----> $tt");

      setState(() {
        requestID = _requestID;
        buttonEnablem = true;
        // rentalFarePlan = '';
      });
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
      // Fluttertoast.showToast(msg: "--------> REQ ID  " + _requestID);
      // Fluttertoast.showToast(msg: "--------> RENTAL ID  " + rentalFarePlan);

      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 412) {
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      // Fluttertoast.showToast(msg: "Here");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 415) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NoDrivers(fT: fareType),
          ));
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      print("Booking Area" + response.body.toString());
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  // Future cancelRides(context, reason) async {
  //   SharedPreferences _token = await SharedPreferences.getInstance();
  //   String? userToken = _token.getString('maintoken');
  //   String? requID = _token.getString("reqID");
  //   String apiUrl = cancelRide;
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {"Authorization": "Bearer " + userToken.toString()},
  //     body: {"request_id": requestID, "cancel_reason": reason},
  //   );

  //   // print(userId);
  //   if (response.statusCode == 200) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const HomeScreen(),
  //         ));
  //     // Navigator.pushAndRemoveUntil(
  //     //   context,
  //     //   CupertinoPageRoute(
  //     //     builder: (context) => const HomeScreen(),
  //     //   ),
  //     //   (route) => false,
  //     // );
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(
  //     //     content: Material(
  //     //       elevation: 3,
  //     //       shape:
  //     //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     //       child: Container(
  //     //         height: 60,
  //     //         decoration: BoxDecoration(
  //     //             color: secondaryColor, borderRadius: BorderRadius.circular(10)),
  //     //         child: Center(child: Text(jsonDecode(response.body))),
  //     //       ),
  //     //     ),
  //     //     behavior: SnackBarBehavior.floating,
  //     //     backgroundColor: Colors.transparent,
  //     //     elevation: 0,
  //     //   ),
  //     // );
  //     // Fluttertoast.showToast(msg: response.body.toString());

  //     return jsonDecode(response.body);
  //   } else if (response.statusCode == 400) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 401) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const NewAuthSelection(),
  //         ));
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 412) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 500) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 401) {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const NewAuthSelection(),
  //         ));
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 403) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   }
  //   throw 'Exception';
  // }

  Future rideDetaisl(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String apiUrl = rideStreamData;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"request_id": requestID},
    );

    // Fluttertoast.showToast(
    //     msg: "Main Request ID----------------------> " +
    //         requestID +
    //         " <----------------------Main Request ID");

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
      String vehicleNumber = jsonDecode(response.body)["provider_service"]
              ["service_number"]
          .toString();
      String vehicleModel =
          jsonDecode(response.body)["service_type"].toString();
      String driverID = jsonDecode(response.body)["provider"]["id"].toString();

      String vehicleName =
          jsonDecode(response.body)["service_model"].toString();
      String payMode = jsonDecode(response.body)["payment_mode"].toString();
      String driveimage =
          jsonDecode(response.body)["provider"]["avatar"].toString();

      //'http://ondeindia.com/storage/app/public/' +

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
            bookID: bookingID.toString(),
            stAdd: startAddress.toString(),
            stLat: startLat.toString(),
            requeID: requestID.toString(),
            stLong: startLong.toString(),
            drAdd: dropAddress.toString(),
            drLat: dropLat.toString(),
            estFare: estimatedFare.toString(),
            drLong: dropLong.toString(),
            driName: driverName.toString(),
            driEmail: driverEmail.toString(),
            driMobile: driverMobile.toString(),
            driRate: driverRating.toString(),
            driImage: driveimage.toString(),
            vehiNum: vehicleNumber.toString(),
            vehName: vehicleName.toString(),
            vehMod: vehicleModel.toString(),
            paymode: payMode.toString(),
            driID: driverID,
            requestIDS: requestID,
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
      // setState(() {
      //   dialogApp = true;
      // });

      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => NoOneAccept(
              serviceID: widget.serviceID,
              serviceName: widget.serviceName,
              fareP: rentalFarePlan.toString(),
              fT: fareType.toString(),
            ),
          ),
          (route) => false);

      // Navigator.pushReplacement(
      //   context,
      //   CupertinoPageRoute(
      //     builder: (context) => NoOneAccept(
      // serviceID: widget.serviceID,
      // serviceName: widget.serviceName,
      // fareP: rentalFarePlan.toString(),
      // fT: fareType.toString(),
      //       // fareSe: fare_setting_plan.toString(),
      //     ),
      //   ),
      // );
      // Fluttertoast.showToast(msg: rentalFarePlan.toString());
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NoOneAccept(
      //         serviceID: widget.serviceID,
      //         serviceName: widget.serviceName,
      //       ),
      //     ));
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
      //       child: tryAgain(
      //         context,
      //         widget.serviceID,
      //         widget.serviceName,
      //       ),
      //     );
      //   },
      // );
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 412) {
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.statusCode.toString());
    }
    throw 'Exception';
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Timer(
  //     Duration(seconds: 20),
  //     () => Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => DriverDetails(),
  //       ),
  //     ),
  //   );
  // }

  // LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  // late GoogleMapController _controller;
  // Location _location = Location();

  // void _onMapCreated(GoogleMapController _cntlr) {
  //   _controller = _cntlr;
  //   _location.onLocationChanged.listen((l) {
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 16.9),
  //     );
  //   });
  // }

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
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
                      style: const TextStyle(
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
                    buttonEnablem != true
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              String _reason = _remarkController.text;
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
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: CancelRideOptions(
                                        reqID: requestID,
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 50,
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

  // Widget _bottomCancelReason() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 1.18,
  //     decoration: const BoxDecoration(
  //         borderRadius: BorderRadius.vertical(
  //           top: const Radius.circular(10),
  //         ),
  //         color: whiteColor),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  // const SizedBox(
  //   height: 13,
  // ),
  // const Text(
  //   "Are you sure? You want to cancel the ride request...",
  //   style: const TextStyle(
  //     color: Colors.black,
  //     fontFamily: "MonS",
  //     fontSize: 14,
  //     fontWeight: FontWeight.w400,
  //   ),
  // ),
  // const SizedBox(height: 10),
  //           ListTile(
  //             title: const Text("Expected shorter wait time"),
  //             leading: Radio(
  //               value: 1,
  //               groupValue: val,
  //               onChanged: (int? value) {
  //                 setState(() {
  //                   val = value!
  //                 });
  //               },
  //               activeColor: Colors.green,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           ListTile(
  //             title: const Text("Driver denied duty on phone call"),
  //             leading: Radio(
  //               value: 2,
  //               groupValue: val,
  //               onChanged: (int? value) {
  //                 setState(() {
  //                   val = value!;
  //                 });
  //               },
  //               activeColor: Colors.green,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           ListTile(
  //             title: const Text("Driver not wearing mask"),
  //             leading: Radio(
  //               value: 3,
  //               groupValue: val,
  //               onChanged: (int? value) {
  //                 setState(() {
  //                   val = value!;
  //                 });
  //               },
  //               activeColor: Colors.green,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           ListTile(
  //             title: const Text("Driver looked unwell"),
  //             leading: Radio(
  //               value: 4,
  //               groupValue: val,
  //               onChanged: (int? value) {
  //                 setState(() {
  //                   val = value!;
  //                 });
  //               },
  //               activeColor: Colors.green,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           ListTile(
  //             title: const Text("Car not sanitized/ UnHygenic"),
  //             leading: Radio(
  //               value: 5,
  //               groupValue: val,
  //               onChanged: (int? value) {
  //                 setState(() {
  //                   val = value!;
  //                 });
  //               },
  //               activeColor: Colors.green,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           ListTile(
  //             title: const Text("My reason is not listed."),
  //             leading: Radio(
  //               value: 6,
  //               groupValue: val,
  //               onChanged: (int? value) {
  // setState(() {
  //   val = value!;
  // });
  //               },
  //               activeColor: Colors.green,
  //             ),
  //           ),
  //           Container(
  //             margin: const EdgeInsets.symmetric(vertical: 10),
  //             child: Align(
  //               alignment: Alignment.bottomCenter,
  //               child: ElevatedButton(
  //                 style: ButtonStyle(
  //                   backgroundColor: MaterialStateProperty.all(Colors.black),
  //                 ),
  //                 onPressed: () async {
  //                   String reason = val == 1
  //                       ? "Expected shorter wait time"
  //                       : val == 2
  //                           ? "Driver denied duty on phone call"
  //                           : val == 3
  //                               ? "Driver not wearing mask"
  //                               : val == 4
  //                                   ? "Driver looked unwell"
  //                                   : val == 5
  //                                       ? "Car not sanitized/ UnHygenic"
  //                                       : "My reason is not listed.";
  //                   if (val == -1) {
  //                     Fluttertoast.showToast(
  //                         msg: "Please select your reason for cancellation...");
  //                   } else {
  //                     showLoaderDialog(context, "Cancelling your Request", 15);
  //                     await cancelRides(context, reason);
  //                   }
  //                 },
  //                 child: SizedBox(
  //                   height: 50,
  //                   width: MediaQuery.of(context).size.width / 1.4,
  //                   child: const Center(
  //                     child: Text(
  //                       "Cancel Ride",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 15,
  //                         fontFamily: 'MonS',
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
