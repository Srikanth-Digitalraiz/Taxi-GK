import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/splash/splashscreen.dart';
import 'package:ondeindia/widgets/coupons_list.dart';

class MyApp2 extends StatefulWidget {
  @override
  _MyApp2State createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  @override
  void initState() {
    super.initState();
    checkForUpdatess();
  }

  Future<void> checkForUpdatess() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          update();
        } else {
          // Navigate to the splash screen if no update is available
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ));
        }
      });
    }).catchError((e) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ));
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.performImmediateUpdate();
    InAppUpdate.performImmediateUpdate().then((_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ));
    }).catchError((e) {
      print(e.toString());
    });
  }

  // void navigateToSplashScreen() {
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => SplashScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SplashScreen()),
            );
          },
          child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80), color: whiteColor),
              child: Image.asset(
                'assets/images/newlogoss.png',
                height: 180,
                width: 180,
              )),
        ),
      ),
    );
  }
}
