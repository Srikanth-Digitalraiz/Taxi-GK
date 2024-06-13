import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/apiconstants.dart';
import '../../global/admin_id.dart';
import '../../widgets/loder_dialg.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';

class DriverChat extends StatefulWidget {
  String driverName, rieID, phone, driID;
  DriverChat(
      {Key? key,
      required this.driverName,
      required this.rieID,
      required this.phone,
      required this.driID})
      : super(key: key);

  @override
  State<DriverChat> createState() => _DriverChatState();
}

class _DriverChatState extends State<DriverChat> {
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      driverChattingSection(context, "");
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  final TextEditingController _messageController = TextEditingController();

  List chats = [];

  Future<List> driverChattingSection(context, comment) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? requID = _token.getString("reqID");
    String reID = widget.rieID;
    String apiUrl = driverChatAPI;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        'admin_id': adminId,
        "request_id": reID,
        "provider_id": widget.driID,
        'message': comment ?? ""
      },
    );
    if (response.statusCode == 200) {
      _messageController.clear();

      setState(() {
        chats = jsonDecode(response.body)['data'];
      });

      return jsonDecode(response.body)['data'];
    } else if (response.statusCode == 400) {
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
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
        ),
      );
      // Fluttertoast.showToast(msg: response.body.toString());
    } else if (response.statusCode == 403) {
      // Fluttertoast.showToast(msg: response.body.toString());
    }
    throw 'Exception';
  }

  void launchDialer({
    @required int? phone,
  }) async {
    if (await canLaunch("tel: $phone")) {
      await launch("tel: $phone");
    } else {
      throw 'Could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chatting with",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'MonM',
                fontSize: 14,
              ),
            ),
            Text(
              widget.driverName,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'MonS',
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  color: whiteColor,
                ),
                child: chats.isEmpty
                    ? Center(
                        child: Text(
                          "No Conversation yet!",
                          style: TextStyle(
                              color: secondaryColor.withOpacity(0.4),
                              fontFamily: "MonS",
                              fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          return chats[index]['message'] == ""
                              ? SizedBox(
                                  height: 0,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        chats[index]['type'] == "up"
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      chats[index]['type'] == "pu"
                                          ? SizedBox(
                                              width: 6,
                                            )
                                          : Container(),
                                      chats[index]['type'] == "pu"
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: chats[index]['type'] ==
                                                          "pu"
                                                      ? Colors.amber
                                                      : secondaryColor),
                                              child: Icon(Icons.person,
                                                  size: 12, color: whiteColor),
                                            )
                                          : Container(),
                                      chats[index]['type'] == "pu"
                                          ? SizedBox(
                                              width: 6,
                                            )
                                          : Container(),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        decoration: BoxDecoration(
                                          borderRadius: chats[index]['type'] ==
                                                  "up"
                                              ? BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                  bottomLeft:
                                                      Radius.circular(30))
                                              : BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                  bottomRight:
                                                      Radius.circular(30)),
                                          color: chats[index]['type'] == "pu"
                                              ? Colors.amber.withOpacity(0.3)
                                              : secondaryColor.withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0,
                                                vertical: 14.0),
                                            child: Flexible(
                                              child: Text(
                                                  chats[index]['message'],
                                                  maxLines: 10,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.visible),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      chats[index]['type'] == "up"
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: secondaryColor),
                                              child: Icon(Icons.person,
                                                  size: 12, color: whiteColor),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                        },
                      )),
          ),
          SizedBox(height: 10),
          Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //color of shadow
                  spreadRadius: 1, //spread radius
                  blurRadius: 1, // blur radius
                  offset: Offset(2, 2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //color of shadow
                  spreadRadius: 1, //spread radius
                  blurRadius: 1, // blur radius
                  offset: Offset(-2, -2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
                //you can set more BoxShadow() here
              ],
              color: whiteColor,
            ),
            child: Row(
              children: [
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    int ph = int.parse(widget.phone.toString());
                    launchDialer(phone: ph);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(2, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(-2, -2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Icon(
                      Icons.call,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor.withOpacity(0.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        controller: _messageController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Message..."),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    String _message = _messageController.text;
                    if (_message == "" || _message == null) {
                      Fluttertoast.showToast(
                          msg: "Plesase write a message to send...");
                    } else {
                      showLoaderDialog(context, "Sending...", 20);
                      await driverChattingSection(context, _message);
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(2, 2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(-2, -2), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Icon(
                      Icons.send,
                      color: whiteColor,
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
