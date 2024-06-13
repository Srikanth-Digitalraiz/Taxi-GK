import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/screens/auth/forgot_password/for_con.dart';
import 'package:ondeindia/screens/auth/loginscreen.dart';
// import 'package:otp_timer_button/otp_timer_button.dart';

import '../../../constants/apiconstants.dart';
import '../../../constants/color_contants.dart';
import '../../../global/admin_id.dart';

class ForgotVerificationPage extends StatefulWidget {
  final String title;
  ForgotVerificationPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ForgotVerificationPage> createState() => _ForgotVerificationPageState();
}

class _ForgotVerificationPageState extends State<ForgotVerificationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // OtpTimerButtonController otpResendcontroller = OtpTimerButtonController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  bool butonDis = false;

  bool pass = false;
  bool conpass = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Forgot Password APIS
  Future forgotDriverPassword(context, String email) async {
    const String apiUrl = forgotPasswordEmail;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"email": email},
    );
    // print("============Forgot Password==================");
    // print(response.statusCode);
    // print("==============================");
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
                "OTP Sent successfully...",
                style: TextStyle(color: whiteColor, fontFamily: 'MonM'),
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      showModalBottomSheet(
          isDismissible: false,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: _bottomSheet(),
            );
          });
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => NewAuthSelection()));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Material(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  jsonDecode(response.body)['message'].toString(),
                  style: TextStyle(
                    color: secondaryColor,
                    fontFamily: "MonM",
                  ),
                  textAlign: TextAlign.center,
                ),
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

  //Forgot Password APIS
  Future otpVerification(context, String email, String otp) async {
    const String apiUrl = otpVerify;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"email": email, "otp": otp, "admin_id": adminId},
    );
    // print("============Forgot Password==================");
    // print(response.statusCode);
    // print("==============================");
    if (response.statusCode == 200) {
      Navigator.pop(context);
      _otpController.clear();
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
                "OTP Verified...",
                style: TextStyle(color: whiteColor, fontFamily: 'MonM'),
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ForgotPasswordNewPass(emails: email)));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)['message'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 13,
                        fontFamily: 'MonM',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.asset('assets/animation/changepass.gif',
                            height: 200)),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Please enter your registered Mobile Number for Verification...",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'MonS',
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "*Note: You will be recieving OTP the Mobile number",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'MonM',
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                    SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
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
                                autofillHints: const [
                                  AutofillHints.telephoneNumber
                                ],
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 10,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontFamily: "MonM",
                                  letterSpacing: 1.0,
                                ),
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: "Enter your mobile",
                                  hintStyle: TextStyle(
                                      letterSpacing: 1.0,
                                      color: kindaBlack.withOpacity(0.3),
                                      fontFamily: "MonR",
                                      fontSize: 12),
                                ),
                                validator: (value) {
                                  if (value!.length != 10) {
                                    return "Please enter a valid number";
                                  }
                                }),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Form(
                    //   key: _formKey,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //         left: 8.0, right: 8.0, top: 2.0),
                    //     child: TextFormField(
                    //       controller: _emailController,
                    //       inputFormatters: [
                    //         FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                    //       ],
                    //       keyboardType: TextInputType.emailAddress,
                    //       decoration: InputDecoration(
                    //         hintText: 'ex: your@mail.com',
                    //         label: const Text("Email Address"),
                    //         labelStyle: const TextStyle(
                    //           fontFamily: 'MonS',
                    //           fontSize: 13,
                    //           color: primaryColor,
                    //         ),
                    //         suffixIcon: const Icon(
                    //           Icons.email_outlined,
                    //           color: primaryColor,
                    //         ),
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(20.0),
                    //             borderSide:
                    //                 const BorderSide(color: primaryColor)),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(20.0),
                    //             borderSide:
                    //                 const BorderSide(color: primaryColor)),
                    //       ),
                    //       validator: (value) => EmailValidator.validate(value!)
                    //           ? null
                    //           : "Please enter a valid email",
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),

                                  // side: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              String email = _emailController.text;
                              if (_formKey.currentState!.validate()) {
                                showLoaderDialog(
                                    context, 50, "Verifying Mobile...");
                                _otpController.clear();
                                await forgotDriverPassword(context, email);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Enter valid Mobile Number");
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Send OTP",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 13,
                                  fontFamily: 'MonM',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 30,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
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
            height: 50,
            width: 50,
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
                    height: 30,
                    width: 30,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Please Enter the OTP sent to your notifications \n Thank you",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'MonM',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey2,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: whiteColor,
                      border:
                          Border.all(color: secondaryColor.withOpacity(0.1))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 15),
                    child: TextFormField(
                        enabled: true,
                        controller: _otpController,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: "MonM",
                          letterSpacing: 1.0,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: "Enter your OTP",
                          hintStyle: TextStyle(
                              letterSpacing: 1.0,
                              color: kindaBlack.withOpacity(0.3),
                              fontFamily: "MonR",
                              fontSize: 12),
                        ),
                        validator: (value) {
                          if (value == "") {
                            return "Enter OTP";
                          }
                          if (value!.length < 4) {
                            return "Enter Valid OTP";
                          }
                        }),
                  )),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // OtpTimerButton(
                  //   controller: otpResendcontroller,
                  //   backgroundColor: secondaryColor,
                  //   onPressed: () async {
                  //     String email = _emailController.text;
                  //     if (_formKey.currentState!.validate()) {
                  //       Navigator.pop(context);
                  //       showLoaderDialog(context, 50, "Verifying Email...");
                  //       await forgotDriverPassword(context, email);
                  //     } else {
                  //       Fluttertoast.showToast(
                  //           msg: "Enter valid Email Address");
                  //     }
                  //   },
                  //   text: Text(
                  //     'Resend OTP',
                  //     style: TextStyle(
                  //       fontSize: 10,
                  //       fontFamily: 'MonM',
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  //   duration: 30,
                  // ),
                  SizedBox(
                    width: 15,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),

                          // side: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      String _email = _emailController.text;
                      String _otp = _otpController.text;
                      if (_formKey2.currentState!.validate()) {
                        Navigator.pop(context);
                        showLoaderDialog(context, 50, "Verifying OTP");
                        await otpVerification(context, _email, _otp);
                      } else {
                        Fluttertoast.showToast(msg: "Enter Valid OTP");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Verify OTP",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 12,
                          fontFamily: 'MonM',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget _changePassword() {
  //   bool pass1 = false, pass2 = false;
  //   return
  // }

  showLoaderDialog(BuildContext context, int delay, String text) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          const CircularProgressIndicator(
            color: primaryColor,
            backgroundColor: kindaBlack,
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontFamily: "MonM",
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: delay), () {});
        return alert;
      },
    );
  }
}
