import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/auth/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/apiconstants.dart';
import '../constants/color_contants.dart';
import '../screens/auth/new_auth/login_new.dart';
import '../screens/auth/new_auth/new_auth_selected.dart';

class RefundPolicy extends StatefulWidget {
  RefundPolicy({Key? key}) : super(key: key);

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRefundPolicy(context);
  }

  String err = "";

  Future getRefundPolicy(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String apiUrl = refundpolicy;
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
    );
    // print(userId);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['RefundPolicy'];
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
      String erTx = jsonDecode(response.body)['error'].toString();

      setState(() {
        err = erTx;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: kindaBlack),
        title: Text(
          "refund".tr,
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 13,
            color: kindaBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            err == ""
                ? FutureBuilder(
                    future: getRefundPolicy(context),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: kindaBlack,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        );
                      }
                      return err == ""
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  snapshot.data['image'] == null
                                      ? SizedBox()
                                      : Image.network(snapshot.data['image']),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Html(
                                    data: snapshot.data['en_description'],
                                  ),
                                ],
                              ),
                            )
                          : Center(child: Text(err));
                    })
                : Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.4),
                    child: Center(
                      child: Text(
                        err,
                        style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 13,
                          color: kindaBlack,
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
