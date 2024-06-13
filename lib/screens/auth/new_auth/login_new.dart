import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mobile_number/mobile_number.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/main.dart';
import 'package:ondeindia/screens/splash/splashscreen.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

import 'new_login_otp.dart';

import 'package:flutter/services.dart';
import 'package:mobile_number_picker/mobile_number_picker.dart';

String? deviceIdssss;

String? deviceTypessss;

String getNum = "";

const MethodChannel _channel = const MethodChannel('sim_info');

Color black = Colors.black;

class NewLoginScreen extends StatefulWidget {
  NewLoginScreen({Key? key}) : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  // void _showAlertDialog() async {
  //   List<Item> phoneNumbers = await _loadPhoneNumbers();

  //   // set up the buttons
  //   Widget okButton = TextButton(
  //     child: Text("OK"),
  //     onPressed: () {
  //       Navigator.of(context).pop();
  //     },
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Phone Numbers"),
  //     content: Container(
  //       width: double.maxFinite,
  //       child: ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: phoneNumbers.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return ListTile(
  //             title: Text(phoneNumbers[index].value!),
  //           );
  //         },
  //       ),
  //     ),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // Future<List<Item>> _loadPhoneNumbers() async {
  //   Iterable<Contact> contacts = await ContactsService.getContacts();
  //   List<Item> phoneNumbers = [];

  //   for (var contact in contacts) {
  //     for (var phone in contact.phones!) {
  //       phoneNumbers.add(phone);
  //     }
  //   }

  //   return phoneNumbers;
  // }
  MobileNumberPicker mobileNumber = MobileNumberPicker();
  MobileNumber mobileNumberObject = MobileNumber();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((timeStamp) => mobileNumber.mobileNumber());
    // Future.delayed(Duration(seconds: 2), () {
    //   func();
    // });

    initPlatformState();
    deviceTypse();

    // Future.delayed(Duration(seconds: 1), () {
    //   _showSimNumbersDialog(context);
    // });
  }

  func() async {
    scheduleMicrotask(() {
      NotificationHelper.showNotification();
    });
    await Future.delayed(
        Duration(milliseconds: 1000)); // Adjust the delay as needed

    mobileNumber.getMobileNumberStream.listen((MobileNumber? event) {
      if (event?.states == PhoneNumberStates.PhoneNumberSelected) {
        if (event!.phoneNumber != null) {
          setState(() {
            mobileNumberObject = event;
            getNum = event.phoneNumber!.toString();
            _numberCon.text = event.phoneNumber!.toString();
          });
        } else {
          print("Mobile number is null");
        }
      }
    });
    // Future.delayed(Duration(seconds: 2), () {
    //   print("num code called ----");

    // });
  }

  // static const platform = MethodChannel('your_channel');

  // static Future<void> showNotification(String title, String content) async {
  //   try {
  //     await platform.invokeMethod('showNotification', {
  //       'title': title,
  //       'content': content,
  //     });
  //   } on PlatformException catch (e) {
  //     print("Error: ${e.message}");
  //   }
  // }

  // func() {
  //   print("num code called ----");
  //   mobileNumber.getMobileNumberStream.listen((MobileNumber? event) {
  //     if (event?.states == PhoneNumberStates.PhoneNumberSelected) {
  //       setState(() {
  //         mobileNumberObject = event!;
  //         _numberCon.text = mobileNumberObject.phoneNumber!;
  //         createPendingIntent();
  //         // showNumberDi`alog(mobileNumberObject.phoneNumber!);
  //       });
  //     }
  //   });
  //   // createPendingIntent();
  // }

  // void createPendingIntent() async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     // onSelectNotification: (String? payload) async {
  //     //   // Handle the notification selection
  //     // },
  //   );

  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id',
  //     'Your Channel Name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );

  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   // Replace this with your specific PendingIntent logic
  //   // Example: Creating a PendingIntent that opens the app on notification tap
  //   const String payload = 'your_custom_data';

  //   // Set the flags for the PendingIntent
  //   // final PendingIntent pendingIntent = await PendingIntent.getActivity(
  //   //   // ... add your parameters
  //   //   flags: <int>[PendingIntent.FLAG_IMMUTABLE],
  //   // );

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Title',
  //     'Body',
  //     platformChannelSpecifics,
  //     payload: payload,
  //     // Use the created PendingIntent
  //     // Example:
  //     // onSelectNotification: (String? payload) async {
  //     //   // Handle the notification selection
  //     // },
  //     // payload: payload,
  //     // android: AndroidNotificationDetails(
  //     //   pendingIntent: pendingIntent,
  //     // ),
  //   );
  // }

  // static const platform = const MethodChannel('mobile_number');

  // func() {
  //   print("num code called ----");
  //   mobileNumber.getMobileNumberStream.listen((MobileNumber? event) {
  //     if (event?.states == PhoneNumberStates.PhoneNumberSelected) {
  //       setState(() {
  //         mobileNumberObject = event!;
  //         _numberCon.text = mobileNumberObject.phoneNumber!;

  //         // Call the platform.invokeMethod here
  //         platform.invokeMethod('getMobileNumber', {
  //           // Additional arguments if needed
  //         });
  //       });
  //     }
  //   });
  // }

  // void showNumberDialog(String phoneNumber) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return DialogsLoading(numbers: phoneNumber);
  //     },
  //   );
  // }

  bool pass = false;

  Future<void> initPlatformState() async {
    // String? deviceIdssss;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // For iOS
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceIdssss = iosInfo.identifierForVendor!; // Unique ID on iOS
      });
    } else {
      // For Android
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceIdssss = androidInfo.id;
        // devID = androidInfo.id;
      });
      // print(devID);
    }
  }

  Future<void> _openURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void deviceTypse() {
    if (Platform.isAndroid) {
      setState(() {
        deviceTypessss = "android";
      });
    } else if (Platform.isIOS) {
      setState(() {
        deviceTypessss = "ios";
      });
    } else {
      setState(() {
        deviceTypessss = "";
      });
    }
  }

  TextEditingController _numberCon = TextEditingController(text: getNum);
  int valll = 0;

  Future sendOtp() async {
    // String? fcmtoken = await FirebaseMessaging.instance.getToken();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.ondeindia.com/api/user/login'));
    request.fields.addAll({
      'device_id': "",
      'device_type': deviceTypessss.toString(),
      'device_token': fcmmmm!,
      'mobile': _numberCon.text,
      'admin_id': adminId,
      "versionName": packageversion.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      EasyLoading.dismiss();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerifyPage(
            phoneNumber: _numberCon.text,
            usID: decodedMap['data'][0]['id'].toString(),
          ),
        ),
      );
    } else if (response.statusCode == 406) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      EasyLoading.showToast(decodedMap['message']);
    } else {
      EasyLoading.showToast(response.reasonPhrase.toString());
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: white,
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "Login",
          style: TextStyle(
            fontFamily: 'MonM',
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        actions: [
          Align(
            child: InkWell(
              onTap: () {
                FlutterPhoneDirectCaller.callNumber('9866600720');
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    border: Border.all(color: black.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Help',
                        style: TextStyle(
                          color: black,
                          fontFamily: "MonM",
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "What’s your number ?",
              style: TextStyle(
                  color: black,
                  fontFamily: 'MonS',
                  fontSize: 22,
                  letterSpacing: 1),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'Enter your number to proceed`',
              style: TextStyle(
                  color: black.withOpacity(0.6),
                  fontFamily: 'MonR',
                  fontSize: 10,
                  letterSpacing: 1),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: black, width: 2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 0.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.call_outlined,
                        color: black,
                        size: 23,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          controller: _numberCon,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 10,
                          cursorColor: black,
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                color: black.withOpacity(0.3),
                                fontSize: 13,
                                fontFamily: 'MonR',
                              )),
                          onChanged: (val) {
                            if (_numberCon.text == "") {
                              setState(() {
                                valll = -1;
                              });
                            } else if (_numberCon.text.length < 10) {
                              setState(() {
                                valll = -2;
                              });
                            } else {
                              setState(() {
                                valll = 1;
                              });
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 7,
            ),
            valll == 0
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      valll == -1
                          ? "* Please enter mobile number first"
                          : valll == -2
                              ? "* Please enter valid mobile number first"
                              : valll == 1
                                  ? "✓ Please continue the process"
                                  : "",
                      style: TextStyle(
                        color: valll == 1 ? Colors.green : Colors.red,
                        fontFamily: 'MonR',
                        fontSize: 10,
                      ),
                    ),
                  ),
            SizedBox(height: 10),
            // PhoneFieldHint(),fT
            SizedBox(height: 10),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       _showSimNumbersDialog(context);
            //     },
            //     child: Text('Fetch SIM Numbers'),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BottomAppBar(
          child: Container(
              height: 110,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: RichText(
                      text: TextSpan(
                        text: 'By continuing you agree to the ',
                        style: TextStyle(
                          fontFamily: 'MonR',
                          letterSpacing: 1,

                          // fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 10,
                        ),
                        children: [
                          TextSpan(
                            text: 'T&C',
                            style: TextStyle(
                              fontFamily: 'MonR',
                              decoration: TextDecoration.underline,
                              // fontStyle: FontStyle.italic,
                              fontSize: 10,
                              letterSpacing: 1,
                              color: Color(0xFF009ED9),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle T&C tap
                                _openURL(
                                    "https://gkcabs.com/general-terms-and-conditions.html");
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              fontFamily: 'MonR',
                              letterSpacing: 1,

                              // fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 10,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              fontFamily: 'MonR',
                              decoration: TextDecoration.underline,
                              // fontStyle: FontStyle.italic,
                              fontSize: 10,
                              letterSpacing: 1,
                              color: Color(0xFF009ED9),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle T&C tap
                                _openURL(
                                    "https://gkcabs.com/privacy-policy.html");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (_numberCon.text == "") {
                          setState(() {
                            valll = -1;
                          });
                        } else if (_numberCon.text.length < 10) {
                          setState(() {
                            valll = -2;
                          });
                        } else {
                          EasyLoading.show();
                          sendOtp();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => OTPVerifyPage(
                          //       phoneNumber: _numberCon.text,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _numberCon.text == ""
                              ? Color(0xFFDCDCDC)
                              : Color(0xFF009ED9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 1, // blur radius
                              offset:
                                  Offset(2, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 1, // blur radius
                              offset:
                                  Offset(-2, -2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11.0),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: white,
                                fontFamily: 'MonM',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10)
                ],
              )),
        ),
      ),
    );
  }

  Future<void> _showSimNumbersDialog(BuildContext context) async {
    List<String>? simNumbers = await _getSimNumbers();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Continue with',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                        fontFamily: 'MonM',
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  for (String number in simNumbers!)
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: () {
                        String num = number;
                        String stringWithoutFirstTwoChars = num.substring(2);
                        Navigator.of(context).pop();
                        // setState(() {
                        //   getNum = stringWithoutFirstTwoChars;
                        // });
                        // EasyLoading.showToast(getNum);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogsLoading(
                                  numbers: stringWithoutFirstTwoChars);
                            });
                        // Navigator.pop(context);
                      },
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                      title: Text(
                        number.substring(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MonM',
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  Divider(),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.blue,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                    title: Text(
                      "None of the above",
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'MonM',
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<String>?> _getSimNumbers() async {
    try {
      List<String>? simNumbersWithCountryCode = await getSimCards();

      // Extract only the numbers without country code
      List<String> simNumbersWithoutCountryCode = simNumbersWithCountryCode!
          .map((simNumber) => _extractNumberWithoutCountryCode(simNumber))
          .toList();

      return simNumbersWithoutCountryCode;
    } catch (e) {
      print('Error fetching SIM numbers: $e');
      return [];
    }
  }

  // Function to extract the number without country code
  String _extractNumberWithoutCountryCode(String simNumber) {
    // Replace this with your logic to extract only the number without the country code
    // For example, you might want to remove the first few digits representing the country code
    // The logic below assumes that the country code is followed by a space
    int spaceIndex = simNumber.indexOf(" ");
    return spaceIndex != -1 ? simNumber.substring(spaceIndex + 1) : simNumber;
  }

  Future<List<String>?> getSimCards() async {
    try {
      return await _channel.invokeListMethod<String>('getSimCards');
    } catch (e) {
      print('Error fetching SIM numbers: $e');
      return [];
    }
  }
}

class DialogsLoading extends StatefulWidget {
  String numbers;
  DialogsLoading({Key? key, required this.numbers}) : super(key: key);

  @override
  State<DialogsLoading> createState() => _DialogsLoadingState();
}

class _DialogsLoadingState extends State<DialogsLoading> {
  bool sentData = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    deviceTypessss();

    // Future.delayed(Duration(seconds: 2), () {
    //   sendOtp();
    // });
  }

  String? _deviceIdssss = "";

  String? _deviceTypessss = "";

  bool pass = false;

  //  Future<void> getdeviceIdssss() async {
  //   try {
  //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //     if (Theme.of(context).platform == TargetPlatform.iOS) {
  //       // For iOS
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       setState(() {
  //         deviceIdssss = iosInfo.identifierForVendor!; // Unique ID on iOS
  //       });
  //     } else {
  //       // For Android
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       setState(() {
  //         deviceIdssss = androidInfo.id;
  //         devID = androidInfo.id;
  //       });
  //       print(devID);
  //     }
  //   } catch (e) {
  //     print('Error getting device ID: $e');
  //   }
  // }

  Future<void> initPlatformState() async {
    String? deviceIdssss;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // For iOS
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _deviceIdssss = iosInfo.identifierForVendor!; // Unique ID on iOS
      });
    } else {
      // For Android
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _deviceIdssss = androidInfo.id;
        // devID = androidInfo.id;
      });
      // print(devID);
    }

    // try {
    //   deviceIdssss = "234567890876543";
    //   // await PlatformdeviceIdssss.getdeviceIdssss;
    // } on PlatformException {
    //   deviceIdssss = 'Failed to get deviceIdssss.';
    // }

    if (!mounted) return;

    setState(() {
      _deviceIdssss = deviceIdssss;
      print("deviceIdssss->$_deviceIdssss");
    });
  }

  void deviceTypessss() {
    if (Platform.isAndroid) {
      setState(() {
        _deviceTypessss = "android";
      });
    } else if (Platform.isIOS) {
      setState(() {
        _deviceTypessss = "ios";
      });
    } else {
      setState(() {
        _deviceTypessss = "";
      });
    }
  }

  // TextEditingController _numberCon = TextEditingController(text: getNum);
  // int valll = 0;

  Future sendOtp() async {
    print("ndvjkbshjfbvhjs========>$fcmmmm");
    // String? fcmtoken = await FirebaseMessaging.instance.getToken();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.ondeindia.com/api/user/login'));
    request.fields.addAll({
      'device_id': "",
      // _deviceIdssss.toString(),
      'device_type': _deviceTypessss.toString(),
      'device_token': fcmmmm!,
      'mobile': widget.numbers,
      'admin_id': adminId
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        sentData = true;
      });
      // EasyLoading.dismiss();
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        // Navigator.pushAndRemoveUntil(
        //     context,

        //     (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerifyPage(
              phoneNumber: widget.numbers,
              usID: decodedMap['data'][0]['id'].toString(),
            ),
          ),
        );
      });
    } else {
      EasyLoading.showToast(response.reasonPhrase.toString());
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
            width: 5,
            color: primaryColor.withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90), color: white),
              child: sentData == true
                  ? Icon(Icons.check_circle, color: Colors.green, size: 52)
                  : CircularProgressIndicator(
                      strokeWidth: 3,
                      color: primaryColor,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                sentData == true
                    ? "OTP has been sent to your number. Please verify to continue."
                    : "Please wait while we send OTP on the mobile number for verification",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: 'MonM', // Replace with the desired font family
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationHelper {
  static const MethodChannel _channel =
      MethodChannel('noti_channel'); // replace with your channel name

  static Future<void> showNotification() async {
    await _channel.invokeMethod('showNotification');
  }
}
