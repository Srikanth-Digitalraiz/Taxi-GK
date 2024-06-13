import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/bookride/bookride.dart';
import 'package:ondeindia/screens/driver_details/ridecompleted.dart';
import 'package:ondeindia/screens/home/home_screen.dart';

class RideCompletedMock extends StatefulWidget {
  final String serviceID;
  RideCompletedMock({Key? key, required this.serviceID}) : super(key: key);

  @override
  State<RideCompletedMock> createState() => _RideCompletedMockState();
}

class _RideCompletedMockState extends State<RideCompletedMock> {
  screenhome() {
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
                  "Ride Completed. Please complete the ride to have a look at price break up.",
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => RideCompleted(
                        rideID: widget.serviceID,
                      ),
                    ),
                    (route) => false,
                  );
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => RideCompleted(
                  //       rideID: widget.serviceID,
                  //     ),
                  //   ),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ride Completed',
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
              // SizedBox(
              //   height: 4,
              // ),
              // TextButton(
              //   style: ButtonStyle(
              //     backgroundColor:
              //         MaterialStateProperty.all(Colors.transparent),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(80.0),

              //         // side: BorderSide(color: Colors.red),
              //       ),
              //     ),
              //   ),
              //   onPressed: () async {
              //     Navigator.pushAndRemoveUntil(
              //         context,
              //         CupertinoPageRoute(builder: (context) => HomeScreen()),
              //         (route) => false);
              //     // Navigator.pushReplacement(context,
              //     //     MaterialPageRoute(builder: (context) => HomeScreen()));
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(2.0),
              //     child: Text(
              //       'Try Later',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         color: secondaryColor.withOpacity(0.3),
              //         letterSpacing: 1.0,
              //         decoration: TextDecoration.underline,
              //         fontSize: 10,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
