import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ondeindia/constants/apiconstants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/global/rental_fare_plan.dart';
import 'package:ondeindia/main.dart';
import 'package:ondeindia/screens/splash/splashscreen.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color_contants.dart';
import '../global/admin_id.dart';
import '../global/data/user_data.dart';
import '../global/distance.dart';
import '../global/fare_type.dart';
import '../global/out/out_pack.dart';
import '../screens/auth/new_auth/login_new.dart';
import '../screens/auth/new_auth/new_auth_selected.dart';
import '../screens/home/home_screen.dart';
import '../screens/settings/settings.dart';
import '../widgets/loder_dialg.dart';

//============================================================== Main Repo ==============================================================//

Future userLogout(String userToken, context) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();

  const String apiUrl = logout;
  final response = await http
      .post(Uri.parse(apiUrl), headers: {"Authorization": "Bearer " + userToken}
          // body: {
          //   "id": userID,
          // },
          );

  print("====================Logout Response==========");
  print(response.body.toString());
  print("====================Logout Response==========");
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
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              "User Logged Out Successfully",
              style: TextStyle(
                color: white,
              ),
            )),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    _sharedData.remove('maintoken');
    // Navigator.pushAndRemoveUntil(
    //     context, MaterialPageRoute(builder: (context) => NewAuthSelection()));
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
        (route) => false);
  } else {
    _sharedData.clear();
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
            child: Center(
                child: Text(
              "User logout Successfull.",
              style: TextStyle(
                color: white,
              ),
              textAlign: TextAlign.center,
            )),
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
          builder: (context) => NewAuthSelection(),
        ),
        (route) => false);
  }
}

Future changeUserPassword(context, String newPassword) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();
  String? userToken = _sharedData.getString('maintoken');
  String? usID = _sharedData.getString('personid');

  const String apiUrl = changePassword;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer" + userToken!},
    body: {"id": usID, "password": newPassword},
  );
  print("============Change Password==================");
  print(response.statusCode);
  print("==============================");
  if (response.statusCode == 200) {
    Navigator.pop(context);
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
            child: Center(
                child: Text(
              "Password changed Successfully",
              style: TextStyle(color: whiteColor, fontFamily: 'MonM'),
            )),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     CupertinoPageRoute(builder: (context) => HomeScreen()),
    //     (route) => false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  } else {
    Navigator.pop(context);
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

Future userUpdateLocation(
    String liveLat, String liveLong, String fcm, context) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();

  String? userToken = _sharedData.getString('maintoken');

  print(fcm);

  const String apiUrl = updateLocations;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken!},
    body: {
      "latitude": liveLat,
      "longitude": liveLong,
      'admin_id': adminId,
      'versionName': packageversion.toString(),
      "fcm_token": fcm
    },
  );

  print("===========$packageversion=== ${response.statusCode}================");
  // print("Location Status " +
  //     response.statusCode.toString() +
  //     "   " +
  //     liveLat.toString() +
  //     "   " +
  //     liveLong.toString() +
  //     "   " +
  //     versionName);
  print("==============================");
  if (response.statusCode == 200) {
  } else if (response.statusCode == 404) {
    EasyLoading.showToast("You session expired!\nPlease signIn again");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NewAuthSelection()),
        (route) => false);
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

Future<List> getReviews(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = driverRating;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Ratings'];
  } else if (response.statusCode == 400) {
    // Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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

Future addFavLocation(context, type, _address, lat, long) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = addFavLocations;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
    body: {
      "location_type": type,
      "address": _address,
      "latitude": lat,
      "longitude": long
    },
  );

  // print(userId);
  if (response.statusCode == 200) {
    Navigator.pop(context);
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
            child: Center(child: Text("Address Added to Fav. List")),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );

    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    // Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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

Future getValidZones(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = getValidZone;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
    body: {
      "s_latitude": pickLat,
      "s_longitude": pikLong,
      "d_latitude": dropLat,
      "d_longitude": dropLong
    },
  );

  Fluttertoast.showToast(
      msg: "$dropLat     $dropLong     $pickLat     $pikLong");

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
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text("Address Added to Fav. List")),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );

    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    // Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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

Future getRideFare(context, serviceID, name) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  var date1 = mainReturnDate.split(' ');
  DateTime date = DateTime.now();
  String date2 = DateFormat('yy-MM-dd').format(date);
  String? userToken = _token.getString('maintoken');
  String apiUrl = estimatedFare;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
    body: {
      "s_latitude": pickLat.toString(),
      "s_longitude": pikLong.toString(),
      "d_latitude": dropLat.toString(),
      "d_longitude": dropLong.toString(),
      "service_type": serviceID.toString(),
      "distance": distance.toStringAsFixed(4),
      "current_date": date2,
      "return_date": date1[0].toString(),
    },
  );

  Fluttertoast.showToast(
      msg: serviceID +
          "   " +
          pickLat.toString() +
          "   " +
          pikLong.toString() +
          "   " +
          dropLat.toString() +
          "   " +
          dropLong.toString());

  // print(userId);
  if (response.statusCode == 200) {
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
    Fluttertoast.showToast(msg: response.body.toString());

    return jsonDecode(response.body);
  } else if (response.statusCode == 400) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ));
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 412) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 500) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ));
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 403) {
    Fluttertoast.showToast(msg: response.body.toString());
  }
  throw 'Exception';
}

Future getTerms(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = terms;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Terms'];
  } else if (response.statusCode == 400) {
    // Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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

Future getTermsNonToken(context) async {
  var headers = {'Cookie': 'ci_session=bddn1iv5areruttdfh03usvfurtu167l'};
  var request = http.MultipartRequest(
      'GET',
      Uri.parse(
          'https://ondeindia.com/api/user/terms_conditions?admin_id=$adminId'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  // print(userId);
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    final decodedMap = json.decode(responseString);
    return decodedMap['Terms'];
  } else if (response.statusCode == 400) {
    // Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => NewAuthSelection(),
    //     ),
    //     (route) => false);
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

Future getPrivacy(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = privacy;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['PrivacyPolicy'];
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

Future getAboutUs(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = aboutus;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['AboutUs'];
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

Future<List> getPopularDestinations(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = pDestination;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Destinations'];
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

Future getUserProfile(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = getProfile;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Profile'];
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

Future<List> getOnGoingTrips(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = onGoingTrips;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['OngoingTrips'];
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

Future<List> getAllTrips(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = history;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['AllTrips'];
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

Future<List> getUpcomingRides(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = upComingRides;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['UpcomingTrips'];
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

Future<List> getTotalHistory(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = upComingRides;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['AllTrips'];
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

Future<List> getFavLocation(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = favLocation;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['location'];
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

Future<List> getRecentSearch(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = recentS;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['DestinationSearch'];
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

Future<List> getRecentSearchPick(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = recentS;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['PickupSearch'];
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

Future<List> getNotifications(context) async {
  SharedPreferences _token = await SharedPreferences.getInstance();
  String? userToken = _token.getString('maintoken');
  String apiUrl = inAppNotification;
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Notications'];
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

Future<List> getServices(context, eta, promo, dropA) async {
  // await Future.delayed(Duration(minutes: 10));
  SharedPreferences _token = await SharedPreferences.getInstance();
  double tottalDistance = distance + distance;
  var date1 = mainReturnDate.split(' ');
  DateTime date = DateTime.now();
  String date2 = selectedDate == ""
      ? DateFormat('yy-MM-dd').format(date)
      : DateFormat('yy-MM-dd').format(DateTime.parse(selectedDate));

  //Schedule Date Section

  // var schDate = "";
  // var schTime = "";

  // if (selectedDate != "") {
  //   var schdate = selectedDate.toString().split(" ");
  //   var schdate1 = schdate[0].toString();
  //   var schdate2 = schdate[1].toString().split(".");
  //   var mainTime = schdate2[0].toString();

  //   schDate = schdate1;
  //   schTime = mainTime;
  // } else {
  //   schDate = '';
  //   schTime = '';
  // }

  String? userToken = _token.getString('maintoken');
  String apiUrl = estimatedFare;
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

  // Fluttertoast.showToast(msg: "New Hot");
  // print('Services Data ${response.body}');
  // Fluttertoast.showToast(msg: "$fareType \n $mainReturnDate");
  print(
      "{---------Services Data-------  $pickLat     $pikLong     $dropLat      $dropLong    $distance    $rentalFarePlan     $fareType      $eta   $date2      ${date1[0].toString()}   ---------Services Data-------");
  print(
      "{{{{{{{{{{---------Promo Data-------${response.body}  ---------Promo Data-------}}}}}}}}}}}}}}}}");
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    SharedPreferences _zi = await SharedPreferences.getInstance();

    _zi.setString("couZID", jsonDecode(response.body)['zone_id'].toString());
    promo == ""
        ? null
        : Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);

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

Future<List> getNotificationVal(context) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();
  String? userID = _sharedData.getString('personid');
  String? userToken = _sharedData.getString('maintoken');
  String apiUrl = getNotiVal;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
    body: {"id": userID},
  );
  print(
      ">>>>>>>>>>>>>>. Get Notification Status Code >>>>>>>>>>>>>>> ${response.body.toString()}");
  // Fluttertoast.showToast(
  //     msg: ">>>>>>>>>>>>>>. Get Notification Status Code >>>>>>>>>>>>>>> " +
  //         jsonDecode(response.body)['Notifications'][0]['status']);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['Notifications'];
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

Future updateNotificationsVal(context) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();
  String? userID = _sharedData.getString('personid');
  String? userToken = _sharedData.getString('maintoken');
  String apiUrl = updateNotiVal;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
    body: {"user_id": userID},
  );
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
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(
              "Preferences Updated Successfully.",
              style: TextStyle(color: Colors.white),
            )),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
    return jsonDecode(response.body);
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

Future<List> getRentalPacks(context, _id) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();
  String? userID = _sharedData.getString('personid');
  String? userToken = _sharedData.getString('maintoken');
  String apiUrl = packs;
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Authorization": "Bearer " + userToken.toString()},
    body: {"id": _id},
  );
  // print(userId);
  if (response.statusCode == 200) {
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
    //         child: Center(
    //             child: Text(
    //           "Preferences Updated Successfully.",
    //           style: TextStyle(color: Colors.white),
    //         )),
    //       ),
    //     ),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ),
    // );
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => SettingsPage(),
    //     ));
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

//============================================================== Main Repo ==============================================================//

Future<List> getAds(context) async {
  // SharedPreferences _token = await SharedPreferences.getInstance();
  // String? userToken = _token.getString('maintoken');
  String apiUrl = images;
  final response = await http.get(
    Uri.parse(apiUrl),
    // headers: {"Authorization": "Bearer " + userToken.toString()},
  );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['images'];
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

Future<List> getTripsList() async {
  String apiUrl = trips;
  final response = await http.get(Uri.parse(apiUrl)
      // body: {"id": widget.urlID},
      );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['trips'];
  } else if (response.statusCode == 400) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 412) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 500) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 403) {
    Fluttertoast.showToast(msg: response.body.toString());
  }
  throw 'Exception';
}

Future<List> getNewTripsList() async {
  String apiUrl = newTrip;
  final response = await http.get(Uri.parse(apiUrl)
      // body: {"id": widget.urlID},
      );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['trips'];
  } else if (response.statusCode == 400) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 412) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 500) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 403) {
    Fluttertoast.showToast(msg: response.body.toString());
  }
  throw 'Exception';
}

Future<List> getRentalTimeData() async {
  String apiUrl = rentalTime;
  final response = await http.get(Uri.parse(apiUrl)
      // body: {"id": widget.urlID},
      );
  // print(userId);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['rentalprices'];
  } else if (response.statusCode == 400) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 412) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 500) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 401) {
    Fluttertoast.showToast(msg: response.body.toString());
  } else if (response.statusCode == 403) {
    Fluttertoast.showToast(msg: response.body.toString());
  }
  throw 'Exception';
}
