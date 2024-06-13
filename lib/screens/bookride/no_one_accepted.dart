import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/bookride/bookride.dart';
import 'package:ondeindia/screens/home/home_screen.dart';

import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/rental_fare_plan.dart';

class NoOneAccept extends StatefulWidget {
  final String serviceID, serviceName, fT, fareP;
  NoOneAccept(
      {Key? key,
      required this.serviceID,
      required this.serviceName,
      required this.fareP,
      required this.fT})
      : super(key: key);

  @override
  State<NoOneAccept> createState() => _NoOneAcceptState();
}

class _NoOneAcceptState extends State<NoOneAccept> {
  screenhome() {
    setState(() {
      fareType = "15";
      rentalFarePlan = "";
      dropadd = "";
    });
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return screenhome();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_one_accepted.png',
                  height: 160, width: 160),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  "Seems like all our partners are busy at the moment, Please retry or Try after sometime",
                  style: TextStyle(
                    color: secondaryColor.withOpacity(0.5),
                    fontFamily: "MonM",
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 25,
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
                  setState(() {
                    fareType = widget.fT;
                    rentalFarePlan = widget.fareP;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookRideSection(
                        serviceID: widget.serviceID,
                        serviceName: widget.serviceName,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Retry',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryColor,
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
                height: 4,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),

                      // side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HomeScreen(),
                  //   ),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    'Try Later',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryColor.withOpacity(0.3),
                      letterSpacing: 1.0,
                      decoration: TextDecoration.underline,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
