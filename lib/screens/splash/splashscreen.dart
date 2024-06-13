import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:marquee_vertical/marquee_vertical.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/global/fare_type.dart';
import 'package:ondeindia/global/google_key.dart';
import 'package:ondeindia/main.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/screens/splash/intro_screens/introone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../../constants/apiconstants.dart';
import '../../global/current_location.dart';
import '../../global/data/user_data.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';

String? fcmmmm = "";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 30000),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceInOut,
  ));

  Timer? timer;

  @override
  void initState() {
    super.initState();

    getVersion();

    fcm();
    getGoogleAPI(context);
    getVal();

    Future.delayed(Duration(seconds: 3), () {
      if (valTok == "") {
        gooLogin();
      } else {
        getGoogleAPI(context);
        getLoc();
      }
    });

    // EasyLoading.showToast("Done");

    // Timer(Duration(seconds: 2), () async {
    //   print("Access Token------------>" + accessToken);
    //   accessToken == ""
    //       ? await Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => IntroScreen(),
    //           ),
    //         )
    //       : await Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => HomeScreen(),
    //           ),
    //         );
    // });
  }

  fcm() async {
    String? fcmtoken = await FirebaseMessaging.instance.getToken();

    print(
        "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");

    setState(() {
      fcmmmm = fcmtoken!;
      fcmTokenAuth = fcmtoken!;
    });

    print(
        "<-------------------- FCM TOKENsssssssssssssssss : $fcmmmm ----------------------------->");
  }

  gooLogin() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NewAuthSelection()),
        (route) => false);
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   timer?.cancel();
  //   super.dispose();
  // }

  Location _location = Location();
  LocationData? _currentPosition;

  Future<List> getGoogleAPI(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? userID = _token.getString('personid');
    String apiUrl = dynamicGoogleKey;
    final response = await http.post(
      Uri.parse(apiUrl),
      // headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {"admin_id": adminId},
    );

    SharedPreferences getDa = await SharedPreferences.getInstance();
    // EasyLoading.showToast(versionName);
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: "00000000>" + adminId);
      setState(() {
        gooAPIKey = jsonDecode(response.body)['app_api_key'].toString();
        fareTypeActive = jsonDecode(response.body)['serviceList'];
      });
      // EasyLoading.showToast(gooAPIKey);
      data();

      getListOfVeh();

      Future.delayed(const Duration(seconds: 2), () {
        if (gooAPIKey != "") {
          // accessToken == ""
          //     ? Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => IntroScreen()),
          //         (route) => false)
          //     : Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => HomeScreen(),
          //         ),
          //         (route) => false);
          // Fluttertoast.showToast(
          //     msg: jsonDecode(response.body)[0]['app_api_key'].toString());
          if (currentLat == 0.0 || currentLong == 0.0) {
            double? intLat = getDa.getDouble('initiallat');
            double? intLon = getDa.getDouble('initiallog');

            setState(() {
              currentLat = intLat!;
              currentLong = intLon!;
            });

            // final snackBar = SnackBar(
            //   content: const Text('Please wait while we fetch your location.'),
            //   // action: SnackBarAction(
            //   //   label: 'Undo',
            //   //   onPressed: () {
            //   //     // Some code to undo the change.
            //   //   },
            //   // ),
            // );

            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // getLoc();
            accessToken == ""
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => NewAuthSelection()),
                    (route) => false)
                : Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false);

            print(fareTypeActive);
          } else {
            accessToken == ""
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => NewAuthSelection()),
                    (route) => false)
                : Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false);
          }
          // Fluttertoast.showToast(msg: gooAPIKey);
        } else {
          getGoogleAPI(context);
        }
      });

      // Fluttertoast.showToast(msg: gooAPIKey);
      // Future.delayed(Duration(seconds: 6));

      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 412) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 500) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  //---------vehicles Data

  Future<List> getListOfVeh() async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    // SharedPreferences _token = await SharedPreferences.getInstance();
    // String? userToken = _token.getString('maintoken');
    String apiUrl = sourroundingVeh;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
    );
    // print(userId);
    if (response.statusCode == 200) {
      //Vehicle Data
      double vehOneLat =
          jsonDecode(response.body)['Vehicles'][0]['provider']['latitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][0]['provider']
                  ['latitude'];
      double vehOneLong =
          jsonDecode(response.body)['Vehicles'][0]['provider']['longitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][0]['provider']
                  ['longitude'];
      double vehTwoLat =
          jsonDecode(response.body)['Vehicles'][1]['provider']['latitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][1]['provider']
                  ['latitude'];
      double vehTwoLong =
          jsonDecode(response.body)['Vehicles'][1]['provider']['longitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][1]['provider']
                  ['longitude'];
      double vehThreeLat =
          jsonDecode(response.body)['Vehicles'][2]['provider']['latitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][2]['provider']
                  ['latitude'];
      double vehThreeLong =
          jsonDecode(response.body)['Vehicles'][2]['provider']['longitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][2]['provider']
                  ['longitude'];
      double vehFourLat =
          jsonDecode(response.body)['Vehicles'][3]['provider']['latitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][3]['provider']
                  ['latitude'];
      double vehFourLong =
          jsonDecode(response.body)['Vehicles'][3]['provider']['longitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][3]['provider']
                  ['longitude'];
      double vehFiveLat =
          jsonDecode(response.body)['Vehicles'][4]['provider']['latitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][4]['provider']
                  ['latitude'];
      double vehFiveLong =
          jsonDecode(response.body)['Vehicles'][4]['provider']['longitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][4]['provider']
                  ['longitude'];
      double vehSixLat =
          jsonDecode(response.body)['Vehicles'][5]['provider']['latitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][5]['provider']
                  ['latitude'];
      double vehSixLong =
          jsonDecode(response.body)['Vehicles'][5]['provider']['longitude'] == 0
              ? 0.0
              : jsonDecode(response.body)['Vehicles'][5]['provider']
                  ['longitude'];
      // double vehSevenLat =
      //     jsonDecode(response.body)['Vehicles'][6]['provider']['latitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][6]['provider']['latitude'];
      // double vehSevenLong =
      //     jsonDecode(response.body)['Vehicles'][6]['provider']['longitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][6]['provider']['longitude'];
      // double vehEightLat =
      //     jsonDecode(response.body)['Vehicles'][7]['provider']['latitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][7]['provider']['latitude'];
      // double vehEightLong =
      //     jsonDecode(response.body)['Vehicles'][7]['provider']['longitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][7]['provider']['longitude'];
      // double vehNineLat =
      //     jsonDecode(response.body)['Vehicles'][8]['provider']['latitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][8]['provider']['latitude'];
      // double vehNineLong =
      //     jsonDecode(response.body)['Vehicles'][8]['provider']['longitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][8]['provider']['longitude'];
      // double vehTenLat =
      //     jsonDecode(response.body)['Vehicles'][9]['provider']['latitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][9]['provider']['latitude'];
      // double vehTenLong =
      //     jsonDecode(response.body)['Vehicles'][9]['provider']['longitude'] == 0
      //         ? 0.0
      //         : jsonDecode(response.body)['result'][9]['provider']['longitude'];

      setState(() {
        veh1Lat = vehOneLat;
        veh1Long = vehOneLong;

        veh2Lat = vehTwoLat;
        veh2Long = vehTwoLong;

        veh3Lat = vehThreeLat;
        veh3Long = vehThreeLong;

        veh4Lat = vehFourLat;
        veh4Long = vehFourLong;

        veh5Lat = vehFiveLat;
        veh5Long = vehFiveLong;

        veh6Lat = vehSixLat;
        veh6Long = vehSixLong;

        // veh7Lat = vehSevenLat;
        // veh7Long = vehSevenLong;

        // veh8Lat = vehEightLat;
        // veh8Long = vehEightLong;

        // veh9Lat = vehNineLat;
        // veh9Long = vehNineLong;

        // veh10Lat = vehTenLat;
        // veh10Long = vehTenLong;
      });

      // _eta(veh1Lat, veh1Long);

      // return jsonDecode(response.body)['AdvertisingBanners'];
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

  String valTok = "";

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = info;
      });
    } catch (e) {
      print('Error getting package info: $e');
    }
  }

  getVal() async {
    SharedPreferences _getData = await SharedPreferences.getInstance();

    String? token = _getData.getString("maintoken");

    setState(() {
      valTok = token!;
      versionName = _packageInfo.version.toString();
    });
    print("dhfchjgkdsl;fdgxcjhkliuyfghvjkiughjvbmnjkhj======> $versionName");
  }

  void data() async {
    SharedPreferences _getData = await SharedPreferences.getInstance();

    String? id = _getData.getString('personid');
    String? name = _getData.getString("personname");
    String? email = _getData.getString("personemail");
    String? mobile = _getData.getString("personmobile");
    String? rating = _getData.getString("personrating");
    String? token = _getData.getString("maintoken");

    setState(() {
      userName = name!;
      userEmail = email!;
      userMobile = mobile!;
      userRating = rating!;
      userID = id!;
      accessToken = token!;
      // versionName = packageInfo.version.toString();
    });
  }

  final texts = [
    "Loading...",
    "Featching your location",
    "Getting you best offers",
    "Hang tight!",
    "Thank you 😀"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ShowUpAnimation(
                  delayStart: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 400),
                  curve: Curves.easeInBack,
                  direction: Direction.vertical,
                  offset: 0.5,
                  child: Container(
                    color: whiteColor,
                  ),
                ),
              ),
              Expanded(
                child: ShowUpAnimation(
                  delayStart: Duration(milliseconds: 400),
                  animationDuration: Duration(milliseconds: 400),
                  curve: Curves.easeInBack,
                  direction: Direction.vertical,
                  offset: 0.5,
                  child: Container(
                    color: whiteColor,
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ShowUpAnimation(
                delayStart: Duration(milliseconds: 700),
                animationDuration: Duration(milliseconds: 700),
                curve: Curves.bounceIn,
                direction: Direction.horizontal,
                offset: 0.5,
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        color: whiteColor),
                    child: Image.asset(
                      'assets/images/newlogoss.png',
                      height: 180,
                      width: 180,
                    )),
                // child: Image.asset(
                //   'assets/icons/mainlogo.png',
                //   height: 150,
                //   width: 150,
                // ),
              ),
              // child: Image.asset('assets/logo/mainlogo.png')
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'MonS',
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
                // MarqueeVertical(
                //   itemCount: texts.length,
                //   lineHeight: 20,
                //   marqueeLine: 1,
                //   direction: MarqueeVerticalDirection.moveUp,
                //   itemBuilder: (index) {
                //     return Align(
                //       alignment: Alignment.center,
                //       child: Text(
                //         texts[index],
                //         overflow: TextOverflow.ellipsis,
                // style: TextStyle(
                //   color: Colors.black,
                //   fontFamily: 'MonS',
                //   fontWeight: FontWeight.w300,
                //   fontSize: 12,
                // ),
                //       ),
                //     );
                //   },
                //   scrollDuration: const Duration(milliseconds: 200),
                //   stopDuration: const Duration(seconds: 1),
                // ),
                // Text(
                //   "Loading...",
                // style: TextStyle(
                //   color: white,
                //   fontFamily: 'PopR',
                //   fontWeight: FontWeight.w300,
                //   fontSize: 12,
                // ),
                // ),
                SizedBox(height: 100)
              ],
            ),
          )
        ],
      ),
    );
  }

  getLoc() async {
    SharedPreferences _preff = await SharedPreferences.getInstance();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await _location.getLocation();
    setState(() {
      currentLat = _currentPosition!.latitude!;
      currentLong = _currentPosition!.longitude!;
    });
    // _initialcameraposition =
    //     LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    _location.onLocationChanged.listen((LocationData currentLocation) {
      // print(
      //     " -------->------->>>------->>>>>>--------->> ${currentLocation.latitude} : ${currentLocation.longitude} <<<<<<------------<<<<<----------<---------- ");

      // String latitudes = currentLocation.latitude.toString();
      // String longitudes = currentLocation.longitude.toString();

      setState(() {
        // liveLat = latitudes;
        // liveLong = longitudes;
        currentLat = currentLocation.latitude!;
        currentLong = currentLocation.longitude!;
      });
      _preff.setDouble('initiallat', currentLocation.latitude!);
      _preff.setDouble('initiallog', currentLocation.longitude!);
      getGoogleAPI(context);
      // Fluttertoast.showToast(
      //     msg: currentLat.toString() + currentLong.toString());
    });
  }
}
