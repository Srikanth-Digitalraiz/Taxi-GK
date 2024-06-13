import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/admin_id.dart';
import 'package:ondeindia/global/data/user_data.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketsSection extends StatefulWidget {
  TicketsSection({Key? key}) : super(key: key);

  @override
  State<TicketsSection> createState() => _TicketsSectionState();
}

class _TicketsSectionState extends State<TicketsSection> {
  TextEditingController descriptionCon = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTickets();
  }

  List tickList = [];

  Future getTickets() async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    var headers = {'Authorization': 'Bearer $userToken'};
    var request = http.Request(
        'POST', Uri.parse('https://ondeindia.com/api/user/gettickets'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      setState(() {
        tickList = decodedMap['data'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  // Initial Selected Value
  String dropdownvalue = "Low";

  // List of items in our dropdown menu
  var items = [
    "Low",
    "Medium",
    "High",
  ];

  Future addticket() async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    var headers = {'Authorization': 'Bearer $userToken'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ondeindia.com/api/user/storetickets'));
    request.fields.addAll({
      'description': descriptionCon.text,
      'complaint_type': dropdownvalue,
      "admin_id": adminId
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    EasyLoading.showToast(response.statusCode.toString());
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      getTickets();
      setState(() {
        dropdownvalue = "Low";
      });
      descriptionCon.clear();
      EasyLoading.showInfo("Ticket raised successfully!");
      Navigator.pop(context);
    } else {
      EasyLoading.dismiss();
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: white,
          title: Text(
            "Tickets",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'PopM',
              fontSize: 14,
            ),
          ),
          titleSpacing: 0),
      body: tickList.isEmpty
          ? Center(child: Text("No Tickets Raised yet!"))
          : ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(1, 0), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second parameter is top to down
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1), //color of shadow
                          spreadRadius: 1, //spread radius
                          blurRadius: 1, // blur radius
                          offset: Offset(0, -1), // changes position of shadow
                          //first paramerter of offset is left-right
                          //second p9rameter is top to down
                        ),
                        //you can set more BoxShadow() here
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 150,
                          width: 8,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12))),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tickList[index]['created_at'],
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11,
                                                fontFamily: 'PopR'),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            tickList[index]['description'],
                                            maxLines: 4,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'PopM'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          color: Colors.green,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.safety_check,
                                              color: white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              tickList[index]['status'],
                                              style: TextStyle(color: white),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          color: Colors.amber,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.priority_high,
                                              color: white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              tickList[index]['complaint_type'],
                                              style: TextStyle(color: white),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              // separatorBuilder: (context, index) {
              //   return Divider();
              // },
              itemCount: tickList.length),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          backgroundColor: secondaryColor,
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      height: 510,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                height: 5,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    color: secondaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Raise a ticket",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'MonS',
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Please select you tickets priority",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'MonR',
                                  fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.blueGrey.withOpacity(0.4))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    // Initial Value
                                    value: dropdownvalue,

                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: items.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                            color: secondaryColor,
                                            fontFamily: 'MonM',
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: descriptionCon, maxLines: 10,
                              // inputFormatters: <TextInputFormatter>[
                              //   FilteringTextInputFormatter.digitsOnly
                              // ], // O
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: 'Description',
                                label: const Text("Descrition"),
                                labelStyle: const TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 13,
                                  color: secondaryColor,
                                ),
                                // suffixIcon: const Icon(
                                //   Icons.password_outlined,
                                //   color: primaryColor,
                                // ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: secondaryColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: secondaryColor)),
                              ),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "Please enter OTP";
                              //   }
                              //   if (value.length < 6) {
                              //     return "Please enter valid OTP";
                              //   }
                              // },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        secondaryColor),
                                  ),
                                  onPressed: () async {
                                    if (descriptionCon.text == "") {
                                      EasyLoading.showToast(
                                          "Please enter Description");
                                    } else {
                                      EasyLoading.show();
                                      addticket();
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      "Raise Ticket",
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
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
