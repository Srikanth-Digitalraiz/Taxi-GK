import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/legal%20section/privacy.dart';
import 'package:ondeindia/legal%20section/trems.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/auth/change_password/verification.dart';
import 'package:ondeindia/screens/profile/profile.dart';
import 'package:ondeindia/widgets/coupons_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../legal section/refund_policy.dart';
import '../../widgets/support.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Language Section
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'తెలుగు', 'locale': Locale('tl', 'IN')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(color: kindaBlack),
        title: Text(
          "setting".tr,
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 15,
            color: kindaBlack,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Text(
              "general".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 14,
                color: kindaBlack,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: FutureBuilder(
              future: getNotificationVal(context),
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
                          height: 200,
                          width: 200,
                          child: Lottie.asset('assets/animation/loading.json'),
                        ),
                        // SizedBox(height: 10),
                        Text(
                          "noda".tr,
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
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SwitchListTile(
                            activeTrackColor: secondaryColor.withOpacity(0.6),
                            activeColor: secondaryColor,
                            title: Text(
                              "notialert".tr,
                              style: TextStyle(
                                fontFamily: 'MonS',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            secondary: Icon(Icons.notifications_on_outlined),
                            selected: snapshot.data![0]['status'] == "Active"
                                ? true
                                : false,
                            value: snapshot.data![0]['status'] == "Active"
                                ? true
                                : false,
                            onChanged: (value) async {
                              // Fluttertoast.showToast(
                              //     msg: snapshot.data![index]['id'].toString());
                              await updateNotificationsVal(
                                context,
                              );
                              setState(() {});
                              // setState(() {
                              //   _value = value;
                              // });
                            },
                          ),
                        );
                      })),
                );
              },
            ),
          ),
          Divider(
            color: kindaBlack.withOpacity(0.6),
          ),
          //Language
          ListTile(
            leading: Icon(
              Icons.translate_outlined,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              "changelang".tr,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'MonM',
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text('Choose Your Language'),
                      content: Container(
                        width: double.maxFinite,
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Text(locale[index]['name']),
                                  onTap: () async {
                                    SharedPreferences lanSha =
                                        await SharedPreferences.getInstance();
                                    String? lan = index == 0
                                        ? "0"
                                        : index == 1
                                            ? "1"
                                            : index == 2
                                                ? "2"
                                                : "";

                                    // Fluttertoast.showToast(msg: lan);
                                    lanSha.setString("lan", lan);
                                    // print(locale[index]['name']);
                                    updateLanguage(locale[index]['locale']);
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Colors.blue,
                              );
                            },
                            itemCount: locale.length),
                      ),
                    );
                  });
            },
          ),
          //Change Password
          // const SizedBox(
          //   height: 10,
          // ),
          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text(
          //     "access".tr,
          //     style: TextStyle(
          //       fontFamily: 'MonS',
          //       fontSize: 15,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // ListTile(
          //   tileColor: Colors.red.shade500,
          //   leading: Icon(
          //     Icons.password,
          //     color: whiteColor,
          //   ),
          //   title: Text(
          //     "changepass".tr,
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 15,
          //       fontFamily: 'MonR',
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => VerificationPage(
          //           title: "Change Password",
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // const SizedBox(
          //   height: 12,
          // ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 1.6,
            color: kindaBlack,
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "legal".tr,
              style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 14,
                color: kindaBlack,
              ),
            ),
          ),
          ListTile(
            leading: ImageIcon(
              AssetImage(
                'assets/icons/accept.png',
              ),
            ),
            title: Text(
              "terms".tr,
              style: TextStyle(
                fontFamily: 'MonR',
                fontSize: 14,
                color: kindaBlack,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Terms(),
                ),
              );
            },
          ),
          ListTile(
            leading: ImageIcon(
              AssetImage(
                'assets/icons/accept.png',
              ),
            ),
            title: Text(
              "refund".tr,
              style: TextStyle(
                fontFamily: 'MonR',
                fontSize: 14,
                color: kindaBlack,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RefundPolicy(),
                ),
              );
            },
          ),
          ListTile(
            leading: ImageIcon(
              AssetImage(
                'assets/icons/privacypolicy.png',
              ),
            ),
            title: Text(
              "privacy".tr,
              style: TextStyle(
                fontFamily: 'MonR',
                fontSize: 14,
                color: kindaBlack,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivacyPolicy(),
                ),
              );
            },
          ),
          ListTile(
            leading: ImageIcon(
              AssetImage(
                'assets/icons/customersupport.png',
              ),
            ),
            title: Text(
              "help".tr,
              style: TextStyle(
                fontFamily: 'MonR',
                fontSize: 14,
                color: kindaBlack,
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
          Divider(),
          ListTile(
            tileColor: primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        content: Builder(
                          builder: (context) {
                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                            var height = MediaQuery.of(context).size.height;
                            var width = MediaQuery.of(context).size.width;

                            return Container(
                              height: 275,
                              width: 400,
                              child: ListView(
                                children: [
                                  Lottie.asset('assets/animation/delete.json',
                                      height: 120, width: 120),
                                  Center(
                                    child: Text(
                                      'Are you sure you want to\ndelete your account?',
                                      style: TextStyle(
                                        color: black,
                                        fontFamily: 'PopM',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  InkWell(
                                    onTap: () {
                                      EasyLoading.show();
                                      // deleteAcc();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 800,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(160),
                                          color: Color(0xFFFC5151)),
                                      child: Center(
                                        child: Text(
                                          'Yes, Delete',
                                          style: TextStyle(
                                            color: white,
                                            fontFamily: 'PopM',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Keep Account',
                                      style: TextStyle(
                                        color: Color(0xFFFC5151),
                                        fontFamily: 'PopM',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ));
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => TermsSection(
              //       pageName: 'Refund Policy',
              //     ),
              //   ),
              // );
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => RefundPolicy(),
              //   ),
              // );
              // _advancedDrawerController.hideDrawer();
            },
            title: Row(
              children: [
                // SizedBox(
                //   width: 7,
                // ),
                Icon(
                  LineIcons.trash,
                  color: white,
                ),
                SizedBox(
                  width: 17,
                ),
                Text(
                  "Delete Account",
                  style: TextStyle(
                      color: white,
                      fontFamily: 'PopM',
                      // fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ],
            ),
            trailing: Icon(
              LineIcons.angleRight,
              size: 15,
              color: white.withOpacity(0.3),
            ),
          ),
          // Container(
          //   height: 30,
          //   margin: EdgeInsets.only(top: 74),
          //   width: MediaQuery.of(context).size.width,
          //   color: secondaryColor,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ImageIcon(
          //         AssetImage(
          //           'assets/icons/customersupport.png',
          //         ),
          //         color: whiteColor,
          //       ),
          //       SizedBox(
          //         width: 15,
          //       ),
          //       Text(
          //         "visit".tr,
          //         style: TextStyle(
          //           fontFamily: 'MonS',
          //           fontSize: 12,
          //           color: whiteColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // )b
        ],
      ),
    );
  }
}
