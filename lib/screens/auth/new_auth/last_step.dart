import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:group_button/group_button.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/color_contants.dart';
import '../../../widgets/coupons_list.dart';

class OneLastStep extends StatefulWidget {
  String userIII;
  OneLastStep({Key? key, required this.userIII});

  @override
  State<OneLastStep> createState() => _OneLastStepState();
}

class _OneLastStepState extends State<OneLastStep> {
  TextEditingController phoneController = TextEditingController();
  String selectedGen = "";

  Future nerwRegs() async {
    SharedPreferences getData = await SharedPreferences.getInstance();
    String? tok = getData.getString("maintoken");
    var headers = {'Authorization': 'Bearer $tok'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://www.ondeindia.com/api/user/rewreg'));
    request.fields.addAll({
      'userId': widget.userIII,
      'name': phoneController.text,
      'gender': selectedGen
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
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
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "User logged in successfully!",
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
              // phoneNumber: _numberCon.text,
              // usID: decodedMap['data'][0]['id'].toString(),
              ),
        ),
      );
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      EasyLoading.showToast(decodedMap['message']);
      print(response.reasonPhrase);
    }
  }

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
          "One Last Step",
          style: TextStyle(
            fontFamily: 'MonM',
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        actions: [
          Align(
            child: InkWell(
              onTap: () {},
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
                          fontFamily: "PopM",
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
                "Your official name",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'MonM'),
              ),
              const SizedBox(height: 5),
              const Text(
                "Used for insurance claims",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
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
                          Icons.person_outline,
                          color: black,
                          size: 23,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            autofocus: true,
                            controller: phoneController,
                            // keyboardType: TextInputType.number,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.digitsOnly
                            // ],
                            cursorColor: black,
                            decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(
                                  color: black.withOpacity(0.3),
                                  fontSize: 13,
                                  fontFamily: 'MonR',
                                )),
                            onChanged: (val) {
                              // if (_numberCon.text == "") {
                              //   setState(() {
                              //     valll = -1;
                              //   });
                              // } else if (_numberCon.text.length < 10) {
                              //   setState(() {
                              //     valll = -2;
                              //   });
                              // } else {
                              //   setState(() {
                              //     valll = 1;
                              //   });
                              // }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // gender details
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              GroupButton(
                isRadio: true,
                onSelected: (index, isSelected, _) {
                  setState(() {
                    selectedGen = index == 0
                        ? 'Male'
                        : index == 1
                            ? 'Female'
                            : 'Others';
                  });
                },
                // print('$index button is selected'),
                buttons: ["Male", "Female", "Others"],
                options: GroupButtonOptions(
                  selectedShadow: [
                    BoxShadow(
                      color:
                          Color(0xFF009ED9).withOpacity(0.2), //color of shadow
                      spreadRadius: 2, //spread radius
                      blurRadius: 2, // blur radius
                      offset: Offset(2, 2), // changes position of shadow
                      //first paramerter of offset is left-right
                      //second parameter is top to down
                    ),
                  ],
                  selectedTextStyle:
                      TextStyle(fontSize: 14, color: white, fontFamily: 'MonM'),
                  selectedColor: Color(0xFF009ED9),
                  unselectedShadow: const [],
                  unselectedColor: white,
                  unselectedTextStyle: TextStyle(
                    fontSize: 13,
                    fontFamily: 'PopR',
                    color: black,
                  ),
                  selectedBorderColor: white,
                  unselectedBorderColor: black,
                  borderRadius: BorderRadius.circular(10),
                  spacing: 10,
                  runSpacing: 10,
                  groupingType: GroupingType.wrap,
                  direction: Axis.horizontal,
                  buttonHeight: 40,
                  buttonWidth: 90,
                  mainGroupAlignment: MainGroupAlignment.start,
                  crossGroupAlignment: CrossGroupAlignment.start,
                  groupRunAlignment: GroupRunAlignment.start,
                  textAlign: TextAlign.center,
                  textPadding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  elevation: 0,
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
              //         //
              //       },
              //       child: const Text(
              //         'Continue',
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
                        if (selectedGen == "") {
                          EasyLoading.showToast("Please selected your gender");
                        } else if (phoneController.text == "") {
                          EasyLoading.showToast("Please enter your name");
                        } else {
                          EasyLoading.show();
                          nerwRegs();
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => OneLastStep(),
                        //   ),
                        // );
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
                          color: selectedGen == "" || phoneController.text == ""
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
}
