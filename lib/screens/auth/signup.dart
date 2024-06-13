import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/screens/auth/loginscreen.dart';
import 'package:ondeindia/screens/auth/new_auth/new_auth_selected.dart';
// import 'package:otp_timer_button/otp_timer_button.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apiconstants.dart';
import '../../constants/color_contants.dart';
import '../../global/admin_id.dart';
import '../../global/data/user_data.dart';
import '../../repositories/tripsrepo.dart';
import '../../widgets/loder_dialg.dart';
import '../home/home_screen.dart';
import 'new_auth/login_new.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Register Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  bool pass = false;
  bool confirmpass = false;

  String? _deviceId;

  String? _deviceType;

  //Widget Switch
  bool value = false;

  //SMS
  String? _textContent = 'Waiting for messages...';

  // OtpTimerButtonController controller = OtpTimerButtonController();

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    deviceType();
    // _smsReceiver = SmsReceiver(onSmsReceived, onTimeout: onTimeout);
    // _startListening();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String? deviceId;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     deviceId = await PlatformDeviceId.getDeviceId;
  //   } on PlatformException {
  //     deviceId = 'Failed to get deviceId.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _deviceId = deviceId;
  //     print("deviceId->$_deviceId");
  //   });
  // }

  void deviceType() {
    if (Platform.isAndroid) {
      setState(() {
        _deviceType = "android";
      });
    } else if (Platform.isIOS) {
      setState(() {
        _deviceType = "ios";
      });
    } else {
      setState(() {
        _deviceType = "";
      });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String verificationID = "";

  //SignUp
  Future userSignUp(
      String deviceID,
      String deviceType,
      String fcmToken,
      String name,
      String email,
      String mobile,
      String password,
      context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();

    const String apiUrl = signUp;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'admin_id': adminId,
        "device_id": deviceID,
        "device_type": deviceType,
        "device_token": fcmToken,
        "first_name": name,
        "email": email,
        "mobile": mobile,
        "password": password,
        // "otp": ootp,
        "login_by": "manual"
      },
    );
    // Fluttertoast.showToast(msg: response.statusCode.toString());
    print("============================== Sign Up Response " +
        jsonDecode(response.body).toString());

    // String jsonsDataString = response.body
    //     .toString(); // toString of Response's body is assigned to jsonDataString
    // String _data = jsonDecode(jsonsDataString);
    // print(response.statusCode.toString() + "   " + _data.toString());
    print(" ============================== Sign Up Response");
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      // ---------------- Data Storing ---------------- //

      String userID = jsonDecode(response.body)['message']['id'].toString();

      // Fluttertoast.showToast(msg: userID);
      // String name =
      //     jsonDecode(response.body)['message']['first_name'].toString();
      // String email = jsonDecode(response.body)['message']['email'].toString();
      // String mobile = jsonDecode(response.body)['message']['mobile'].toString();
      // // String accessT = jsonDecode(response.body)['access_token'].toString();
      // // String profile = jsonDecode(response.body)['picture'].toString();
      // // // String status = jsonDecode(response.body)['status'].toString();
      // // String rating = jsonDecode(response.body)['rating'].toString();
      // String token = jsonDecode(response.body)['access_token'].toString();

      _sharedData.setString('personid', userID);
      // _sharedData.setString('personname', name);
      // _sharedData.setString('personemail', email);
      // _sharedData.setString('personmobile', mobile);
      // _sharedData.setString('maintoken', accessT);
      // _sharedData.setString('personprofile', profile);
      // // _sharedData.setString('personstatus', status);
      // _sharedData.setString('personrating', rating);
      // _sharedData.setString('maintoken', token);

      showModalBottomSheet(
          isDismissible: false,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: _verifyMobile(),
            );
          });

      EasyLoading.dismiss();

      // await verifyOTP(ootp, context);

      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NewAuthSelection(),
      //     ),
      //     (route) => false);
    } else {
      EasyLoading.dismiss();
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
                jsonDecode(response.body)['msg'].toString(),
                style: const TextStyle(color: Colors.white, fontFamily: 'MonM'),
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

  Future verifyOTP(String otp, context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? uID = _sharedData.getString('personid');

    const String apiUrl = signUpOTP;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "user_id": uID,
        "otp": otp,
        'type': '0',
        'screen_type': 'registeration',
        "device_id": _deviceId,
        "device_type": _deviceType,
      },
    );
    // Fluttertoast.showToast(
    //     msg: uID.toString() +
    //         " " +
    //         " " +
    //         response.statusCode.toString() +
    //         " " +
    //         response.body.toString());
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Verified");
      // String? id = _sharedData.getString('personid');
      // String? name = _sharedData.getString("personname");
      // String? email = _sharedData.getString("personemail");
      // String? mobile = _sharedData.getString("personmobile");
      // String? rating = _sharedData.getString("personrating");

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
                  child: Text("User Verified and Registered Successfully...")),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

      EasyLoading.dismiss();
      // ---------------- Data Storing ---------------- //

      String userID = jsonDecode(response.body)['message']['id'].toString();
      String name =
          jsonDecode(response.body)['message']['first_name'].toString();
      String email = jsonDecode(response.body)['message']['email'].toString();
      String mobile = jsonDecode(response.body)['message']['mobile'].toString();
      String accessT = jsonDecode(response.body)['access_token'].toString();
      // String profile = jsonDecode(response.body)['picture'].toString();
      // // String status = jsonDecode(response.body)['status'].toString();
      // String rating = jsonDecode(response.body)['rating'].toString();
      // String token = jsonDecode(response.body)['access_token'].toString();

      _sharedData.setString('personid', userID);
      _sharedData.setString('personname', name);
      _sharedData.setString('personemail', email);
      _sharedData.setString('personmobile', mobile);
      _sharedData.setString('maintoken', accessT);

      // setState(() {
      //   userName = name!;
      //   userEmail = email!;
      //   userMobile = mobile!;
      //   userRating = rating!;
      //   userID = id!;
      //   // accessToken = token!;
      // });
      _otpController.clear();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    } else {
      EasyLoading.dismiss();
      EasyLoading.showToast('Invalid OTP. Please enter valid OTP');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Material(
      //       elevation: 3,
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       child: Container(
      //         height: 60,
      //         decoration: BoxDecoration(
      //             color: kindaBlack, borderRadius: BorderRadius.circular(10)),
      //         child: Center(
      //             child: Text(
      //           jsonDecode(response.body)['msg'].toString(),
      //           style: const TextStyle(color: Colors.white, fontFamily: 'MonM'),
      //           textAlign: TextAlign.center,
      //         )),
      //       ),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // );
    }
  }

  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  Widget _verifyMobile() {
    return Container(
      height: 450,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            height: 6,
            width: 30,
            margin: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: primaryColor,
            ),
          ),
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Stack(
              children: [
                Material(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.yellow.shade500.withOpacity(0.4),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/changepassword.png',
                    height: 70,
                    width: 70,
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Please Enter the OTP sent to you \n Thank you",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'MonM',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Form(
            key: _formKey2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
              child: TextFormField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                controller: _otpController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // O
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'ex: 858989',
                  label: const Text("OTP"),
                  labelStyle: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 13,
                    color: primaryColor,
                  ),
                  suffixIcon: const Icon(
                    Icons.password_outlined,
                    color: primaryColor,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: primaryColor)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter OTP";
                  }
                  if (value.length < 6) {
                    return "Please enter valid OTP";
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () async {
                      // EasyLoading.show();

                      //Details
                      // String username = _nameController.text;
                      // String useremail = _emailController.text;
                      // String userMobile = _mobileController.text;
                      // String password = _password.text;

                      String? fcmtoken =
                          await FirebaseMessaging.instance.getToken();

                      print(
                          "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");
                      //OTP Structure
                      String _otp = _otpController.text;

                      Fluttertoast.showToast(msg: _otp);
                      if (_otp != "" && _otp.length == 6) {
                        EasyLoading.show();
                        verifyOTP(_otp, context);
                      }
                      // showLoaderDialog(context, "Verifying Email...", 10);
                      // await verifyOTP(_otp, context);
                      else {
                        Fluttertoast.showToast(msg: "Enter valid OTP");
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 15,
                          fontFamily: 'MonS',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/newlogoss.png',
                  height: 90,
                  width: 90,
                ),
                // Image.asset(
                //   'assets/images/smallnewlogg.png',
                //   height: 30,
                //   width: 30,
                // ),
                // const Text(
                //   "GKCabs",
                //   style: TextStyle(
                //     fontSize: 25,
                //     color: secondaryColor,
                //     fontFamily: "MonS",
                //   ),
                // )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "No fun in waiting for cab.",
              style: TextStyle(
                fontSize: 12,
                color: secondaryColor.withOpacity(0.3),
                fontFamily: "MonS",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Name",
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor.withOpacity(0.5),
                        fontFamily: "MonS",
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: whiteColor,
                            border: Border.all(
                                color: secondaryColor.withOpacity(0.1))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 15),
                          child: TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]")),
                            ],
                            controller: _nameController,
                            style: const TextStyle(
                                color: Colors.black, fontFamily: "MonM"),
                            decoration: InputDecoration.collapsed(
                              hintText: "Enter your Name",
                              hintStyle: TextStyle(
                                  color: kindaBlack.withOpacity(0.3),
                                  fontFamily: "MonR",
                                  fontSize: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Name';
                              }
                              return null;
                            },
                          ),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Your Email Address",
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor.withOpacity(0.5),
                        fontFamily: "MonS",
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: whiteColor,
                            border: Border.all(
                                color: secondaryColor.withOpacity(0.1))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 15),
                          child: TextFormField(
                            controller: _emailController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                            ],
                            style: const TextStyle(
                                color: Colors.black, fontFamily: "MonM"),
                            decoration: InputDecoration.collapsed(
                              hintText: "Enter your Email",
                              hintStyle: TextStyle(
                                  color: kindaBlack.withOpacity(0.3),
                                  fontFamily: "MonR",
                                  fontSize: 12),
                            ),
                            validator: (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Please enter a email address",
                          ),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Your Mobile Number",
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor.withOpacity(0.5),
                        fontFamily: "MonS",
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: whiteColor,
                            border: Border.all(
                                color: secondaryColor.withOpacity(0.1))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            controller: _mobileController,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                color: Colors.black, fontFamily: "MonM"),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              hintText: "Enter your Mobile",
                              hintStyle: TextStyle(
                                  color: kindaBlack.withOpacity(0.3),
                                  fontFamily: "MonR",
                                  fontSize: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter valid Mobile Number';
                              }
                              if (value.length < 10) {
                                return 'Mobile number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Set your password",
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor.withOpacity(0.5),
                        fontFamily: "MonS",
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: whiteColor,
                          border: Border.all(
                              color: secondaryColor.withOpacity(0.1))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _password,
                                maxLength: 14,
                                style: const TextStyle(
                                    color: Colors.black, fontFamily: "MonM"),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                      color: kindaBlack.withOpacity(0.3),
                                      fontFamily: "MonR",
                                      fontSize: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be atleast 6 characters long';
                                  }
                                  return null;
                                },
                                obscureText: pass == false ? true : false,
                                obscuringCharacter: "*",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    pass = !pass;
                                  });
                                },
                                child: Icon(
                                  pass == false
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kindaBlack.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Confirm your new password",
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor.withOpacity(0.5),
                        fontFamily: "MonS",
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: whiteColor,
                          border: Border.all(
                              color: secondaryColor.withOpacity(0.1))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _confirmPass,
                                maxLength: 14,
                                style: const TextStyle(
                                    color: Colors.black, fontFamily: "MonM"),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                      color: kindaBlack.withOpacity(0.3),
                                      fontFamily: "MonR",
                                      fontSize: 12),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be atleast 6 characters long';
                                  }
                                  if (_password.text != _confirmPass.text) {
                                    return 'Password and Confirm Password does not match';
                                  }
                                  return null;
                                },
                                obscureText:
                                    confirmpass == false ? true : false,
                                obscuringCharacter: "*",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    confirmpass = !confirmpass;
                                  });
                                },
                                child: Icon(
                                  confirmpass == false
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: kindaBlack.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4.5,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: primaryColor,
                          value: this.value,
                          onChanged: (bool? value) {
                            setState(() {
                              this.value = !this.value;
                            });
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              this.value = !this.value;
                            });
                          },
                          child: const Text(
                            "Agree to Terms and Conditions",
                            style: TextStyle(
                              fontFamily: "MonM",
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 18.0, top: 3),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              // color: primaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  _emailController.text != "" &&
                                          _password.text != "" &&
                                          _confirmPass.text != "" &&
                                          value != false
                                      ? _emailController.text.contains('@') &&
                                              _password.text.length >= 6 &&
                                              _mobileController.text.length ==
                                                  10 &&
                                              _nameController.text != ""
                                          ? primaryColor
                                          : Colors.grey.withOpacity(0.4)
                                      : Colors.grey.withOpacity(0.4)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),

                                  // side: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              //Details
                              String username = _nameController.text;
                              String useremail = _emailController.text;
                              String userMobile = _mobileController.text;
                              String password = _password.text;
                              String? fcmtoken =
                                  await FirebaseMessaging.instance.getToken();

                              if (_formKey.currentState!.validate()) {
                                if (_confirmPass.text == _password.text) {
                                  if (value != false) {
                                    EasyLoading.show();
                                    _otpController.clear();
                                    userSignUp(
                                        _deviceId.toString(),
                                        _deviceType.toString(),
                                        fcmtoken.toString(),
                                        username.toString(),
                                        useremail,
                                        userMobile.toString(),
                                        password,
                                        context);
                                    // auth.verifyPhoneNumber(
                                    //   phoneNumber:
                                    //       "+91" + _mobileController.text,
                                    //   verificationCompleted:
                                    //       (PhoneAuthCredential
                                    //           credential) async {
                                    //     await auth
                                    //         .signInWithCredential(credential)
                                    //         .timeout(Duration(seconds: 30))
                                    //         .then((value) {
                                    //       print(
                                    //           "You are logged in successfully");
                                    //     });
                                    //   },
                                    //   verificationFailed:
                                    //       (FirebaseAuthException e) {
                                    //     print(e.message);
                                    //   },
                                    //   codeSent: (String verificationId,
                                    //       int? resendToken) {
                                    //     _otpController.clear();

                                    //     verificationID = verificationId;
                                    //     setState(() {});
                                    //   },
                                    //   codeAutoRetrievalTimeout:
                                    //       (String verificationId) {},
                                    // );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Material(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                                child: Text(
                                              "Agree with our terms and coditions",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Material(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Center(
                                            child: const Text(
                                              "Password and Confirm password does not match",
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Material(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Center(
                                            child: Text(
                                          "Please Fill all the required details...",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
                              }
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const HomeScreen(),
                              //   ),
                              // );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => TestMap(),
                              //   ),
                              // );
                              // TestMap
                            },
                            child: const Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontFamily: 'MonM',
                                  fontSize: 15,
                                  color: whiteColor,
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
            ),
            const SizedBox(
              height: 13,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewAuthSelection(),
                      ),
                      (route) => false);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have Account!",
                          style: const TextStyle(
                              fontFamily: 'MonM',
                              fontSize: 10,
                              color: kindaBlack,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const Text(
                          "Login",
                          style: const TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Have Look at our',
                style: const TextStyle(
                  fontFamily: 'MonR',
                  fontSize: 10,
                  color: kindaBlack,
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: _termsDialog(),
                        );
                      });
                },
                child: Text(
                  ' Terms & Condition ',
                  style: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*

 body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                // SizedBox(
                //   height: 8,
                // ),

                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: InkWell(
                //       onTap: () {
                //         Navigator.pushAndRemoveUntil(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => NewAuthSelection(),
                //             ),
                //             (route) => false);
                //       },
                //       child: Container(
                //         height: 50,
                //         width: 50,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(80),
                //             color: Color(0xFFC2DED1).withOpacity(0.5)),
                //         child: Icon(
                //           Icons.arrow_back_outlined,
                //           color: Colors.black,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: Container(
                //     height: 90,
                //     width: 90,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(90),
                //       color: Color(0xFFECE5C7).withOpacity(0.3),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: Image.asset(
                //         'assets/images/newlogoss.png',
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 20,
                ),
                Image.asset('assets/images/userlog.png',
                    width: 100, height: 100),
                SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "MonB",
                        fontSize: 25,
                        color: kindaBlack,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: primaryColor.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 15),
                                child: TextFormField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z ]")),
                                  ],
                                  controller: _nameController,
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: "MonM"),
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Enter your Name",
                                    hintStyle: TextStyle(
                                        color: kindaBlack.withOpacity(0.3),
                                        fontFamily: "MonR",
                                        fontSize: 12),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Name';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: primaryColor.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 15),
                                child: TextFormField(
                                  controller: _emailController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'\s')),
                                  ],
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: "MonM"),
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Enter your Email",
                                    hintStyle: TextStyle(
                                        color: kindaBlack.withOpacity(0.3),
                                        fontFamily: "MonR",
                                        fontSize: 12),
                                  ),
                                  validator: (value) =>
                                      EmailValidator.validate(value!)
                                          ? null
                                          : "Please enter a email address",
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: primaryColor.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  controller: _mobileController,
                                  maxLength: 10,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: "MonM"),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: "",
                                    hintText: "Enter your Mobile",
                                    hintStyle: TextStyle(
                                        color: kindaBlack.withOpacity(0.3),
                                        fontFamily: "MonR",
                                        fontSize: 12),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter valid Mobile Number';
                                    }
                                    if (value.length < 10) {
                                      return 'Mobile number must be 10 digits';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: primaryColor.withOpacity(0.2),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _password,
                                      maxLength: 14,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "MonM"),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintText: "Enter Password",
                                        hintStyle: TextStyle(
                                            color: kindaBlack.withOpacity(0.3),
                                            fontFamily: "MonR",
                                            fontSize: 12),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be atleast 6 characters long';
                                        }
                                        return null;
                                      },
                                      obscureText: pass == false ? true : false,
                                      obscuringCharacter: "*",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        pass = !pass;
                                      });
                                    },
                                    child: Icon(
                                      pass == false
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: kindaBlack.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: primaryColor.withOpacity(0.2),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _confirmPass,
                                      maxLength: 14,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "MonM"),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(
                                            color: kindaBlack.withOpacity(0.3),
                                            fontFamily: "MonR",
                                            fontSize: 12),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (value.length < 6) {
                                          return 'Password must be atleast 6 characters long';
                                        }
                                        if (_password.text !=
                                            _confirmPass.text) {
                                          return 'Password and Confirm Password does not match';
                                        }
                                        return null;
                                      },
                                      obscureText:
                                          confirmpass == false ? true : false,
                                      obscuringCharacter: "*",
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        confirmpass = !confirmpass;
                                      });
                                    },
                                    child: Icon(
                                      confirmpass == false
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: kindaBlack.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: primaryColor,
                              value: this.value,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.value = value!;
                                });
                              },
                            ),
                            Text(
                              "Agree to Terms and Conditions",
                              style: TextStyle(
                                fontFamily: "MonM",
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 18.0, top: 3),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_confirmPass.text == _password.text) {
                                      if (value != false) {
                                        auth.verifyPhoneNumber(
                                          phoneNumber:
                                              "+91" + _mobileController.text,
                                          verificationCompleted:
                                              (PhoneAuthCredential
                                                  credential) async {
                                            await auth
                                                .signInWithCredential(
                                                    credential)
                                                .then((value) {
                                              print(
                                                  "You are logged in successfully");
                                            });
                                          },
                                          verificationFailed:
                                              (FirebaseAuthException e) {
                                            print(e.message);
                                          },
                                          codeSent: (String verificationId,
                                              int? resendToken) {
                                            _otpController.clear();
                                            showModalBottomSheet(
                                                isDismissible: false,
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return Padding(
                                                    padding:
                                                        MediaQuery.of(context)
                                                            .viewInsets,
                                                    child: _verifyMobile(),
                                                  );
                                                });
                                            verificationID = verificationId;

                                            setState(() {});
                                          },
                                          codeAutoRetrievalTimeout:
                                              (String verificationId) {},
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Material(
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                    child: Text(
                                                  "Agree with our terms and coditions",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              ),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Material(
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Text(
                                                  "Password and Confirm password does not match",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Material(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              "Please Fill all the required details...",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    );
                                  }

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const HomeScreen(),
                                  //   ),
                                  // );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => TestMap(),
                                  //   ),
                                  // );
                                  // TestMap
                                },
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontFamily: 'MonM',
                                      fontSize: 15,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewAuthSelection(),
                                  ),
                                  (route) => false);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have Account!",
                                      style: TextStyle(
                                          fontFamily: 'MonM',
                                          fontSize: 12,
                                          color: kindaBlack,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                          fontFamily: 'MonS',
                                          fontSize: 12,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            'assets/images/loinillus.png',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Have a look at our ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'MonM',
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                              text: ' Terms and Conditions ',
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 10,
                                fontFamily: 'MonB',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: _termsDialog(),
                                        );
                                      });
                                }),
                          TextSpan(
                            text: ' & ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'MonM',
                            ),
                          ),
                          TextSpan(
                              text: ' Privacy Policy ',
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 10,
                                fontFamily: 'MonB',
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: _privacyDialog(),
                                        );
                                      });
                                }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),


  */

  Widget _termsDialog() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        color: whiteColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: const Text(
                "Terms and Conditions",
                style: const TextStyle(
                  color: kindaBlack,
                  fontSize: 15,
                  fontFamily: 'MonS',
                ),
                textAlign: TextAlign.start,
              ),
            ),
            FutureBuilder(
                future: getTermsNonToken(context),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          backgroundColor: kindaBlack,
                          color: primaryColor,
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(bannerURL + snapshot.data['image']),
                        SizedBox(
                          height: 20,
                        ),
                        Html(
                          data: snapshot.data['en_description'],
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _privacyDialog() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.1,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(15),
        ),
        color: whiteColor,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                height: 4,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Privacy Policy",
                style: TextStyle(
                  color: kindaBlack,
                  fontSize: 15,
                  fontFamily: 'MonS',
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0),
              child: Image.network('http://ondeindia.com/asset/img/onede.png'),
            ),
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, ",
                style: TextStyle(
                  color: kindaBlack,
                  fontSize: 12,
                  fontFamily: 'MonM',
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

 Container(
              color: Colors.black.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    decoration: InputDecoration.collapsed(hintText: "")),
              )),
 */
