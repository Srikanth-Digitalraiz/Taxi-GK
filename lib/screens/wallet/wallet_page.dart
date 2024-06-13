import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

import '../../add_card/add_card.dart';
import '../../constants/apiconstants.dart';
import '../../global/couponcode.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/out/out.dart';
import '../../global/rental_fare_plan.dart';
import '../../global/ride/ride_details.dart';
import '../../global/wallet.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';
import '../home/home_screen.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<List> addMoney(context, payID) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? userID = _token.getString('personid');
    String apiUrl = walletAddMoney;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "pay_id": payID,
      },
    );
    // print(userId);
    if (response.statusCode == 200) {
      setState(() {
        coupon = "";
        serviceID = "";
        serviceTime = "";
        serviceName = "";
        fareType = '15';
        out = false;
        selectedOutPlan = 0;
        selectedOutName = 'One Way';
        paymentMode = 'CASH';

        fareType = "15";
        rentalFarePlan = "";
        dropadd = "";
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      Fluttertoast.showToast(msg: "Amount Added to yor wallet");
      return jsonDecode(response.body);
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

//Add Money Section

  Razorpay? _razorpay;

  @override
  void dispose() {
    super.dispose();
    _razorpay!.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_6E0E67ez6ImhNV',
      'amount': 100000,
      'name': 'OndeIndia Org.',
      'description': 'Wallet Recharge',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '6789098765', 'email': 'help@ondeindia.com'},
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Success Response: $response');
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId.toString(),
    //     toastLength: Toast.LENGTH_SHORT);

    String paymentID = response.paymentId.toString();

    await addMoney(context, paymentID);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  var fromDate = '2019-10-22 00:00:00.000';
  var toDate = '2019-10-25 00:00:00.000';

  String _selectedDate = '';
  String _dateCount = '';
  String _rangeFrom = '';
  String _rangeTo = '';
  String _rangeCount = '';

  var mainStart = "2019-10-22 00:00:00.000";
  var mainEnd = "2019-10-22 00:00:00.000";

  void dates() async {
    var parsedFromDate = DateTime.parse(mainStart.toString());
    var parsedToDate = DateTime.parse(mainEnd.toString());

    String convertedFromDate =
        new DateFormat("yyyy-MM-dd").format(parsedFromDate);
    String convertedToDate = new DateFormat("yyyy-MM-dd").format(parsedToDate);

    setState(() {
      fromDate = convertedFromDate;
      toDate = convertedToDate;
    });
  }

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _rangeFrom = args.value.startDate.toString();
        _rangeTo = args.value.endDate.toString();

        mainStart = _rangeFrom;
        mainEnd = _rangeTo;

        // _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        //     // ignore: lines_longer_than_80_chars
        //     ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  Future getWalletBalance(context) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? userID = _token.getString('personid');
    String apiUrl = walletBalance;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
    );
    print(
        "----------------Wallet Balance Data--------   ${response.body}    ----------------Wallet Balance Data--------");
    if (response.statusCode == 200) {
      int _balance = jsonDecode(response.body)['WalletBalance'];
      setState(() {
        walletBalanceAmount =
            jsonDecode(response.body)['WalletBalance'] == null ? 0 : _balance;
      });
      // Fluttertoast.showToast(msg: _balance.toString());
      return jsonDecode(response.body);
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

  Future<List> getWalletReport(context, fromdate, todate) async {
    getWalletBalance(context);
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    String? userID = _token.getString('personid');
    String apiUrl = walletHistory;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
      body: {
        "from_date": fromdate.toString(),
        "end_date": todate.toString(),
      },
    );
    // print(userId);
    if (response.statusCode == 200) {
      print("Its a hit");
      return jsonDecode(response.body)['Reports'];
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

  String _walletBalance = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: kindaBlack),
        title: Text(
          "wallet".tr,
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 13,
            color: kindaBlack,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RippleAnimation(
            delay: const Duration(milliseconds: 3000),
            repeat: true,
            color: kindaBlack.withOpacity(0.2),
            minRadius: 50,
            ripplesCount: 3,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFF43D194),
                            Color(0xFF4ECBA3),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                "wallbal".tr,
                                style: TextStyle(
                                  fontFamily: 'MonR',
                                  fontSize: 16,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  "₹ " + walletBalanceAmount.toString() + "/-",
                                  style: TextStyle(
                                    fontFamily: 'MonS',
                                    fontSize: 20,
                                    color: whiteColor,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Divider(
          //   color: kindaBlack.withOpacity(0.4),
          // ),
          // SizedBox(
          //   height: 2,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 18.0, bottom: 10.0),
          //   child: Text(
          //     "addmon".tr,
          //     style: TextStyle(
          //       fontFamily: 'MonS',
          //       fontSize: 16,
          //       color: kindaBlack,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          //   child: InkWell(
          //     onTap: () {
          //       openCheckout();
          //     },
          //     child: Container(
          //       height: 60,
          //       width: MediaQuery.of(context).size.width,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(7),
          //         color: Color(0xFFF8F8F8),
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             Container(
          //               height: 40,
          //               width: 40,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(40),
          //                 image: DecorationImage(
          //                   image: ExactAssetImage(
          //                     'assets/images/razorpay.png',
          //                   ),
          //                   fit: BoxFit.fill,
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 14,
          //             ),
          //             Text(
          //               "razor".tr,
          //               style: TextStyle(
          //                 fontFamily: 'MonM',
          //                 fontSize: 14,
          //                 color: kindaBlack,
          //               ),
          //             ),
          //             Spacer(),
          //             ImageIcon(
          //               AssetImage(
          //                 'assets/icons/next.png',
          //               ),
          //             ),
          //             SizedBox(
          //               width: 10,
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), //color of shadow
                    spreadRadius: 3, //spread radius
                    blurRadius: 2, // blur radius
                    offset: Offset(2, 0), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      height: 6,
                      width: MediaQuery.of(context).size.width / 8.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "wallethis".tr,
                            style: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 16,
                              color: kindaBlack,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            var results = await showCalendarDatePicker2Dialog(
                              context: context,
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType:
                                          CalendarDatePicker2Type.range),
                              dialogSize: const Size(325, 400),
                              value: [DateTime.now()],
                              borderRadius: BorderRadius.circular(15),
                            );

                            if (results != null && results.length == 2) {
                              // Extract the first and second dates from the results list
                              DateTime firstDate = results[0]!;
                              DateTime secondDate = results[1]!;

                              // Convert the dates to strings
                              var firstDateString =
                                  firstDate.toString().split(" ");
                              var secondDateString =
                                  secondDate.toString().split(" ");

                              // Print or use the strings as needed
                              print('First Date: ${firstDateString[0]}');
                              print('Second Date: ${secondDateString[0]}');

                              setState(() {
                                fromDate = firstDateString[0];
                                toDate = secondDateString[0];
                              });

                              // ignore: use_build_context_synchronously
                              await getWalletReport(context, firstDateString[0],
                                  secondDateString[0]);
                            } else {
                              // Handle case where user cancels or no dates selected
                              print('No dates selected');
                            }
                            // CalendarDatePicker2(
                            //   config: CalendarDatePicker2Config(
                            //     calendarType: CalendarDatePicker2Type.range,
                            //   ),
                            //   value: [DateTime.now()],
                            //   onValueChanged: (dates) => data = dates,
                            // );
                            print(results);
                            // var results = await showCalendarDatePicker2Dialog(
                            //   context: context,
                            //   config:
                            //       Calender(),
                            //   dialogSize: const Size(325, 400),
                            //   value: [DateTime.now()],
                            //   borderRadius: BorderRadius.circular(15),
                            // );
                            // print(results)
                            // showAlertDialog(BuildContext context) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         contentPadding: EdgeInsets.zero,
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius: BorderRadius.vertical(
                            //             top: Radius.circular(20),
                            //           ),
                            //         ),
                            //         content: SingleChildScrollView(
                            //           child: showCalendarSelection(),
                            //         ),
                            //       );
                            //     },
                            //   );
                            // }
                            // showModalBottomSheet(
                            //     backgroundColor: Colors.transparent,
                            //     context: context,
                            //     isScrollControlled: true,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.vertical(
                            //         top: Radius.circular(20),
                            //       ),
                            //     ),
                            //     builder: (builder) {
                            //       return showCalendarSelection();
                            //     });
                          },
                          icon: Icon(
                            Icons.sort_sharp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FutureBuilder(
                  //     future: getWalletReport(context, "", ""),
                  //     builder: (context, AsyncSnapshot<List> snapshot) {
                  //       return ListView.builder(
                  //         itemCount: 40,
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         itemBuilder: ((context, index) {
                  //           return Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 10.0, vertical: 5),
                  //             child: Container(
                  //               height: 70,
                  //               width: MediaQuery.of(context).size.width,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 color: whiteColor,
                  //               ),
                  //               child: Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Row(
                  //                       children: [
                  //                         Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           children: [
                  //                             Text(
                  //                               "WED",
                  //                               style: TextStyle(
                  //                                 fontFamily: 'MonM',
                  //                                 fontSize: 12,
                  //                                 color: Colors.grey,
                  //                               ),
                  //                             ),
                  //                             SizedBox(
                  //                               height: 3,
                  //                             ),
                  //                             Text(
                  //                               "03 Aug",
                  //                               style: TextStyle(
                  //                                 fontFamily: 'MonB',
                  //                                 fontSize: 15,
                  //                                 color: Colors.black,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                         SizedBox(
                  //                           width: 20,
                  //                         ),
                  //                         Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.center,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Text(
                  //                               "Wallet Credit",
                  //                               style: TextStyle(
                  //                                 fontFamily: 'MonB',
                  //                                 fontSize: 15,
                  //                                 color: Colors.black,
                  //                               ),
                  //                             ),
                  //                             SizedBox(
                  //                               height: 3,
                  //                             ),
                  //                             Text(
                  //                               "Amount added from Google Pay",
                  //                               style: TextStyle(
                  //                                 fontFamily: 'MonR',
                  //                                 fontSize: 10,
                  //                                 color: Colors.grey,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                         SizedBox(
                  //                           width: 10,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     "+ ₹500",
                  //                     style: TextStyle(
                  //                       fontFamily: 'MonS',
                  //                       fontSize: 15,
                  //                       color: Colors.green,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         }),
                  //       );
                  //     })
                  _walletTransHistory()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _walletTransHistory() {
    return fromDate == '2019-10-22 00:00:00.000'
        ? FutureBuilder(
            future: getWalletReport(context, "", ""),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Lottie.asset('assets/animation/loading.json'),
                  ),
                );
              }
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Lottie.asset('assets/animation/empty.json'),
                      ),
                      // SizedBox(height: 10),
                      Text(
                        "nowallet".tr,
                        style: TextStyle(
                          color: kindaBlack,
                          fontSize: 12,
                          fontFamily: 'MonR',
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var date =
                      snapshot.data![index]['created_at'].toString().split(" ");

                  var date1 = Jiffy(date[0]).yMMMMd;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: snapshot.data![index]['type'] == "Credit"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    snapshot.data![index]['type'] == "Credit"
                                        ? 'assets/images/credit.png'
                                        : 'assets/images/debit.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index]['comment'].toString(),
                                  style: TextStyle(
                                    color: kindaBlack,
                                    fontSize: 15,
                                    fontFamily: 'MonM',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  date1.toString(),
                                  style: TextStyle(
                                    color: kindaBlack,
                                    fontSize: 11,
                                    fontFamily: 'MonR',
                                  ),
                                ),
                              ],
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    snapshot.data![index]['type'] == "Credit"
                                        ? Text(
                                            " + ",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontFamily: 'MonB',
                                            ),
                                          )
                                        : Text(
                                            " - ",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontFamily: 'MonB',
                                            ),
                                          ),
                                    Text(
                                      "₹" +
                                          snapshot.data![index]['amount']
                                              .toString(),
                                      style: TextStyle(
                                        color: snapshot.data![index]['type'] ==
                                                "Credit"
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 15,
                                        fontFamily: 'MonB',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  date[1].toString(),
                                  style: TextStyle(
                                    color: kindaBlack,
                                    fontSize: 11,
                                    fontFamily: 'MonR',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            })
        : FutureBuilder(
            future: getWalletReport(context, fromDate, toDate),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Lottie.asset('assets/animation/loading.json'),
                  ),
                );
              }
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Lottie.asset('assets/animation/empty.json'),
                      ),
                      // SizedBox(height: 10),
                      Text(
                        "nowallet".tr,
                        style: TextStyle(
                          color: kindaBlack,
                          fontSize: 12,
                          fontFamily: 'MonR',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var date =
                      snapshot.data![index]['created_at'].toString().split(" ");

                  var date1 = Jiffy(date[0]).yMMMMd;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: snapshot.data![index]['type'] == "Credit"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    snapshot.data![index]['type'] == "Credit"
                                        ? 'assets/images/credit.png'
                                        : 'assets/images/debit.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index]['comment'].toString(),
                                  style: TextStyle(
                                    color: kindaBlack,
                                    fontSize: 15,
                                    fontFamily: 'MonM',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  date1.toString(),
                                  style: TextStyle(
                                    color: kindaBlack,
                                    fontSize: 11,
                                    fontFamily: 'MonR',
                                  ),
                                ),
                              ],
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    snapshot.data![index]['type'] == "Credit"
                                        ? Text(
                                            " + ",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontFamily: 'MonB',
                                            ),
                                          )
                                        : Text(
                                            " - ",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontFamily: 'MonB',
                                            ),
                                          ),
                                    Text(
                                      "₹" +
                                          snapshot.data![index]['amount']
                                              .toString(),
                                      style: TextStyle(
                                        color: snapshot.data![index]['type'] ==
                                                "Credit"
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 15,
                                        fontFamily: 'MonB',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  date[1].toString(),
                                  style: TextStyle(
                                    color: kindaBlack,
                                    fontSize: 11,
                                    fontFamily: 'MonR',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            });
  }

  showCalendarSelection() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.9,
      width: MediaQuery.of(context).size.width,
      color: whiteColor,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SfDateRangePicker(
                showActionButtons: true,
                view: DateRangePickerView.month,
                enablePastDates: true,
                onSubmit: (selectedDates) {
                  dates();
                  getWalletReport(context, fromDate, toDate);
                  // getTripsList(context, fromDate, toDate);
                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                viewSpacing: 10,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.extendableRange,
                initialSelectedDate: DateTime.now(),
              ),
            ),
            // child: ScrollableCleanCalendar(
            //   calendarController: calendarController,
            //   layout: Layout.BEAUTY,
            //   calendarCrossAxisSpacing: 0,
            // ),
          ),
        ],
      ),
    );
  }
}

/*



 */