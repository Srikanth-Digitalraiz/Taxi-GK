import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/poly_line.dart';
import 'package:ondeindia/screens/ongoing/ongoing.dart';
import 'package:ondeindia/screens/settings/settings.dart';
import 'package:ondeindia/screens/wallet/wallet_page.dart';
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:ondeindia/widgets/menu_inner_screens.dart';
import 'package:ondeindia/screens/auth/loginscreen.dart';
import 'package:ondeindia/screens/profile/profile.dart';
import 'package:ondeindia/widgets/mulmar.dart';
import 'package:ondeindia/widgets/support.dart';
import 'package:ondeindia/widgets/tickets_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../legal section/aboutus.dart';
import '../repositories/tripsrepo.dart';
import '../screens/home/widget/payment_selection.dart';
import '../screens/notifications/notification.dart';
import '../screens/review/reviews.dart';

String userNamesssz = '';
String userEmailsssz = '';
String userMobilesssz = '';
String useraltsssz = '';
// import 'coupons_list.dart';

class MenuScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final zoomDrawerController;
  // ignore: use_key_in_widget_constructors
  const MenuScreen(this.zoomDrawerController);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    data();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Need a ride? ',
        text:
            "Look no further than this awesome taxi booking app! With a few taps, you can easily hail a ride, track your driver, and pay seamlessly. Trust me, it's a game-changer. Click the link below to download and never worry about transportation again!",
        linkUrl:
            'https://play.google.com/store/apps/details?id=com.ondeindia.user',
        chooserTitle: 'Pradeep Cabs');
  }

  String userName = "";
  String userMobile = "";
  String userRating = "";
  String userID = "";
  String accessToken = "";
  String userEmail = "";

  void data() async {
    SharedPreferences _getData = await SharedPreferences.getInstance();

    String? id = _getData.getString('personid');
    String? name = _getData.getString("personname");
    String? email = _getData.getString("personemail");
    String? mobile = _getData.getString("personmobile");
    String? rating = _getData.getString("personrating");
    String? token = _getData.getString("maintoken");

    setState(() {
      userName = name!;
      userEmail = email!;
      userMobile = mobile!;
      userRating = rating!;
      userID = id!;
      accessToken = token!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor.withOpacity(0.7),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    widget.zoomDrawerController.toggle!();
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    color: Colors.white,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _profilePart(),
                const SizedBox(
                  height: 40,
                ),
                _menuLocation(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePart() {
    return FutureBuilder(
        future: getUserProfile(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: whiteColor,
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  widget.zoomDrawerController.toggle!();
                  String imageUrl = snapshot.data['picture'] == null
                      ? ""
                      : snapshot.data['picture'] == ""
                          ? ""
                          : snapshot.data['picture'];
                  String userName = snapshot.data['first_name'];
                  String userEmail = snapshot.data['email'];
                  String userMobile = snapshot.data['mobile'];
                  String userAltMobile =
                      snapshot.data['alternate_mobile_number'] ?? "";
                  String userRating = snapshot.data['rating'];
                  String usergender = snapshot.data['gender'];
                  String userId = snapshot.data['id'].toString();

                  setState(() {
                    userNamesssz = userName;
                    userEmailsssz = userEmail;
                    userMobilesssz = userMobile;
                    useraltsssz = userAltMobile;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        image: imageUrl,
                        name: userName,
                        email: userEmail,
                        mobile: userMobile,
                        altmob: userAltMobile,
                        rating: userRating,
                        gender: usergender,
                        uid: userId,
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    snapshot.data['picture'] == null
                        ? Hero(
                            tag: 'dash',
                            child: Card(
                              color: whiteColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                    image:
                                        ExactAssetImage('assets/icons/man.png'),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : snapshot.data['picture'] == ""
                            ? Hero(
                                tag: 'dash',
                                child: Card(
                                  color: whiteColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(50),
                                      image: const DecorationImage(
                                        image: ExactAssetImage(
                                            'assets/icons/man.png'),
                                      ),
                                    ),
                                  ),
                                ))
                            : Hero(
                                tag: 'dash',
                                child: Card(
                                  color: whiteColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            "http://ondeindia.com/storage/app/public/" +
                                                snapshot.data['picture']
                                                    .toString(),
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data['first_name'],
                          style: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 20,
                              color: whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data['mobile'],
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 15,
                            color: whiteColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: whiteColor,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star_half,
                                    color: Color(0xFFFFD700),
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    snapshot.data['rating'],
                                    style: TextStyle(
                                      fontFamily: 'MonS',
                                      fontSize: 15,
                                      color: Color(0xFFFFD700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _menuLocation() {
    return Column(
      children: [
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const Icon(
              Icons.home,
              color: whiteColor,
              size: 20,
            ),
            title: Text(
              "home".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              widget.zoomDrawerController.toggle!();
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/trips.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "ypuRi".tr,
              // "ongoing".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => onGoinTrips()),
              );
            },
          ),
        ),
        // Theme(
        //   data: ThemeData(
        //     splashColor: Colors.grey[800],
        //     highlightColor: Colors.grey[800],
        //   ),
        //   child: ListTile(
        //     leading: const ImageIcon(
        //       AssetImage(
        //         'assets/icons/trips.png',
        //       ),
        //       color: whiteColor,
        //     ),
        //     title: Text(
        //       "trips".tr,
        //       style: TextStyle(
        //         fontFamily: 'MonS',
        //         fontSize: 15,
        //         color: whiteColor,
        //       ),
        //     ),
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => MenuInnerScreens(
        //             id: 0,
        //             title: "Your Trip's",
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // Theme(
        //   data: ThemeData(
        //     splashColor: Colors.grey[800],
        //     highlightColor: Colors.grey[800],
        //   ),
        //   child: ListTile(
        //     leading: Icon(Icons.sell_outlined, color: whiteColor),
        //     //const ImageIcon(
        //     //   AssetImage(
        //     //     'assets/icons/wallet.png',
        //     //   ),
        //     //   color: whiteColor,
        //     // ),
        //     title: Text(
        //       "coupons".tr,
        //       style: TextStyle(
        //         fontFamily: 'MonS',
        //         fontSize: 15,
        //         color: whiteColor,
        //       ),
        //     ),
        //     onTap: () {
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(
        //       //     builder: (context) => Couponscreen(),
        //       //   ),
        //       // );
        //     },
        //   ),
        // ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/wallet.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "wallet".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletPage(),
                ),
              );
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const Icon(
              Icons.star_border_outlined,
              color: whiteColor,
            ),
            title: Text(
              "reviews".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverRating(),
                ),
              );
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: Icon(Icons.notifications_outlined, color: Colors.white),
            title: Text(
              "notifications".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/settings.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "setting".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/aboutus.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "about".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutUs(),
                ),
              );
            },
          ),
        ),
        // Theme(
        //   data: ThemeData(
        //     splashColor: Colors.grey[800],
        //     highlightColor: Colors.grey[800],
        //   ),
        //   child: ListTile(
        //     leading: const ImageIcon(
        //       AssetImage(
        //         'assets/icons/aboutus.png',
        //       ),
        //       color: whiteColor,
        //     ),
        //     title: const Text(
        //       "ETA",
        //       style: TextStyle(
        //         fontFamily: 'MonS',
        //         fontSize: 15,
        //         color: whiteColor,
        //       ),
        //     ),
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => PolyLine(),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/sharing.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "share".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () async {
              await share();
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading:
                Icon(Icons.confirmation_number_outlined, color: whiteColor),
            title: Text(
              "tick".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketsSection(),
                ),
              );
            },
          ),
        ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/support.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "help".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    // child: _customerSupport(context)
                    child: Support(),
                  );
                },
              );
            },
          ),
        ),
        // Theme(
        //   data: ThemeData(
        //     splashColor: Colors.grey[800],
        //     highlightColor: Colors.grey[800],
        //   ),
        //   child: ListTile(
        //     leading: Icon(
        //       Icons.location_on_outlined,
        //       color: Colors.white,
        //     ),
        //     title: const Text(
        //       "Multiple Markes",
        //       style: TextStyle(
        //         fontFamily: 'MonS',
        //         fontSize: 15,
        //         color: whiteColor,
        //       ),
        //     ),
        //     onTap: () {
        //       // Navigator.push(
        //       //   context,
        //       //   CupertinoPageRoute(
        //       //     builder: (context) => MultipleMarkers(),
        //       //   ),
        //       // );
        //       showModalBottomSheet<void>(
        //         isScrollControlled: true,
        //         backgroundColor: Colors.transparent,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20),
        //         ),
        //         context: context,
        //         builder: (BuildContext context) {
        //           return Padding(
        //             padding: MediaQuery.of(context).viewInsets,
        //             child: PaymentSelection(),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
        Theme(
          data: ThemeData(
            splashColor: Colors.grey[800],
            highlightColor: Colors.grey[800],
          ),
          child: ListTile(
            leading: const ImageIcon(
              AssetImage(
                'assets/icons/logout.png',
              ),
              color: whiteColor,
            ),
            title: Text(
              "logout".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 15,
                color: whiteColor,
              ),
            ),
            onTap: () async {
              AwesomeDialog(
                dismissOnBackKeyPress: false,
                dismissOnTouchOutside: false,
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.SCALE,
                title: 'logA'.tr,
                desc: 'logDes'.tr,
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  showLoaderDialog(context, "loLoa".tr, 10);
                  await userLogout(accessToken, context);
                  // Navigator.pushReplacement(
                  //     context,
                  //     CupertinoPageRoute(
                  //       builder: ((context) => HomeScreen()),
                  //     ));
                },
              ).show();
            },
          ),
        ),
      ],
    );
  }
}
