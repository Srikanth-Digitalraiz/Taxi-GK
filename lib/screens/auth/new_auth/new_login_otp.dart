import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/screens/splash/splashscreen.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
// import 'package:sms/sms.dart';

import '../../../constants/color_contants.dart';
import 'last_step.dart';
import 'login_new.dart';

class OTPVerifyPage extends StatefulWidget {
  final String phoneNumber, usID;
  const OTPVerifyPage(
      {Key? key, required this.phoneNumber, required this.usID});

  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> {
  Telephony telephony = Telephony.instance;

  TextEditingController _oneCopn = TextEditingController();
  TextEditingController _twCopn = TextEditingController();
  TextEditingController _threeCopn = TextEditingController();
  TextEditingController _fourCopn = TextEditingController();
  TextEditingController _fiveCopn = TextEditingController();
  TextEditingController _sixCopn = TextEditingController();

  String otp = '';
  String otp2 = '';

  // String otp = '';

  @override
  void initState() {
    super.initState();
    startListeningForSMS();
  }

  void startListeningForSMS() async {
    Telephony telephony = Telephony.instance;
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print('Received SMS: ${message.body}');
        // Add more debug information as needed

        // Extract OTP logic based on your SMS format
        String extractedOTP = extractOTP(message.body!);

        print(extractedOTP);

        // Update the UI with the OTP
        setState(() {
          otp = extractedOTP;

          if (extractedOTP.length >= 6) {
            _oneCopn.text = extractedOTP[0];
            _twCopn.text = extractedOTP[1];
            _threeCopn.text = extractedOTP[2];
            _fourCopn.text = extractedOTP[3];
            _fiveCopn.text = extractedOTP[4];
            _sixCopn.text = extractedOTP[5];

            setState(() {
              otp2 = _oneCopn.text +
                  _twCopn.text +
                  _threeCopn.text +
                  _fourCopn.text +
                  _fiveCopn.text +
                  _sixCopn.text;
            });
            EasyLoading.show();

            Future.delayed(Duration(seconds: 1), () {
              otpVerify();
            });
          }
        });
      },
      listenInBackground: false, // Set this to false to avoid assertion error
    );
  }

  String extractOTP(String messageBody) {
    // Implement your logic to extract the OTP from the SMS message
    // For example, using regular expressions
    // Adjust this logic based on the format of the SMS messages you receive
    RegExp regExp = RegExp(r'(\d{6})'); // Assumes a 6-digit OTP
    Match match = regExp.firstMatch(messageBody)!;
    return match?.group(1) ?? '';
  }

  // void startListeningForSMS() async {
  //   SmsOtpAutoVerify.listenForCode(
  //     onCodeReceived: (String code, String from) {
  //       // Process the incoming OTP
  //       print('Received OTP: $code');

  //       // Update the UI with the OTP
  //       setState(() {
  //         otp = code;
  //       });
  //     },
  //     onCodeTimeout: () {
  //       // Handle the case where the OTP code retrieval timed out
  //       print('OTP retrieval timed out');
  //     },
  //   );
  // }

  //   @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   listenForSms();
  // }

  // Future listenForSms() async {
  //   telephony.listenIncomingSms(
  //     onNewMessage: (SmsMessage message) {
  //       // Process the incoming SMS message
  //       print('Received SMS: ${message.body}');

  //       // Extract OTP logic can be added here based on your SMS format
  //       // extractAndUseOtp(message.body);
  //     },
  //     listenInBackground:
  //         false, // Set this to false to avoid the assertion error
  //   );
  // }

  // Future<void> extractAndUseOtp(String? smsBody) async {
  //   // Customize this method based on the format of your OTP in SMS
  //   // For example, if the OTP is the first 6-digit number in the SMS body:
  //   RegExp regExp = RegExp(r'\b(\d{6})\b');
  //   Iterable<RegExpMatch> matches = regExp.allMatches(smsBody!);

  //   for (RegExpMatch match in matches) {
  //     String otp = match.group(0) ?? '';
  //     print('Extracted OTP: $otp');

  //     // Use the OTP as needed, for example, you can update the UI with the OTP
  //     setState(() {
  //       _oneCopn.text = otp[0];
  //       _twCopn.text = otp[1];
  //       _threeCopn.text = otp[2];
  //       _fourCopn.text = otp[3];
  //       _fiveCopn.text = otp[4];
  //       _sixCopn.text = otp[5];
  //     });
  //   }
  // }

  Future sendOtp() async {
    // String? fcmtoken = await FirebaseMessaging.instance.getToken();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.ondeindia.com/api/user/login'));
    request.fields.addAll({
      'device_id': deviceIdssss.toString(),
      'device_type': deviceTypessss.toString(),
      'device_token': fcmmmm!,
      'mobile': widget.phoneNumber,
      'admin_id': adminId
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      EasyLoading.dismiss();
      EasyLoading.showToast("OTP Resent to your mobile number");

      setState(() {
        usID:
        decodedMap['data'][0]['id'].toString();
      });
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OTPVerifyPage(
      //       phoneNumber: _numberCon.text,
      //       ,
      //     ),
      //   ),
      // );
    } else {
      EasyLoading.showToast(response.reasonPhrase.toString());
      print(response.reasonPhrase);
    }
  }

  int valll = 0;

  Future otpVerify() async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.ondeindia.com/api/user/verify_otp'));
    request.fields.addAll({
      'userId': widget.usID,
      'otp': _oneCopn.text +
          _twCopn.text +
          _threeCopn.text +
          _fourCopn.text +
          _fiveCopn.text +
          _sixCopn.text,
      'admin_id': adminId
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      String userID = decodedMap['data'][0]['id'].toString();
      String name = decodedMap['data'][0]['first_name'].toString();
      String email = decodedMap['data'][0]['email'].toString();
      String mobile = decodedMap['data'][0]['mobile'].toString();
      String profile = decodedMap['data'][0]['picture'].toString();
      // String status = decodedMap['data'][0]['status'].toString();
      String rating = decodedMap['data'][0]['rating'].toString();
      String token = decodedMap['access_token'].toString();
      String usTypee = decodedMap['userType'].toString();

      _sharedData.setString('personid', userID);
      _sharedData.setString('personname', name);
      _sharedData.setString('personemail', email);
      _sharedData.setString('personmobile', mobile);
      _sharedData.setString('personprofile', profile);
      // _sharedData.setString('personstatus', status);
      _sharedData.setString('personrating', rating);
      _sharedData.setString('maintoken', token);

      // _sharedData.setString("oldPass", password);

      String resAdmin = decodedMap['data'][0]['admin_id'].toString();

      if (resAdmin == adminId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Material(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  "User verified Successfully",
                  style: TextStyle(
                    color: white,
                    fontFamily: 'MonM',
                    fontSize: 15,
                  ),
                )),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );

        if (usTypee == "old") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OneLastStep(userIII: widget.usID),
            ),
          );
        }

        // Navigator.pushAndRemoveUntil(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        //   (route) => false,
        // );
      } else {
        var responseString = await response.stream.bytesToString();
        final decodedMap = json.decode(responseString);
        EasyLoading.showToast(decodedMap['message']);
        print(response.reasonPhrase);
      }
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      EasyLoading.showToast(decodedMap['message']);
      print(response.reasonPhrase);
    }
  }

  // Future<String?> fetchOtpFromSms() async {
  //   try {
  //     SmsQuery query = SmsQuery();
  //     List<SmsMessage> messages = await query.getAllSms;

  //     // Assuming the OTP is the first 6-digit number found in the SMS messages
  //     RegExp regExp = RegExp(r'\b(\d{6})\b');

  //     for (SmsMessage message in messages) {
  //       String body = message.body ?? '';
  //       Iterable<RegExpMatch> matches = regExp.allMatches(body);

  //       for (RegExpMatch match in matches) {
  //         return match.group(0);
  //       }
  //     }

  //     return null; // If no OTP is found
  //   } catch (e) {
  //     print('Error fetching OTP from SMS: $e');
  //     return null;
  //   }
  // }

  // void _initializeAutoFetch() async {
  //   await SmsOtpAutoVerify.instance.initialize();
  //   SmsOtpAutoVerify.instance.setAutoVerificationTimeout(const Duration(minutes: 2));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      resizeToAvoidBottomInset: false,
      // backgroundColor: white,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: white,
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          "Verify OTP",
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
                    border: Border.all(color: Colors.black.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: Colors.black,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Help',
                        style: TextStyle(
                          color: Colors.black,
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter verification code",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Sent to ${widget.phoneNumber}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 30),
              //::::::::::::::::::::::::::::::::: otp screen ::::::::::::::::::::::::::::::::://
              //::::::::::::::::::::::::::::::::: otp screen ::::::::::::::::::::::::::::::::://
              //::::::::::::::::::::::::::::::::: otp screen ::::::::::::::::::::::::::::::::://

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildDigitInput(_oneCopn, _twCopn),
                  const SizedBox(width: 10),
                  buildDigitInput(_twCopn, _threeCopn),
                  const SizedBox(width: 10),
                  buildDigitInput(_threeCopn, _fourCopn),
                  const SizedBox(width: 10),
                  buildDigitInput(_fourCopn, _fiveCopn),
                  const SizedBox(width: 10),
                  buildDigitInput(_fiveCopn, _sixCopn),
                  const SizedBox(width: 10),
                  buildDigitInput(
                      _sixCopn, null), // Pass null for the last field
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     SizedBox(
              //         height: 55,
              //         width: 45,
              //         child: TextFormField(
              //           controller: _oneCopn,
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: 'MonM',
              //             fontSize: 15,
              //           ),
              //           autofocus: true,
              //           cursorWidth: 1,
              //           cursorHeight: 20,
              //           onChanged: (value) {
              //             if (value.length == 1) {
              //               FocusScope.of(context).nextFocus();
              //             }
              //           },
              //           textAlign: TextAlign.center,
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(1),
              //             FilteringTextInputFormatter.digitsOnly,
              //           ],
              //           keyboardType: TextInputType.phone,
              //           cursorColor: Colors.black,
              //           decoration: InputDecoration(
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //           ),
              //         )),
              //     const SizedBox(width: 10),
              //     SizedBox(
              //         height: 55,
              //         width: 45,
              //         child: TextFormField(
              //           controller: _twCopn,
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: 'MonM',
              //             fontSize: 15,
              //           ),
              //           onChanged: (value) {
              //             if (value.length == 1) {
              //               FocusScope.of(context).nextFocus();
              //             }
              //           },
              //           textAlign: TextAlign.center,
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(1),
              //             FilteringTextInputFormatter.digitsOnly,
              //           ],
              //           keyboardType: TextInputType.phone,
              //           cursorColor: Colors.black,
              //           decoration: InputDecoration(
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //           ),
              //         )),
              //     const SizedBox(width: 10),
              //     SizedBox(
              //         height: 55,
              //         width: 45,
              //         child: TextFormField(
              //           controller: _threeCopn,
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: 'MonM',
              //             fontSize: 15,
              //           ),
              //           onChanged: (value) {
              //             if (value.length == 1) {
              //               FocusScope.of(context).nextFocus();
              //             }
              //           },
              //           textAlign: TextAlign.center,
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(1),
              //             FilteringTextInputFormatter.digitsOnly,
              //           ],
              //           keyboardType: TextInputType.phone,
              //           cursorColor: Colors.black,
              //           decoration: InputDecoration(
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //           ),
              //         )),
              //     const SizedBox(width: 10),
              //     SizedBox(
              //         height: 55,
              //         width: 45,
              //         child: TextFormField(
              //           controller: _fourCopn,
              //           onChanged: (value) {
              //             if (value.length == 1) {
              //               FocusScope.of(context).nextFocus();
              //             }
              //           },
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: 'MonM',
              //             fontSize: 15,
              //           ),
              //           textAlign: TextAlign.center,
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(1),
              //             FilteringTextInputFormatter.digitsOnly,
              //           ],
              //           keyboardType: TextInputType.phone,
              //           cursorColor: Colors.black,
              //           decoration: InputDecoration(
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //           ),
              //         )),
              //     const SizedBox(width: 10),
              //     SizedBox(
              //         height: 55,
              //         width: 45,
              //         child: TextFormField(
              //           controller: _fiveCopn,
              //           onChanged: (value) {
              //             if (value.length == 1) {
              //               FocusScope.of(context).nextFocus();
              //             }
              //           },
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: 'MonM',
              //             fontSize: 15,
              //           ),
              //           textAlign: TextAlign.center,
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(1),
              //             FilteringTextInputFormatter.digitsOnly,
              //           ],
              //           keyboardType: TextInputType.phone,
              //           cursorColor: Colors.black,
              //           decoration: InputDecoration(
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //           ),
              //         )),
              //     const SizedBox(width: 10),
              //     SizedBox(
              //         height: 55,
              //         width: 45,
              //         child: TextFormField(
              //           controller: _sixCopn,
              //           onChanged: (value) {
              //             if (value.length == 1) {
              //               FocusScope.of(context).nextFocus();
              //             }
              //           },
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontFamily: 'MonM',
              //             fontSize: 15,
              //           ),
              //           textAlign: TextAlign.center,
              //           inputFormatters: [
              //             LengthLimitingTextInputFormatter(1),
              //             FilteringTextInputFormatter.digitsOnly,
              //           ],
              //           keyboardType: TextInputType.phone,
              //           cursorColor: Colors.black,
              //           decoration: InputDecoration(
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.black, width: 2.0),
              //             ),
              //           ),
              //         )),
              //   ],
              // ),
              SizedBox(
                height: 7,
              ),
              valll == 0
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        valll == -1
                            ? "* Please enter valid OTP"
                            : valll == -2
                                ? "* Please enter valid OTP"
                                : valll == 1
                                    ? "✓ Done"
                                    : "",
                        style: TextStyle(
                          color: valll == 1 ? Colors.green : Colors.red,
                          fontFamily: 'PopR',
                          fontSize: 10,
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  borderRadius: BorderRadius.circular(90),
                  onTap: () {
                    EasyLoading.show();
                    sendOtp();
                    // fetchOtpFromSms();
                  },
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.2))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Colors.black,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Colors.black,
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

              const SizedBox(height: 140),
              // button
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //         elevation: 1.0,
              //         fixedSize:
              //             Size(MediaQuery.of(context).size.width * 1.0, 45),
              //         // backgroundColor: Colors.blueAccent,
              //       ),
              //       onPressed: () {
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) => const OneLastStep(),
              //         //   ),
              //         // );
              //       },
              //       child: const Text(
              //         'Next',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 16,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BottomAppBar(
          child: Container(
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (_oneCopn.text == "" &&
                            _twCopn.text == "" &&
                            _threeCopn.text == "" &&
                            _fourCopn.text == "" &&
                            _fiveCopn.text == "" &&
                            _sixCopn.text == "") {
                          EasyLoading.showToast("Please enter valid OTP");
                        } else {
                          EasyLoading.show();
                          otpVerify();
                        }

                        // if (_oneCopn.text == "" ||
                        //     _twCopn.text == "" ||
                        //     _threeCopn.text == "" ||
                        //     _fourCopn.text == "" ||
                        //     _fiveCopn.text == "" ||
                        //     _sixCopn.text == "") {
                        //   setState(() {
                        //     valll = -1;
                        //   });
                        // } else {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => OneLastStep(),
                        //     ),
                        //   );
                        // }
                        // }
                        // else if (_numberCon.text.length < 10) {
                        //   setState(() {
                        //     valll = -2;
                        //   });
                        // } else {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => OTPVerifyPage(
                        //         phoneNumber: _numberCon.text,
                        //       ),
                        //     ),
                        //   );
                        // }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _oneCopn.text == "" ||
                                  _twCopn.text == "" ||
                                  _threeCopn.text == "" ||
                                  _fourCopn.text == "" ||
                                  _fiveCopn.text == "" ||
                                  _sixCopn.text == ""
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
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
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

  Widget buildDigitInput(
      TextEditingController controller, TextEditingController? nextController) {
    return SizedBox(
      height: 55,
      width: 45,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'MonM',
          fontSize: 15,
        ),
        autofocus: true,
        cursorWidth: 1,
        cursorHeight: 20,
        onChanged: (value) {
          if (value.length == 1 && nextController != null) {
            FocusScope.of(context).nextFocus();
            setState(() {});
          } else if (value.isEmpty && nextController == null) {
            // Handle backspace: Move focus to the previous field and clear its value
            FocusScope.of(context).previousFocus();
            setState(() {});
          } else if (value.isEmpty && nextController != null) {
            // Handle backspace: Move focus to the previous field and clear its value
            FocusScope.of(context).previousFocus();
            setState(() {});
            nextController.clear();
          }
        },
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.phone,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
      ),
    );
  }
}
