import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondeindia/screens/home/home_screen.dart';

import '../../constants/color_contants.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/rental_fare_plan.dart';

class NoDrivers extends StatefulWidget {
  String fT;
  NoDrivers({Key? key, required this.fT}) : super(key: key);

  @override
  State<NoDrivers> createState() => _NoDriversState();
}

class _NoDriversState extends State<NoDrivers> {
  screenhome() {
    setState(() {
      fareType = "15";
      rentalFarePlan = "";
      dropadd = "";
    });
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => HomeScreen(),
        ),
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
              Image.asset('assets/images/no_drivers.png',
                  height: 160, width: 160),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  "Oops! Sorry No partners are available at the moment. Please Try again later we will notify you once partners are available. \n Thank you for your patience",
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
                    fareType = "15";
                    rentalFarePlan = "";
                    dropadd = "";
                  });
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        fareType = "15";
                        rentalFarePlan = "";
                        dropadd = "";
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                          (route) => false);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Try Again Later',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
