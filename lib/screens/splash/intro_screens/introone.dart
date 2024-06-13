import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/auth/loginscreen.dart';
import 'package:ondeindia/screens/home/home_screen.dart';

import '../../auth/new_auth/login_new.dart';
import '../../auth/new_auth/new_auth_selected.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentIndex = 0;
  PageController? _pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          Container(
            child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentIndex = index;
                  setState(() {});
                },
                children: [
                  //First Intro Screen
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          // Center(
                          //   child: Image.asset(
                          //     'assets/images/newlogoss.png',
                          //     width: MediaQuery.of(context).size.width / 1.9,
                          //     // fit: BoxFit.cover,
                          //   ),
                          // ),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                            child: Lottie.network(
                                'https://assets2.lottiefiles.com/packages/lf20_calza6zj.json',
                                height: 150),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Greetings",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonB',
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              "Welcome User \n\nWe welcome you to All new Pradeep Cabs Taxi App and hope we will be able to provide the best service for your requests",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonM',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              "What we offer",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonB',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- Best Drivers",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- Better Prices",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- Flexible Options",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- Many more.",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
                  //Second Intro Screen
                  Center(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),

                            SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: Lottie.network(
                                  'https://assets8.lottiefiles.com/packages/lf20_pv3vjlpk.json',
                                  height: 150),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                "Your Privacy is our priority",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MonB',
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Text(
                                "We keep all the data what is collect to ourselves we never share and we will never share you data to anyone without your approval...",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MonR',
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(height: 25),

                            Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Text(
                                "What We do?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MonB',
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10),
                              child: Text(
                                "-- We never store you Private data unless it is important for app's functionality",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MonR',
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "*We assuer you that your data is solely used for drivers to reach your location on time with no delays",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'MonM',
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 70)
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Material(
                            //     elevation: 39,
                            //     color: Colors.transparent,
                            //     child: Container(
                            //       width: MediaQuery.of(context).size.width,
                            //       decoration: BoxDecoration(
                            //         color: whiteColor,
                            //         borderRadius: const BorderRadius.only(
                            //           topLeft: Radius.circular(40),
                            //           topRight: Radius.circular(40),
                            //         ),
                            //       ),
                            //       height: MediaQuery.of(context).size.height / 1.68,
                            //       child: Column(
                            //         children: const [

                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Third Intro Screen
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),

                          Center(
                            child: Lottie.network(
                                'https://assets10.lottiefiles.com/private_files/lf30_7mp95dwr.json',
                                height: 150),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Time is Valuable",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonB',
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              "So, That is the reason you will be picked up from your pickup location with in 10 mins because we value time more than anything in this era",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              "What you get?",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonB',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- OnTime PickUp and Drop",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- No explaning routes to driver, Driver will reach your pickup point for sure.",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- Safest journey expirence",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            child: Text(
                              "-- Affordable rides...",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MonR',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),

                          SizedBox(height: 70),
                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child: Material(
                          //     elevation: 39,
                          //     color: Colors.transparent,
                          //     child: Container(
                          //       width: MediaQuery.of(context).size.width,
                          //       decoration: BoxDecoration(
                          //         color: whiteColor,
                          //         borderRadius: const BorderRadius.only(
                          //           topLeft: Radius.circular(40),
                          //           topRight: Radius.circular(40),
                          //         ),
                          //       ),
                          //       height: MediaQuery.of(context).size.height / 1.68,
                          //       child: Column(
                          //         children: const [

                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  //Forth Screen
                  Container(
                    color: whiteColor,
                    child: Column(children: [
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                                margin: EdgeInsets.only(left: 135, bottom: 50),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: whiteColor
                                    // Color(0xFFf5f7f9),
                                    ),
                                child: Align(
                                  child: Image.asset(
                                    'assets/images/newlogoss.png',
                                    height: 95,
                                    width: 95,
                                  ),
                                )),
                          )
                        ],
                      ),
                      Text(
                        "Pradeep Cabs",
                        style: TextStyle(
                          color: secondaryColor,
                          fontFamily: 'MonS',
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Explore new way for cabbing 😀",
                        style: TextStyle(
                          color: secondaryColor.withOpacity(0.5),
                          fontFamily: 'MonM',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ]),
                  ),
                ]),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: 25),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15, top: 20),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < 4; i++)
                                if (i == _currentIndex) ...[
                                  circleBar(true)
                                ] else
                                  circleBar(false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: whiteColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: _currentIndex < 2
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.4,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent)),
                          onPressed: () {
                            if (_currentIndex < 3) {
                              _pageController!.animateToPage(_currentIndex + 1,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            } else {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          NewAuthSelection()));
                              // Get.to(
                              //   () => LoginScreen(
                              //     a: widget.analytics,
                              //     o: widget.observer,
                              //   ),
                              // );
                            }
                          },
                          child: Container(
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: _currentIndex < 3
                                    ? Colors.transparent
                                    : primaryColor.withOpacity(0.7)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: _currentIndex < 3
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentIndex < 3 ? 'Next' : 'Get Started',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily:
                                          _currentIndex < 3 ? 'MonB' : 'MonR',
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.justify,
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
                      ),
                    ),
                    // Expanded(
                    //   child:
                    // ),
                    _currentIndex < 3
                        ? Container(
                            width: MediaQuery.of(context).size.width / 3.4,
                            height: 50,
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            NewAuthSelection()));
                                // Get.to(
                                //   () => LoginScreen(
                                //     a: widget.analytics,
                                //     o: widget.observer,
                                //   ),
                                // );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Skip',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: secondaryColor.withOpacity(0.3),
                                      letterSpacing: 2.0,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child:
          // ),
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child:
          // )
        ],
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 50),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 5 : 5,
      width: isActive ? 23 : 10,
      decoration: BoxDecoration(
          color: isActive ? secondaryColor : secondaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: _currentIndex);
    _pageController!.addListener(() {});
  }
}
