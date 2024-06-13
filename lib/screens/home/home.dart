import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show NetworkAssetBundle, rootBundle;
import 'package:ondeindia/constants/apiconstants.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/global/couponcode.dart';
import 'package:ondeindia/global/current_location.dart';
import 'package:ondeindia/global/out/out_pack.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/global/promocode.dart';
import 'package:ondeindia/global/schedule_acc.dart';
import 'package:ondeindia/global/service_scr.dart';
import 'package:ondeindia/main.dart';
import 'package:ondeindia/screens/auth/loginscreen.dart';
import 'package:ondeindia/screens/home/widget/drop_widget.dart';
import 'package:ondeindia/screens/home/widget/no_partners_poly.dart';

import 'package:ondeindia/screens/home/widget/pickup_widget.dart';
import 'package:ondeindia/screens/home/widget/search_pickup/searchpickup.dart';

import 'package:ondeindia/screens/home/Outstation%20Flow/outstation_main.dart';
import 'package:ondeindia/screens/home/Rental%20Flow/rental.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../global/data/user_data.dart';

import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';

import '../../global/map_styles.dart';
import '../../global/out/out.dart';
import '../../global/outStatus.dart';
import '../../global/rental_fare_plan.dart';
import '../../global/ride/ride_details.dart';
import '../../global/wallet.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';

class Home extends StatefulWidget {
  final zoomDrawerController;

  Home(this.zoomDrawerController);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int mainID = 0;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();

  late BitmapDescriptor pinLocationIcon;

  Timer? timer5;
  Timer? timer6;
  Timer? timer7;

  @override
  void initState() {
    super.initState();

    // permission();

    setState(() {
      coupon = "";
      serviceID = "";
      serviceTime = "";
      serviceName = "";
      rentalFarePlan = '';
      fareType = '15';
      out = false;
      selectedOutPlan = 0;
      selectedOutName = 'One Way';
      mainReturnDate = "";
      promoCode = "";
    });

    getBanners();
    checkConnection();
    getRentalPacks(context);
    rootBundle.loadString('assets/animation/map_style_3.txt').then((string) {
      mapStyle = string;
    });

    setCustomMapPin();
    // customMarker();
    getWalletBalance(context);

    // timer6 = Timer.periodic(const Duration(seconds: 40), (Timer t) {
    //   setInitialLocation();
    // });
    userUpdateLocation(
        currentLat.toString(), currentLong.toString(), fcmTokenAuth, context);

    timer5 = Timer.periodic(const Duration(seconds: 20), (Timer t) {
      getListOfVeh();
    });
    timer7 = Timer.periodic(Duration(seconds: 10), (timer) {
      userUpdateLocation(
          currentLat.toString(), currentLong.toString(), fcmTokenAuth, context);
    });
    // EasyLoading.showToast(userEmail);
  }

  @override
  void dispose() {
    timer7?.cancel();
    timer6?.cancel();
    timer5?.cancel();
    super.dispose();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/cabs/mini.png');
  }

  Future<List> getRentalPacks(context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userID = _sharedData.getString('personid');
    String? userToken = _sharedData.getString('maintoken');
    String apiUrl = packs;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"id": "15"},
    );
    // print(userId);
    if (response.statusCode == 200) {
      setState(() {
        rentalFarePlan =
            jsonDecode(response.body)['FarePlan'][0]['id'].toString();
      });

      // Fluttertoast.showToast(msg: rentalFarePlan);

      return jsonDecode(response.body)['FarePlan'];
    } else if (response.statusCode == 400) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
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
          ));
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  final zoomDrawerControllersss = ZoomDrawerController();

  //Get Use Wallet Balance
  Future getWalletBalance(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? userID = _token.getString('personid');
    String apiUrl = walletBalance;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
    );
    print(
        "----------------Wallet Balance Data--------   ${response.body}    ----------------Wallet Balance Data--------");
    if (response.statusCode == 200) {
      int _balance = jsonDecode(response.body)['WalletBalance'];
      setState(() {
        walletBalanceAmount =
            jsonDecode(response.body)['WalletBalance'] == null ? 0 : _balance;
      });
      // Fluttertoast.showToast(msg: _balance.toString());
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

  List _loadedPhotos = [];

  Future<List> getBanners() async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    // SharedPreferences _token = await SharedPreferences.getInstance();
    // String? userToken = _token.getString('maintoken');
    String apiUrl = homeBanner;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
    );
    // print(userId);
    if (response.statusCode == 200) {
      print(
          "----kk-kk-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k-k");
      final data = json.decode(response.body)['AdvertisingBanners'];
      setState(() {
        _loadedPhotos = data;
      });
      print("Sending Request0))))))))))))----" +
          _loadedPhotos.toString() +
          "<<<<<<<<<<<<<<<<<<-");
      // return jsonDecode(response.body)['AdvertisingBanners'];
    } else if (response.statusCode == 400) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 404) {
      EasyLoading.showToast("Session Expired");
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

  String googleApikey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(currentLat, currentLong);
  String location = "Location Name:";

  void setInitialLocation() async {
    CameraPosition cPosition = CameraPosition(
      zoom: 15,
      target: LatLng(currentLat, currentLong),
    );

    mapController!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    userUpdateLocation(
        currentLat.toString(), currentLong.toString(), fcmTokenAuth, context);
  }

  bool connectionState = true;

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connectionState = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connectionState = false;
      });
      AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.SCALE,
        title: 'No Internet Access',
        desc: 'Please Connect your device with Internet',
        btnCancelOnPress: () {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: ((context) => Home(widget.zoomDrawerController)),
              ));
        },
        btnOkOnPress: () {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: ((context) => Home(widget.zoomDrawerController)),
              ));
        },
      ).show();
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
              child: const Center(child: const Text("No Internet Available")),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  Timer? timer;

  List<Map<String, double>> _vehicleCoordinates = [];

  Future<List<Map<String, double>>> getListOfVeh() async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String apiUrl = sourroundingVeh;

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer $userToken"},
    );

    // EasyLoading.showToast(response.statusCode.toString());

    if (response.statusCode == 200) {
      print('---vesssssss------->');
      List<dynamic> vehicles = jsonDecode(response.body)['Vehicles'];
      List<Map<String, double>> vehicleCoordinates = [];

      for (var vehicle in vehicles) {
        var provider = vehicle['provider'];
        double latitude = provider != null && provider['latitude'] != null
            ? provider['latitude'].toDouble()
            : 0.0;
        double longitude = provider != null && provider['longitude'] != null
            ? provider['longitude'].toDouble()
            : 0.0;

        vehicleCoordinates.add({
          'latitude': latitude,
          'longitude': longitude,
        });
      }

      log('---vesssssss-------> $vehicleCoordinates');

      setState(() {
        _vehicleCoordinates = vehicleCoordinates;
      });

      return vehicleCoordinates;
    } else {
      // Handle different status codes appropriately
      switch (response.statusCode) {
        case 400:
          // Fluttertoast.showToast(msg: response.body.toString());
          break;
        case 401:
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NewAuthSelection(),
            ),
          );
          break;
        case 412:
        case 500:
        case 403:
          // Fluttertoast.showToast(msg: response.body.toString());
          break;
        default:
          throw 'Exception';
      }
    }

    return [];
  }

//coordinatesss data APIII
  // Future<List> getListOfVeh() async {
  //   SharedPreferences _token = await SharedPreferences.getInstance();
  //   String? userToken = _token.getString('maintoken');
  //   // SharedPreferences _token = await SharedPreferences.getInstance();
  //   // String? userToken = _token.getString('maintoken');
  //   String apiUrl = sourroundingVeh;
  //   final response = await http.get(
  //     Uri.parse(apiUrl),
  //     headers: {"Authorization": "Bearer " + userToken.toString()},
  //   );
  //   // print(userId);
  //   if (response.statusCode == 200) {
  //     //Vehicle Data
  //     double vehOneLat =
  //         jsonDecode(response.body)['Vehicles'][0]['provider']['latitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][0]['provider']
  //                 ['latitude'];
  //     double vehOneLong =
  //         jsonDecode(response.body)['Vehicles'][0]['provider']['longitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][0]['provider']
  //                 ['longitude'];
  //     double vehTwoLat =
  //         jsonDecode(response.body)['Vehicles'][1]['provider']['latitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][1]['provider']
  //                 ['latitude'];
  //     double vehTwoLong =
  //         jsonDecode(response.body)['Vehicles'][1]['provider']['longitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][1]['provider']
  //                 ['longitude'];
  //     double vehThreeLat =
  //         jsonDecode(response.body)['Vehicles'][2]['provider']['latitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][2]['provider']
  //                 ['latitude'];
  //     double vehThreeLong =
  //         jsonDecode(response.body)['Vehicles'][2]['provider']['longitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][2]['provider']
  //                 ['longitude'];
  //     double vehFourLat =
  //         jsonDecode(response.body)['Vehicles'][3]['provider']['latitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][3]['provider']
  //                 ['latitude'];
  //     double vehFourLong =
  //         jsonDecode(response.body)['Vehicles'][3]['provider']['longitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][3]['provider']
  //                 ['longitude'];
  //     double vehFiveLat =
  //         jsonDecode(response.body)['Vehicles'][4]['provider']['latitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][4]['provider']
  //                 ['latitude'];
  //     double vehFiveLong =
  //         jsonDecode(response.body)['Vehicles'][4]['provider']['longitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][4]['provider']
  //                 ['longitude'];
  //     double vehSixLat =
  //         jsonDecode(response.body)['Vehicles'][5]['provider']['latitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][5]['provider']
  //                 ['latitude'];
  //     double vehSixLong =
  //         jsonDecode(response.body)['Vehicles'][5]['provider']['longitude'] == 0
  //             ? 0.0
  //             : jsonDecode(response.body)['Vehicles'][5]['provider']
  //                 ['longitude'];

  //     setState(() {
  //       veh1Lat = vehOneLat;
  //       veh1Long = vehOneLong;

  //       veh2Lat = vehTwoLat;
  //       veh2Long = vehTwoLong;

  //       veh3Lat = vehThreeLat;
  //       veh3Long = vehThreeLong;

  //       veh4Lat = vehFourLat;
  //       veh4Long = vehFourLong;

  //       veh5Lat = vehFiveLat;
  //       veh5Long = vehFiveLong;

  //       veh6Lat = vehSixLat;
  //       veh6Long = vehSixLong;

  //     });

  //     // return jsonDecode(response.body)['AdvertisingBanners'];
  //   } else if (response.statusCode == 400) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 401) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => NewAuthSelection(),
  //       ),
  //     );
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 412) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 500) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 401) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => NewAuthSelection(),
  //       ),
  //     );
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   } else if (response.statusCode == 403) {
  //     // Fluttertoast.showToast(msg: response.body.toString());
  //   }
  //   throw 'Exception';
  // }

  // final Set<Marker> markers = Set(); //markers for google map
  // static LatLng showLocation = LatLng(currentLat, currentLong);

  // String etaMark = "";

  // _eta(lat1, lat2) async {
  //   Dio dio = Dio();
  //   Response response = await dio.get(
  //       "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$currentLat,$currentLong&destinations=$lat1,$lat2&key=$gooAPIKey");
  //   print("ETA------------------__>" + response.data.toString());
  //   setState(() {
  //     etaMark = response.data['rows'][0]['elements'][0]['duration']['text']
  //         .toString();
  //   });
  // }

  //Coordinatessssss

  // Set<Marker> getmarkers() {
  //   //markers to place on map
  //   setState(() {
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID1"),
  //       position: LatLng(veh1Lat, veh1Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));

  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID2"),
  //       position: LatLng(veh2Lat, veh2Long), //position of marker
  //       // icon: BitmapDescriptor.defaultMarker, //Icon for Marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID3"),
  //       position: LatLng(veh3Lat, veh3Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID4"),
  //       position: LatLng(veh4Lat, veh4Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID5"),
  //       position: LatLng(veh5Lat, veh5Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID5"),
  //       position: LatLng(veh6Lat, veh6Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID6"),
  //       position: LatLng(veh6Lat, veh6Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID7"),
  //       position: LatLng(veh7Lat, veh7Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID8"),
  //       position: LatLng(veh8Lat, veh8Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID9"),
  //       position: LatLng(veh9Lat, veh9Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
  //     markers.add(Marker(
  //       //add first marker
  //       markerId: const MarkerId("ID10"),
  //       position: LatLng(veh10Lat, veh10Long), //position of marker

  //       icon: pinLocationIcon,
  //     ));
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

  Set<Marker> getMarkers() {
    Set<Marker> markers = {};

    setState(() {
      for (int i = 0; i < _vehicleCoordinates.length; i++) {
        final vehicle = _vehicleCoordinates[i];
        markers.add(Marker(
          markerId: MarkerId("ID${i + 1}"),
          position: LatLng(vehicle['latitude']!, vehicle['longitude']!),
          icon: pinLocationIcon,
        ));
      }
    });

    return markers;
  }

  //----------Service Not available in this area-------------//

  Future userUpdateLocation(
      String liveLat, String liveLong, String fcm, context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userToken = _sharedData.getString('maintoken');
    const String apiUrl = updateLocations;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken!},
      body: {
        "latitude": liveLat,
        "longitude": liveLong,
        'admin_id': adminId,
        "versionName": packageversion.toString(),
        "fcm_token": fcm
      },
    );

    print("===============$packageversion     $accessToken===============");
    print("Home Location Status " +
        response.statusCode.toString() +
        "         " +
        fcmTokenAuth);
    print("==============================");
    if (response.statusCode == 200) {
      int mainVal = jsonDecode(response.body)['zone_id'];
      String onoff = jsonDecode(response.body)['schedule_date'];

      if (mainVal > 0) {
        setState(() {
          serviceAvai = true;
          sched_acc = onoff == "ON" ? true : false;
        });
      } else {
        setState(() {
          serviceAvai = false;
          sched_acc = onoff == "ON" ? true : false;
        });
      }
    } else if (response.statusCode == 406) {
      String messagess = jsonDecode(response.body)['message'];
      EasyLoading.showToast(messagess);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NewAuthSelection()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Material(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                  child: Text(
                "System encountered Issue while processing your request.",
                textAlign: TextAlign.center,
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: serviceAvai != false
                  ? MediaQuery.of(context).size.height / 2.1
                  : MediaQuery.of(context).size.height / 1.6,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  GoogleMap(
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                    //Map widget from google_maps_flutter package
                    zoomGesturesEnabled: true, //enable Zoom in, out on map
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      //innital position in map
                      target: startLocation, //initial position
                      zoom: 17.0, //initial zoom level
                    ),
                    markers: getMarkers(),
                    mapType: MapType.normal, //map type
                    onMapCreated: (controller) {
                      //method called when map is created
                      mapController = controller;
                      mapController!.setMapStyle(mapStyle);
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
                    },
                  ),
                  Center(
                    //picker image on google map
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0, left: 1),
                      child: Image.asset(
                        "assets/images/pin.png",
                        width: 30,
                      ),
                    ),
                  ),
                  SafeArea(
                      child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          widget.zoomDrawerController.toggle();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.menu),
                        ),
                      ),
                      Expanded(child: PickUp()),
                    ],
                  )),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => MapSample()));
                        // Fluttertoast.showToast(
                        //     msg: veh1Lat.toString() +
                        //         "   " +
                        //         veh1Long.toString());
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
                                offset: const Offset(
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
                                offset: const Offset(
                                    2, 1), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              ),
                              //you can set more BoxShadow() here
                            ],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(Icons.gps_fixed_outlined),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: whiteColor,
              child: Column(
                children: [
                  serviceAvai == true
                      ? SizedBox()
                      : Container(
                          height: 200,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sorry, we don't serve\nthis location yet.",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'MonM',
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          "Our services are currently not\navailable in this city. We will notify\nyou as soon as we launch.",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontFamily: 'MonR',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: secondaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchPickUp(),
                                                    ));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 13.0),
                                                child: Text(
                                                  "Change Location",
                                                  style: TextStyle(
                                                    fontFamily: 'MonM',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              )),
                                        )
                                      ]),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 17.0, bottom: 65.0),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0, 1),
                                            color: Colors.black12,
                                            blurRadius: 1,
                                            spreadRadius: 1)
                                      ],
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Align(
                                      child: Image.asset(
                                        'assets/icons/no_service.png',
                                        height: 55,
                                        width: 55,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  serviceAvai == true ? SizedBox() : Divider(),
                  fareTypeActive.any((element) => element["id"] == 15) &&
                          !fareTypeActive
                              .any((element) => element["id"] == 16) &&
                          !fareTypeActive.any((element) => element["id"] == 17)
                      ? SizedBox()
                      : serviceAvai == false
                          ? SizedBox()
                          : Container(
                              height: 70,
                              color: whiteColor,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 5),
                                  fareTypeActive
                                          .any((element) => element["id"] == 15)
                                      ? Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              dropadd = "";
                                              outstatus = false;
                                            },
                                            child: Image.asset(
                                              'assets/mainpics/cityenable.png',
                                              height: 50,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  const SizedBox(width: 10),
                                  fareTypeActive
                                          .any((element) => element["id"] == 17)
                                      ? Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                fareType = "17";
                                                dropadd = "";
                                                outstatus = false;
                                              });
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RentalPage(
                                                    zoomDrawerController:
                                                        zoomDrawerControllersss,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/mainpics/rentaldisable.png',
                                              height: 50,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  const SizedBox(width: 10),
                                  fareTypeActive
                                          .any((element) => element["id"] == 16)
                                      ? Expanded(
                                          child: Align(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  fareType = "16";
                                                  dropadd = "";
                                                  outstatus = true;
                                                  out = true;
                                                  selectedDate = "";
                                                  scDate = '';
                                                  scTime = '';
                                                });
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OutStationPage(
                                                      zoomDrawerController:
                                                          zoomDrawerControllersss,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Align(
                                                child: Image.asset(
                                                  'assets/mainpics/outstationdisable.png',
                                                  height: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            ),
                  serviceAvai == false
                      ? SizedBox()
                      : DropLocationWidget(context),
                  serviceAvai == false
                      ? SizedBox()
                      : const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        // itemCount: snapshot.data!.length,
                        itemCount: _loadedPhotos.length,
                        // _loadedPhotos.length < 2 ? _loadedPhotos.length : 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: InkWell(
                              onTap: () async {
                                // DefaultCacheManager().emptyCache();
                                // setState(() {});

                                String uri =
                                    _loadedPhotos[index]['link'].toString();
                                _launchInBrowser(Uri.parse(uri));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.2), //color of shadow
                                          spreadRadius: 1, //spread radius
                                          blurRadius: 2, // blur radius
                                          offset: const Offset(0,
                                              2), // changes position of shadow
                                          //first paramerter of offset is left-right
                                          //second parameter is top to down
                                        ),
                                        //you can set more BoxShadow() here
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(bannerURL +
                                                  _loadedPhotos[index]
                                                      ['picture']
                                              // snapshot.data![index]
                                              //     ['picture'],
                                              ),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
