import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/testinggggggg.dart';
import 'login_new.dart';

class NewAuthSelection extends StatefulWidget {
  const NewAuthSelection({Key? key}) : super(key: key);

  @override
  State<NewAuthSelection> createState() => _NewAuthSelectionState();
}

class _NewAuthSelectionState extends State<NewAuthSelection> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.phone,
      Permission.sms,
    ].request();

    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        // Handle the case where the user denied the permission
        print('Permission ${permission.toString()} was denied');
      }
    });
  }

  Future<void> _openURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: ExactAssetImage("assets/images/logggg_i.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/newlogssh.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                // child: Stack(
                //   children: [
                //     SafeArea(
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Image.asset(
                //           'assets/images/newlogoss.png',
                //           width: 100,
                //           height: 100,
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       bottom: -10,
                //       child: Align(
                //         alignment: Alignment.bottomCenter,
                //         child: Transform.scale(
                //           scale: 1.05,
                //           child: Image.asset(
                //             'assets/images/newasse.png',
                //             width: MediaQuery.of(context).size.width,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
            Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Explore the new ways of a safety ride with Pradeep Cabs",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MonM',
                            fontSize: 18,
                            letterSpacing: 0.8),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // MyApp()
                                  NewLoginScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF009ED9),
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
                                offset: Offset(
                                    -2, -2), // changes position of shadow
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
                                'GET STARTED',
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'By continuing you agree to the ',
                          style: TextStyle(
                            fontFamily: 'MonR',
                            letterSpacing: 1,

                            // fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(
                              text: 'T&C',
                              style: TextStyle(
                                fontFamily: 'MonR',
                                decoration: TextDecoration.underline,
                                // fontStyle: FontStyle.italic,
                                fontSize: 10,
                                letterSpacing: 1,
                                color: Color(0xFF009ED9),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle T&C tap
                                  _openURL(
                                      "https://gkcabs.com/general-terms-and-conditions.html");
                                },
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                fontFamily: 'MonR',
                                letterSpacing: 1,

                                // fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 10,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontFamily: 'MonR',
                                decoration: TextDecoration.underline,
                                // fontStyle: FontStyle.italic,
                                fontSize: 10,
                                letterSpacing: 1,
                                color: Color(0xFF009ED9),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle T&C tap
                                  _openURL(
                                      "https://gkcabs.com/privacy-policy.html");
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50)
                  ],
                ),
              ),
              // color: Colors.black,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
