import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/color_contants.dart';
import '../../../repositories/tripsrepo.dart';

class VerificationPage extends StatefulWidget {
  final String title;
  VerificationPage({Key? key, required this.title}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    super.initState();
    oldPassword();
  }

  String oldPass = "";
  oldPassword() async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? pass = _sharedData.getString('oldPass');
    setState(() {
      oldPass = pass!;
    });
  }

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                      ),
                    ),
                    Text(
                      widget.title == "Change Password"
                          ? "changepass".tr
                          : widget.title,
                      style: TextStyle(
                        color: kindaBlack,
                        fontSize: 15,
                        fontFamily: 'MonM',
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/animation/changepass.gif'),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          "changeAle".tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'MonS',
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20),
                          child: RichText(
                            text: TextSpan(
                              text: "changeinfo".tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontFamily: 'MonM',
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'changefor'.tr,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'MonB',
                                  ),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0),
                        child: TextFormField(
                          controller: _oldPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            hintText: 'changehint'.tr,
                            label: Text("changeold".tr),
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
                                borderSide:
                                    const BorderSide(color: primaryColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide:
                                    const BorderSide(color: primaryColor)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your old password to continue...";
                            }
                            if (value.length < 5) {
                              return "Please enter valid password";
                            }
                            if (value.length < 6) {
                              return "Old password can not be less than 6 chars.";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            onPressed: () {
                              String enteredPass = _oldPasswordController.text;
                              if (_formKey.currentState!.validate()) {
                                if (oldPass == enteredPass) {
                                  _oldPasswordController.clear();
                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.of(context).viewInsets,
                                          child: _changePassword(),
                                        );
                                      });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Material(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "Your Entered Password doesnot match your Old Password...\n\n Try Again",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "MonM",
                                                fontSize: 14,
                                              ),
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
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "changeverify".tr,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 15,
                                  fontFamily: 'MonS',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _bottomSheet() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 1.8,
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 10,
  //           width: 50,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(40),
  //               bottomRight: Radius.circular(40),
  //             ),
  //             color: primaryColor,
  //           ),
  //         ),
  //         Container(
  //           height: 100,
  //           width: 100,
  //           margin: const EdgeInsets.symmetric(vertical: 20),
  //           child: Stack(
  //             children: [
  //               Material(
  //                 elevation: 4,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(70),
  //                 ),
  //                 child: Container(
  //                   height: 100,
  //                   width: 100,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(70),
  //                     color: Colors.yellow.shade500.withOpacity(0.4),
  //                   ),
  //                 ),
  //               ),
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Image.asset(
  //                   'assets/icons/changepassword.png',
  //                   height: 70,
  //                   width: 70,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             "Please Enter the OTP sent on you mobile number \n\n Thank you",
  //             style: TextStyle(
  //               color: kindaBlack,
  //               fontSize: 15,
  //               fontFamily: 'MonR',
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 15,
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
  //           child: TextFormField(
  //             keyboardType: TextInputType.number,
  //             inputFormatters: <TextInputFormatter>[
  //               FilteringTextInputFormatter.digitsOnly
  //             ], // O
  //             decoration: InputDecoration(
  //               hintText: 'ex: 8589',
  //               label: const Text("OTP"),
  //               labelStyle: const TextStyle(
  //                 fontFamily: 'MonS',
  //                 fontSize: 13,
  //                 color: primaryColor,
  //               ),
  //               suffixIcon: const Icon(
  //                 Icons.password_outlined,
  //                 color: primaryColor,
  //               ),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20.0),
  //                   borderSide: const BorderSide(color: primaryColor)),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20.0),
  //                   borderSide: const BorderSide(color: primaryColor)),
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 15,
  //         ),
  //         Align(
  //           alignment: Alignment.bottomRight,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: TextButton(
  //               style: ButtonStyle(
  //                 backgroundColor: MaterialStateProperty.all(primaryColor),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);

  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.all(4.0),
  //                 child: Text(
  //                   "Verify",
  //                   style: TextStyle(
  //                     color: kindaBlack,
  //                     fontSize: 15,
  //                     fontFamily: 'MonM',
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _changePassword() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey2,
          child: Column(
            children: [
              Container(
                height: 5,
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
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.symmetric(vertical: 14),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "chnageafTe".tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'MonM',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "changenewnote".tr,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontFamily: 'MonM',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
                child: TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    hintText: '********',
                    label: Text("changenew".tr),
                    labelStyle: const TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 13,
                      color: primaryColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: primaryColor,
                    ),
                    suffixIcon: const Icon(
                      Icons.visibility_off,
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
                      return "Enter New Password";
                    }
                    if (value.length < 6) {
                      return "New Password must be least 6 chars long";
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: '*******',
                    label: Text("changenewcon".tr),
                    labelStyle: const TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 13,
                      color: primaryColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: primaryColor,
                    ),
                    suffixIcon: const Icon(
                      Icons.visibility_off,
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
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () async {
                      String newPass = _newPasswordController.text;
                      String conPass = _confirmPasswordController.text;
                      if (_formKey2.currentState!.validate()) {
                        if (newPass == conPass) {
                          showLoaderDialog(context, 50);
                          await changeUserPassword(context, newPass);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "changepwd".tr,
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 15,
                          fontFamily: 'MonS',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context, int delay) {
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
            child: const Text(
              "Changing your password",
              style: TextStyle(
                  fontSize: 12, color: Colors.black, fontFamily: "MonM"),
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
