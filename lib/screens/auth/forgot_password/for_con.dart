import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/screens/auth/loginscreen.dart';

import '../../../constants/apiconstants.dart';
import '../../../constants/color_contants.dart';
import '../../../widgets/loder_dialg.dart';
import '../new_auth/login_new.dart';
import '../new_auth/new_auth_selected.dart';

class ForgotPasswordNewPass extends StatefulWidget {
  String emails;
  ForgotPasswordNewPass({Key? key, required this.emails}) : super(key: key);

  @override
  State<ForgotPasswordNewPass> createState() => _ForgotPasswordNewPassState();
}

class _ForgotPasswordNewPassState extends State<ForgotPasswordNewPass> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool pass = false;
  bool conpass = false;
  final _formKey3 = GlobalKey<FormState>();
  Future _changePassWord(context, String password) async {
    const String apiUrl = changeMainPassword;
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {"email": widget.emails, "password": password},
    );
    print("============Forgot Password==================");
    print(response.statusCode);
    print("==============================");
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
                "Password Updated Successfully...",
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
      //   context,
      //   CupertinoPageRoute(builder: (context) => NewAuthSelection()),
      //   (route) => false,
      // );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAuthSelection(),
          ));
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
              height: 50,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                jsonDecode(response.body)['message'].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "MonS",
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 35,
                        ),
                        Container(
                          height: 4,
                          width: 30,
                          margin: EdgeInsets.only(top: 14),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Set New Password",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 13,
                                  fontFamily: 'MonS',
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              margin: const EdgeInsets.symmetric(vertical: 14),
                              child: Stack(
                                children: [
                                  Material(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        color: Colors.yellow.shade500
                                            .withOpacity(0.4),
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Please Fill below fields to change your password...This step will change your current password for this app",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                              fontFamily: 'MonM',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Note:- We recommend you to logout nad relogin with new credential for better experience",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              fontFamily: 'MonM',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
                        //   child: TextFormField(
                        //     controller: _newPasswordController,
                        //     decoration: InputDecoration(
                        //       hintText: '********',
                        //       label: const Text("New Password"),
                        //       labelStyle: const TextStyle(
                        //         fontFamily: 'MonS',
                        //         fontSize: 13,
                        //         color: primaryColor,
                        //       ),
                        //       prefixIcon: const Icon(
                        //         Icons.password_outlined,
                        //         color: primaryColor,
                        //       ),
                        //       suffixIcon: InkWell(
                        //         onTap: () {
                        //           setState(() {
                        //             pass = !pass;
                        //           });
                        //         },
                        //         child: pass == false
                        //             ? Icon(
                        //                 Icons.visibility_off,
                        //                 color: primaryColor,
                        //               )
                        //             : Icon(
                        //                 Icons.visibility,
                        //                 color: primaryColor,
                        //               ),
                        //       ),
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(20.0),
                        //           borderSide: const BorderSide(color: primaryColor)),
                        //       focusedBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(20.0),
                        //           borderSide: const BorderSide(color: primaryColor)),
                        //     ),
                        //     obscureText: pass == false ? true : false,
                        //     obscuringCharacter: "*",
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return "Enter New Password";
                        //       }
                        //       if (value.length < 6) {
                        //         return "New Password must be least 6 chars long";
                        //       }
                        //     },
                        //   ),)
                        Text(
                          "Your New Password",
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
                                    controller: _newPasswordController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "MonM",
                                      fontSize: 12,
                                      letterSpacing: 1.0,
                                    ),
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Enter New Password",
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
                          "Confirm New Password",
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
                                    controller: _confirmPasswordController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "MonM",
                                      fontSize: 12,
                                      letterSpacing: 1.0,
                                    ),
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Confirm New Password",
                                      hintStyle: TextStyle(
                                          color: kindaBlack.withOpacity(0.3),
                                          fontFamily: "MonR",
                                          letterSpacing: 1.0,
                                          fontSize: 12),
                                    ),
                                    obscureText:
                                        conpass == false ? true : false,
                                    obscuringCharacter: '*',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter Confirm Password";
                                      }
                                      if (value.length < 6) {
                                        return "Confirm Password must be least 6 chars long";
                                      }
                                      if (_newPasswordController.text !=
                                          _confirmPasswordController.text) {
                                        return "New and Confirm Password doesnot match...";
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        conpass = !conpass;
                                      });
                                    },
                                    child: Icon(
                                      conpass == false
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
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
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
                                String newPass = _newPasswordController.text;
                                String conPass =
                                    _confirmPasswordController.text;

                                if (_formKey3.currentState!.validate()) {
                                  if (newPass == conPass) {
                                    showLoaderDialog(context, 50,
                                        "Updating your password...");
                                    await _changePassWord(context, newPass);
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Update Password",
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
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewAuthSelection(),
                                  ));
                            },
                            child: Text(
                              "Back to login",
                              style: TextStyle(
                                  color: secondaryColor.withOpacity(0.2),
                                  fontSize: 10,
                                  fontFamily: 'MonM',
                                  decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

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
