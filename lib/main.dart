import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ondeindia/global/current_location.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/splash/splashscreen.dart';
import 'package:ondeindia/screens/splash/update_splash.dart';
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'constants/apiconstants.dart';
import 'constants/color_contants.dart';
import 'language/lang.dart';

String fcmTokenAuth = "";

String packageversion = "";

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', //id
    'High Importance Notification', //title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessigningBackgroundHandler(RemoteMessage msg) async {
  await Firebase.initializeApp();
  print('A bg msg justshowed UP: ${msg.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessigningBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Timer? timer;
  Timer? timer2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      RemoteNotification? notification = msg.notification;
      AndroidNotification? android = msg.notification!.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: primaryColor,
              playSound: true,
              icon: '@mipmap/noti_logo',
              importance: Importance.high,
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was published");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });

    getpackageVer();

    timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      //User Location Update//
      getLoc();
      getpackageVer();
      // gettok();
      //Update Location

      print('Location updated');
      tokkks == ''
          ? null
          : userUpdateLocation(currentLat.toString(), currentLong.toString(),
              fcmTokenAuth, context);
    });

    tokkks == ''
        ? null
        : userUpdateLocation(currentLat.toString(), currentLong.toString(),
            fcmTokenAuth, context);
  }

  var tokkks = '';

  gettok() async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();

    String? userToken = _sharedData.getString('maintoken');

    print(userToken);

    setState(() {
      tokkks = userToken!;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getpackageVer() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print(packageInfo.version);

    setState(() {
      packageversion = packageInfo.version.toString();
    });
  }

  String _lan = "";

  void language() async {
    SharedPreferences sharedLan = await SharedPreferences.getInstance();
    String? languages = sharedLan.getString('lan');

    setState(() {
      _lan = languages!;
    });
  }

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);

  String? liveLat = "17.4916412";
  String? liveLong = "78.3936498";

  Location _location = Location();
  LocationData? _currentPosition;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pradeep Cabs',
        translations: LocaleString(),
        locale: Locale('en', 'US'),
        // locale: _lan == "0"
        //     ? Locale('en', 'US')
        //     : _lan == "1"
        //         ? Locale('hi', 'IN')
        //         : _lan == "2"
        //             ? Locale('tl', 'IN')
        //             : Locale('en', 'US'),
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        home: MyApp2(),
        // UpgradeAlert(
        //     upgrader: Upgrader(
        //       showLater: false,
        //       showIgnore: false,
        //       canDismissDialog: true,
        //       durationUntilAlertAgain: const Duration(minutes: 10),
        //       // shouldPopScope: false,
        //       // onIgnore: () {
        //       //   SystemNavigator.pop();
        //       //    throw UnsupportedError('_');
        //       // },
        //     ),
        //     child: SplashScreen()),
        builder: EasyLoading.init());
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    String? fcmtoken = await FirebaseMessaging.instance.getToken();

    print(
        "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");

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
      fcmTokenAuth = fcmtoken!;
    });
    _initialcameraposition =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    _location.onLocationChanged.listen((LocationData currentLocation) {
      // print(
      //     " -------->------->>>------->>>>>>--------->> ${currentLocation.latitude} : ${currentLocation.longitude} <<<<<<------------<<<<<----------<---------- ");

      String latitudes = currentLocation.latitude.toString();
      String longitudes = currentLocation.longitude.toString();

      setState(() {
        liveLat = latitudes;
        liveLong = longitudes;
        currentLat = currentLocation.latitude!;
        currentLong = currentLocation.longitude!;
        fcmTokenAuth = fcmtoken!;
      });
    });
  }
}
