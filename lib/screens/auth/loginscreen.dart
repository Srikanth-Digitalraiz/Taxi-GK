import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/auth/forgot_password/forgotpass.dart';
import 'package:ondeindia/screens/auth/signup.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apiconstants.dart';
import '../../global/admin_id.dart';
import '../../widgets/loder_dialg.dart';
import '../home/home_screen.dart';

class NewAuthSelection2 extends StatefulWidget {
  const NewAuthSelection2({Key? key}) : super(key: key);

  @override
  State<NewAuthSelection2> createState() => _NewAuthSelection2State();
}

class _NewAuthSelection2State extends State<NewAuthSelection2> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future userlogin(String deviceID, String deviceType, String fcmToken,
      String email, String password, context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();

    const String apiUrl = login;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "device_id": deviceID,
        "device_type": deviceType,
        "device_token": fcmToken,
        "username": email,
        "password": password,
        "grant_type": "password",
        "code": "",
        "client_id": "2",
        "client_secret": clientSecret,
        "login_by": "manual",
        "admin_id": adminId
      },
    );

    if (response.statusCode == 200) {
      // ---------------- Data Storing ---------------- //

      String userID = jsonDecode(response.body)["0"]['id'].toString();
      String name = jsonDecode(response.body)["0"]['first_name'].toString();
      String email = jsonDecode(response.body)["0"]['email'].toString();
      String mobile = jsonDecode(response.body)["0"]['mobile'].toString();
      String profile = jsonDecode(response.body)["0"]['picture'].toString();
      // String status = jsonDecode(response.body)["0"]['status'].toString();
      String rating = jsonDecode(response.body)["0"]['rating'].toString();
      String token = jsonDecode(response.body)['access_token'].toString();

      _sharedData.setString('personid', userID);
      _sharedData.setString('personname', name);
      _sharedData.setString('personemail', email);
      _sharedData.setString('personmobile', mobile);
      _sharedData.setString('personprofile', profile);
      // _sharedData.setString('personstatus', status);
      _sharedData.setString('personrating', rating);
      _sharedData.setString('maintoken', token);

      _sharedData.setString("oldPass", password);

      String resAdmin = jsonDecode(response.body)["0"]['admin_id'].toString();

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
                child: Center(child: Text("User Login Successfull")),
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
            builder: (context) => HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "This account is not associated with this admin.");
      }

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomeScreen(),
      //     ));
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else if (response.statusCode == 403) {
      Navigator.pop(context);

      String userID = jsonDecode(response.body)['id'].toString();
      String number = jsonDecode(response.body)['mobile'].toString();

      showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: _newotpSection(userID, number),
          );
        },
      );
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
                  color: kindaBlack, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "user Credentials are incorrect...",
                style: TextStyle(color: Colors.white, fontFamily: 'MonM'),
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

  //---------------------Login Non OTP Verification---------------------//
  Future verifyOTP(String sssID, String otp, context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();

    const String apiUrl = signUpOTP;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "user_id": sssID,
        "otp": otp,
        'type': '0',
        'screen_type': 'login',
        "device_id": _deviceId,
        "device_type": _deviceType,
      },
    );

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Verified");

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
                  child: Text("User Verified and Logged In Successfully...")),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

      // ---------------- Data Storing ---------------- //

      String userID = jsonDecode(response.body)["0"]['id'].toString();
      String name = jsonDecode(response.body)["0"]['first_name'].toString();
      String email = jsonDecode(response.body)["0"]['email'].toString();
      String mobile = jsonDecode(response.body)["0"]['mobile'].toString();
      String profile = jsonDecode(response.body)["0"]['picture'].toString();
      // String status = jsonDecode(response.body)["0"]['status'].toString();
      String rating = jsonDecode(response.body)["0"]['rating'].toString();
      String token = jsonDecode(response.body)['access_token'].toString();

      _sharedData.setString('personid', userID);
      _sharedData.setString('personname', name);
      _sharedData.setString('personemail', email);
      _sharedData.setString('personmobile', mobile);
      _sharedData.setString('personprofile', profile);
      // _sharedData.setString('personstatus', status);
      _sharedData.setString('personrating', rating);
      _sharedData.setString('maintoken', token);

      // _sharedData.setString("oldPass", password);

      String resAdmin = jsonDecode(response.body)["0"]['admin_id'].toString();

      EasyLoading.dismiss();

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
                child: Center(child: Text("User Login Successfull")),
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
            builder: (context) => HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "This account is not associated with this admin.");
      }

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
      //           response.statusCode.toString(),
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

  String? _deviceId;

  String? _deviceType;

  bool pass = false;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    deviceType();
  }

  // Future<void> initPlatformState() async {
  //   String? deviceId;
  //   try {
  //     deviceId = await PlatformDeviceId.getDeviceId;
  //   } on PlatformException {
  //     deviceId = 'Failed to get deviceId.';
  //   }

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
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
                  // Text(
                  //   "GKCabs",
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //     color: secondaryColor,
                  //     fontFamily: "MonS",
                  //   ),
                  // )
                ],
              ),
              SizedBox(
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
              SizedBox(
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
                        "Your Mobile Number",
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor.withOpacity(0.5),
                          fontFamily: "MonS",
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: whiteColor,
                              border: Border.all(
                                  color: secondaryColor.withOpacity(0.1))),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              enabled: true,
                              controller: _emailController,
                              autofillHints: const [AutofillHints.email],
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: "MonM",
                                letterSpacing: 1.0,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                                hintText: "Enter your Mobile",
                                hintStyle: TextStyle(
                                    letterSpacing: 1.0,
                                    color: kindaBlack.withOpacity(0.3),
                                    fontFamily: "MonR",
                                    fontSize: 12),
                              ),
                              validator: (value) {
                                if (value!.length < 10) {
                                  return "Please enter valid number";
                                }
                              },
                              // EmailValidator.validate(value!)
                              //     ? null
                              //     : "Please enter a valid email",
                              onChanged: (v) {
                                setState(() {});
                              },
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your Password",
                        style: TextStyle(
                          fontSize: 12,
                          letterSpacing: 1.0,
                          color: secondaryColor.withOpacity(0.5),
                          fontFamily: "MonS",
                        ),
                      ),
                      SizedBox(
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "MonM",
                                    fontSize: 12,
                                    letterSpacing: 1.0,
                                  ),
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Enter Password",
                                    hintStyle: TextStyle(
                                        color: kindaBlack.withOpacity(0.3),
                                        fontFamily: "MonR",
                                        letterSpacing: 1.0,
                                        fontSize: 12),
                                  ),
                                  obscureText: pass == false ? true : false,
                                  obscuringCharacter: '*',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be atleast 6 characters long';
                                    }
                                    return null;
                                  },
                                  onChanged: (v) {
                                    setState(() {});
                                  },
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotVerificationPage(
                                      title: "Forgot Password"),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryColor.withOpacity(0.3),
                                letterSpacing: 1.0,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              _emailController.text != "" &&
                                      _passwordController.text != ""
                                  ? _emailController.text.length == 10 &&
                                          _passwordController.text.length >= 6
                                      ? primaryColor
                                      : Colors.grey.withOpacity(0.4)
                                  : Colors.grey.withOpacity(0.4)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),

                              // side: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          String useremail = _emailController.text;
                          String password = _passwordController.text;

                          String? fcmtoken =
                              await FirebaseMessaging.instance.getToken();

                          print(
                              "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");

                          if (_formKey.currentState!.validate()) {
                            showLoaderDialog(context, "Signing You In...", 10);
                            _otpController.clear();
                            await userlogin(
                                _deviceId.toString(),
                                _deviceType.toString(),
                                fcmtoken.toString(),
                                useremail,
                                password,
                                context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Material(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
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

                          // print("-----FCM---------> " +
                          //     fcmtoken.toString() +
                          //     " <-----------------");
                          // print("---------------->> " +
                          //     _deviceId.toString() +
                          //     " <<-------------");
                          // print("---------------->>>> " +
                          //     _deviceType.toString() +
                          //     " <<<<-------------");

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
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _emailController.text != "" ||
                                            _passwordController.text != ""
                                        ? secondaryColor
                                        : Colors.grey,
                                    letterSpacing: 1.0,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_rounded,
                                size: 30,
                                color: secondaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => SignUp(),
                            //     ),
                            //     (route) => false);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have Account?",
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
                                    "SignUp",
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
                      // SizedBox(
                      //   height: 13,
                      // ),
                      // Center(
                      //   child: InkWell(
                      //     onTap: () {
                      //       // Navigator.pushAndRemoveUntil(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //       builder: (context) => SignUp(),
                      //       //     ),
                      //       //     (route) => false);

                      //       // Navigator.pushReplacement(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //       builder: (context) => SignUp(),
                      //       //     ));
                      //     },
                      //     child: Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 40),
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(vertical: 10),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text(
                      //               "New OTP Screen",
                      //               style: TextStyle(
                      //                   fontFamily: 'MonM',
                      //                   fontSize: 12,
                      //                   color: kindaBlack,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
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
    );
  }

  TextEditingController _otpController = TextEditingController();

  _newotpSection(maid, manumber) {
    return Container(
      height: 250,
      color: whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 4,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              color: secondaryColor,
            ),
          ),
          Text(
            "Please verify your mobile number ($manumber) first to start using our service",
            style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontSize: 14,
                fontFamily: 'MonM'),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextFormField(
              autofocus: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              controller: _otpController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // O
              decoration: InputDecoration(
                counterText: "",
                hintText: 'ex: 8589',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 10,
              ),
              // TextButton(
              //   style: ButtonStyle(
              //     backgroundColor:
              //         MaterialStateProperty.all(Colors.grey.withOpacity(0.1)),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(80.0),

              //         // side: BorderSide(color: Colors.red),
              //       ),
              //     ),
              //   ),
              //   onPressed: () async {},
              //   child: Padding(
              //     padding: const EdgeInsets.all(2.0),
              //     child: Row(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             'Verify OTP',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               color: Colors.grey.shade900,
              //               letterSpacing: 1.0,
              //               fontSize: 12,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          _otpController.text != "" &&
                                  _otpController.text.length > 5
                              ? primaryColor
                              : Colors.grey.withOpacity(0.4)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),

                          // side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      // String useremail = _emailController.text;
                      String otp = _otpController.text;
                      EasyLoading.show();

                      verifyOTP(maid, otp, context);

                      // String? fcmtoken =
                      //     await FirebaseMessaging.instance.getToken();

                      // print(
                      //     "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");

                      // if (_formKey.currentState!.validate()) {
                      //   showLoaderDialog(context, "Signing You In...", 10);
                      //   await userlogin(
                      //       _deviceId.toString(),
                      //       _deviceType.toString(),
                      //       fcmtoken.toString(),
                      //       useremail,
                      //       password,
                      //       context);
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       content: Material(
                      //         elevation: 3,
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Container(
                      //           height: 60,
                      //           decoration: BoxDecoration(
                      //               color: Colors.red,
                      //               borderRadius:
                      //                   BorderRadius.circular(10)),
                      //           child: Center(
                      //               child: Text(
                      //             "Please Fill all the required details...",
                      //             style: TextStyle(color: Colors.white),
                      //           )),
                      //         ),
                      //       ),
                      //       behavior: SnackBarBehavior.floating,
                      //       backgroundColor: Colors.transparent,
                      //       elevation: 0,
                      //     ),
                      //   );
                      // }

                      // print("-----FCM---------> " +
                      //     fcmtoken.toString() +
                      //     " <-----------------");
                      // print("---------------->> " +
                      //     _deviceId.toString() +
                      //     " <<-------------");
                      // print("---------------->>>> " +
                      //     _deviceType.toString() +
                      //     " <<<<-------------");

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
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Verify OTP',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _emailController.text != "" ||
                                        _passwordController.text != ""
                                    ? secondaryColor
                                    : Colors.grey,
                                letterSpacing: 1.0,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_rounded,
                            size: 30,
                            color: secondaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
