import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_button/group_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:ondeindia/widgets/menuscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/apiconstants.dart';
import '../../global/dropdetails.dart';
import '../../global/fare_type.dart';
import '../../global/rental_fare_plan.dart';
import '../../widgets/loder_dialg.dart';
import '../auth/loginscreen.dart';
import '../auth/new_auth/login_new.dart';
import '../auth/new_auth/new_auth_selected.dart';

class ProfilePage extends StatefulWidget {
  String image, name, mobile, altmob, email, rating, uid, gender;
  ProfilePage(
      {Key? key,
      required this.image,
      required this.email,
      required this.mobile,
      required this.altmob,
      required this.name,
      required this.rating,
      required this.gender,
      required this.uid})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

//  userName = userName;
  // userEmail = userEmail;
  // userMobile = userMobile;
  // useralt = userAltMobile;

  TextEditingController _nameController =
      TextEditingController(text: userNamesssz);
  TextEditingController _altmobileController =
      TextEditingController(text: useraltsssz);
  TextEditingController _emailIDController =
      TextEditingController(text: userEmailsssz);
  TextEditingController _mobileController =
      TextEditingController(text: userMobilesssz);

  File? _image;
  String selectedGen = "";

  bool editProfile = false;

  Future _editProfileOTP() async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    // String? userID = _token.getString('personid');
    const String apiUrl = sendOTP;
    // "https://mocki.io/v1/2a24ab31-fcb6-4306-bd28-a1cdf0d99541";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer " + userToken.toString()},
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "OTP has been sent sucessfully");

      showModalBottomSheet(
          isDismissible: false,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: _otpSection(),
            );
          });
      // String image = jsonDecode(response.body)['avatar'].toString();

      // await _token.setString("imageUrl", image);
      // String? hmm = jsonDecode(response.body)['status'];
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      print(jsonDecode(response.body)['message']);
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => NewAuthSelection(),
      //     ),
      //     (route) => false);
      print(jsonDecode(response.body)['message']);
    } else if (response.statusCode == 412) {
      print(jsonDecode(response.body)['message']);
    } else if (response.statusCode == 500) {
      print(jsonDecode(response.body)['message']);
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      print(jsonDecode(response.body)['message']);
    } else if (response.statusCode == 403) {
      print(jsonDecode(response.body)['message']);
    }
    throw 'Exception';
  }

  Future _editProfilVerifyeOTP(otp) async {
    SharedPreferences _token = await SharedPreferences.getInstance();
    String? userToken = _token.getString('maintoken');
    // String? userID = _token.getString('personid');
    const String apiUrl = verifyOTP;
    // "https://mocki.io/v1/2a24ab31-fcb6-4306-bd28-a1cdf0d99541";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer " + userToken.toString(),
      },
      body: {
        "otp": otp,
      },
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        editProfile = !editProfile;
      });

      // String image = jsonDecode(response.body)['avatar'].toString();

      // await _token.setString("imageUrl", image);
      // String? hmm = jsonDecode(response.body)['status'];
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 412) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 500) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 401) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewAuthSelection(),
        ),
      );
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    } else if (response.statusCode == 403) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    }
    throw 'Exception';
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) {
          return;
        }
        final imageTemporary = File(image.path);
        setState(() {
          this._image = imageTemporary;
        });
      } on PlatformException catch (e) {
        print("Exception occured");
      }
    }

    Future<List> updateUserProfile(context, name, mobile, altM, email) async {
      SharedPreferences _token = await SharedPreferences.getInstance();
      String? userToken = _token.getString('maintoken');
      // String apiUrl = driverRating;
      // final response = await http.post(
      //   Uri.parse(apiUrl),
      //   headers: {"Authorization": "Bearer " + userToken.toString()},
      // );

      var headers = {'Authorization': 'Bearer ' + userToken.toString()};
      var request = http.MultipartRequest('POST', Uri.parse(updateProfile));
      request.fields.addAll({
        'first_name': _nameController.text,
        'email': _emailIDController.text,
        'mobile': _mobileController.text,
        'gender': selectedGen == '' ? widget.gender : selectedGen,
        "alternate_mobile_number": _altmobileController.text
      });
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('picture', _image!.path));
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pop(context);
        print(await response.stream.bytesToString());
        Fluttertoast.showToast(msg: "Profile Updated");
        setState(() {
          fareType = "15";
          rentalFarePlan = "";
          dropadd = "";
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
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
      // print(userId);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: editProfile == false
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Profile",
                                style: const TextStyle(
                                  fontFamily: 'MonS',
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "# " + widget.uid,
                                style: const TextStyle(
                                  fontFamily: 'MonR',
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 100,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20),
                    //       color: primaryColor.withOpacity(0.3),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           widget.image == ""
                    //               ? Hero(
                    //                   tag: 'dash',
                    //                   child: Card(
                    //                     color: whiteColor,
                    //                     elevation: 4,
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius:
                    //                           BorderRadius.circular(50),
                    //                     ),
                    //                     child: Container(
                    //                       height: 50,
                    //                       width: 50,
                    //                       decoration: BoxDecoration(
                    //                         color: whiteColor,
                    //                         borderRadius:
                    //                             BorderRadius.circular(50),
                    //                         image: const DecorationImage(
                    //                           image: ExactAssetImage(
                    //                               'assets/icons/man.png'),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               : Hero(
                    //                   tag: 'dash',
                    //                   child: Card(
                    //                     color: whiteColor,
                    //                     elevation: 4,
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius:
                    //                           BorderRadius.circular(50),
                    //                     ),
                    //                     child: Container(
                    //                       height: 50,
                    //                       width: 50,
                    //                       decoration: BoxDecoration(
                    //                         color: whiteColor,
                    //                         borderRadius:
                    //                             BorderRadius.circular(50),
                    //                         image: DecorationImage(
                    //                             image: NetworkImage(
                    //                                 "http://ondeindia.com/storage/app/public/" +
                    //                                     widget.image),
                    //                             fit: BoxFit.cover),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Expanded(
                    //             child: Row(
                    //               children: [
                    //                 Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       Text(
                    //                         widget.name,
                    //                         maxLines: 1,
                    //                         style: TextStyle(
                    //                           fontFamily: 'MonM',
                    //                           fontSize: 14,
                    //                           color: kindaBlack,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                       SizedBox(
                    //                         height: 6,
                    //                       ),
                    //                       Text(
                    //                         widget.mobile +
                    //                             ", " +
                    //                             widget.altmob,
                    //                         maxLines: 1,
                    //                         style: TextStyle(
                    //                           fontFamily: 'MonM',
                    //                           fontSize: 14,
                    //                           color: kindaBlack,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                       SizedBox(
                    //                         height: 6,
                    //                       ),
                    //                       Text(
                    //                         widget.email,
                    //                         maxLines: 1,
                    //                         style: TextStyle(
                    //                           fontFamily: 'MonM',
                    //                           fontSize: 14,
                    //                           color: kindaBlack,
                    //                         ),
                    //                         overflow: TextOverflow.ellipsis,
                    //                       ),
                    //                     ])
                    //               ],
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.image == ""
                        ? Center(
                            child: Hero(
                              tag: 'dash',
                              child: Card(
                                color: whiteColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                    image: const DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/icons/man.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Hero(
                              tag: 'dash',
                              child: Card(
                                color: whiteColor,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "http://ondeindia.com/storage/app/public/" +
                                                widget.image),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 2, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.perm_identity_outlined,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  widget.name,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'MonM',
                                    fontSize: 14,
                                    color: kindaBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Icon(Icons.favorite_outline, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 2,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 2, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.call_outlined,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  widget.mobile,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'MonM',
                                    fontSize: 14,
                                    color: kindaBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Icon(Icons.favorite_outline, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ),
                    widget.altmob == ""
                        ? Container()
                        : SizedBox(
                            height: 2,
                          ),

                    widget.altmob == ""
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.2), //color of shadow
                                    spreadRadius: 1, //spread radius
                                    blurRadius: 2, // blur radius
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                    //first paramerter of offset is left-right
                                    //second parameter is top to down
                                  ),
                                  //you can set more BoxShadow() here
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 18),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.call_outlined,
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.altmob,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'MonM',
                                          fontSize: 14,
                                          color: kindaBlack,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Icon(Icons.favorite_outline, color: primaryColor)
                                  ],
                                ),
                              ),
                            ),
                          ),

                    SizedBox(
                      height: 2,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 2, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  widget.email,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'MonM',
                                    fontSize: 14,
                                    color: kindaBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Icon(Icons.favorite_outline, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 2, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 18),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    widget.gender == 'Male'
                                        ? Icons.male
                                        : widget.gender == 'Female'
                                            ? Icons.female
                                            : Icons.transgender,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  widget.gender,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'MonM',
                                    fontSize: 14,
                                    color: kindaBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Icon(Icons.favorite_outline, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Divider(
                    //   color: kindaBlack,
                    // ),
                    // SizedBox(height: 7),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0),
                    //   child: Text(
                    //     "Wallet Details",
                    //     style: const TextStyle(
                    //       fontFamily: 'MonS',
                    //       fontSize: 15,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(left: 18.0),
                    //       child: Text(
                    //         "Wallet Amount",
                    //         style: const TextStyle(
                    //           fontFamily: 'MonR',
                    //           fontSize: 15,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: EdgeInsets.only(right: 8.0),
                    //       width: 116,
                    //       height: 55,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(7),
                    //         color: primaryColor,
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "1000",
                    //           style: const TextStyle(
                    //             fontFamily: 'MonS',
                    //             fontSize: 20,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                  ],
                )
              : Builder(builder: (context) {
                  return Form(
                    key: _formKey3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Profile",
                                    style: const TextStyle(
                                      fontFamily: 'MonS',
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "# " + widget.uid,
                                    style: const TextStyle(
                                      fontFamily: 'MonR',
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.1), //color of shadow
                                  spreadRadius: 1, //spread radius
                                  blurRadius: 1, // blur radius
                                  offset: Offset(
                                      1, 1), // changes position of shadow
                                  //first paramerter of offset is left-right
                                  //second parameter is top to down
                                ),
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.1), //color of shadow
                                  spreadRadius: 1, //spread radius
                                  blurRadius: 1, // blur radius
                                  offset: Offset(
                                      -1, -1), // changes position of shadow
                                  //first paramerter of offset is left-right
                                  //second parameter is top to down
                                ),
                                //you can set more BoxShadow() here
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  widget.image == ""
                                      ? Hero(
                                          tag: 'dash',
                                          child: Card(
                                            color: whiteColor,
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                image: const DecorationImage(
                                                  image: ExactAssetImage(
                                                      'assets/icons/man.png'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Hero(
                                          tag: 'dash',
                                          child: Card(
                                            color: whiteColor,
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "http://ondeindia.com/storage/app/public/" +
                                                            widget.image),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.name,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'MonM',
                                                  fontSize: 14,
                                                  color: kindaBlack,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                widget.mobile +
                                                    ", " +
                                                    widget.altmob,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'MonM',
                                                  fontSize: 14,
                                                  color: kindaBlack,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                widget.email,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'MonM',
                                                  fontSize: 14,
                                                  color: kindaBlack,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ])
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _image == null
                            ? widget.image == ""
                                ? Center(
                                    child: Hero(
                                      tag: 'dash',
                                      child: Card(
                                        color: whiteColor,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            image: const DecorationImage(
                                              image: ExactAssetImage(
                                                  'assets/icons/man.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Hero(
                                      tag: 'dash',
                                      child: Card(
                                        color: whiteColor,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "http://ondeindia.com/storage/app/public/" +
                                                        widget.image),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            : Center(
                                child: Hero(
                                  tag: 'dash',
                                  child: Card(
                                    color: whiteColor,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Container(
                                      height: 90,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image: FileImage(_image!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              pickImage();
                            },
                            child: Container(
                              height: 39,
                              width: 172,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: Color(0xFF704A26).withOpacity(0.6),
                              ),
                              child: Center(
                                child: Text(
                                  "Change Profile Pic",
                                  style: TextStyle(
                                    fontFamily: 'MonB',
                                    fontSize: 12,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Name",
                            style: const TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 2,
                          child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'TWebR',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            controller: _nameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //   color: Color(0xFF2661FA),
                                //   width: 1.6,
                                // ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'Name',
                              hintStyle: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'TWebR',
                                fontSize: 15,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'TWebR',
                                fontSize: 16,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          margin: const EdgeInsets.all(10),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Mobile Number",
                            style: const TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 2,
                          child: TextFormField(
                            enabled: false,
                            style: TextStyle(
                                fontFamily: 'TWebR',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            maxLength: 10,
                            controller: _mobileController,
                            decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: Icon(
                                Icons.call,
                                color: primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //   color: Color(0xFF2661FA),
                                //   width: 1.6,
                                // ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'User Mobile Number',
                              hintStyle: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'TWebR',
                                fontSize: 15,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'TWebR',
                                fontSize: 16,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          margin: const EdgeInsets.all(10),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Emergency Mobile Number",
                            style: const TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 2,
                          child: TextFormField(
                            maxLength: 10,
                            controller: _altmobileController,
                            style: TextStyle(
                                fontFamily: 'TWebR',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            decoration: InputDecoration(
                              counterText: "",
                              prefixIcon: Icon(
                                Icons.call,
                                color: primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //   color: Color(0xFF2661FA),
                                //   width: 1.6,
                                // ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'User Alternate Mobile Number',
                              hintStyle: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'TWebR',
                                fontSize: 15,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'TWebR',
                                fontSize: 16,
                              ),
                            ),
                          ),
                          margin: const EdgeInsets.all(10),
                        ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8.0),
                        //   child: Text(
                        //     "Alternate Mobile Number",
                        //     style: const TextStyle(
                        //       fontFamily: 'MonS',
                        //       fontSize: 15,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Card(
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(15)),
                        // elevation: 2,
                        //   child: TextFormField(
                        // style: TextStyle(
                        //     fontFamily: 'TWebR',
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w400,
                        //     color: primaryColor),
                        // maxLength: 10,
                        // controller: _altmobileController,
                        //   decoration: InputDecoration(
                        //     counterText: "",
                        //     prefixIcon: Icon(
                        //       Icons.call,
                        //       color: primaryColor,
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       // borderSide: const BorderSide(
                        //       //   color: Color(0xFF2661FA),
                        //       //   width: 1.6,
                        //       // ),
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //     enabledBorder: const OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Colors.transparent,
                        //         width: 1.0,
                        //       ),
                        //     ),
                        //     hintText: 'User Alternate Mobile Number',
                        //     hintStyle: const TextStyle(
                        //       color: Colors.black54,
                        //       fontFamily: 'TWebR',
                        //       fontSize: 15,
                        //     ),
                        //     labelStyle: const TextStyle(
                        //       color: Colors.black,
                        //       fontFamily: 'TWebR',
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        //   keyboardType: TextInputType.number,
                        // ),
                        // margin: const EdgeInsets.all(10),
                        // ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Email ID",
                            style: const TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 2,
                          child: TextFormField(
                            // enabled: false,
                            style: TextStyle(
                                fontFamily: 'TWebR',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: primaryColor),
                            controller: _emailIDController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: primaryColor,
                              ),
                              focusedBorder: OutlineInputBorder(
                                // borderSide: const BorderSide(
                                //   color: Color(0xFF2661FA),
                                //   width: 1.6,
                                // ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'User Email ID',
                              hintStyle: const TextStyle(
                                color: Colors.black54,
                                fontFamily: 'TWebR',
                                fontSize: 15,
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'TWebR',
                                fontSize: 16,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter some text';
                            //   }
                            //   return null;
                            // },
                          ),
                          margin: const EdgeInsets.all(10),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Gender",
                            style: const TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GroupButton(
                            isRadio: true,
                            // selectedButton: widget.gender == 'Male'
                            //     ? 0
                            //     : widget.gender == 'Female'
                            //         ? 1
                            //         : 2,
                            onSelected: (index, isSelected, _) {
                              setState(() {
                                selectedGen = index == 0
                                    ? 'Male'
                                    : index == 1
                                        ? 'Female'
                                        : 'Others';
                              });
                            },
                            // print('$index button is selected'),
                            buttons: ["Male", "Female", "Others"],
                            options: GroupButtonOptions(
                              selectedShadow: [
                                BoxShadow(
                                  color: Color(0xFF009ED9)
                                      .withOpacity(0.2), //color of shadow
                                  spreadRadius: 2, //spread radius
                                  blurRadius: 2, // blur radius
                                  offset: Offset(
                                      2, 2), // changes position of shadow
                                  //first paramerter of offset is left-right
                                  //second parameter is top to down
                                ),
                              ],
                              selectedTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: 'MonM'),
                              selectedColor: Color(0xFF009ED9),
                              unselectedShadow: const [],
                              unselectedColor: Colors.white,
                              unselectedTextStyle: TextStyle(
                                fontSize: 13,
                                fontFamily: 'PopR',
                                color: black,
                              ),
                              selectedBorderColor: Colors.white,
                              unselectedBorderColor: black,
                              borderRadius: BorderRadius.circular(10),
                              spacing: 10,
                              runSpacing: 10,
                              groupingType: GroupingType.wrap,
                              direction: Axis.horizontal,
                              buttonHeight: 40,
                              buttonWidth: 90,
                              mainGroupAlignment: MainGroupAlignment.start,
                              crossGroupAlignment: CrossGroupAlignment.start,
                              groupRunAlignment: GroupRunAlignment.start,
                              textAlign: TextAlign.center,
                              textPadding: EdgeInsets.zero,
                              alignment: Alignment.center,
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 18.0, top: 12),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: kindaBlack,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextButton(
                                onPressed: () async {
                                  String controllerName = _nameController.text;
                                  String controllerMobile =
                                      _mobileController.text;
                                  String controllerAltMobile =
                                      _altmobileController.text;

                                  showLoaderDialog(
                                      context, "Updating your profile...", 15);

                                  // String name = _nameController.text;
                                  updateUserProfile(
                                      context,
                                      controllerName,
                                      controllerMobile,
                                      controllerAltMobile,
                                      widget.email);
                                  // if (_formKey3.currentState!.validate()) {

                                  // }
                                },
                                child: Center(
                                  child: Text(
                                    "Save Changes",
                                    style: TextStyle(
                                      fontFamily: 'MonM',
                                      fontSize: 15,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  );
                }),
        ),
      ),
      floatingActionButton: editProfile == false
          ? FloatingActionButton.extended(
              backgroundColor: kindaBlack,
              onPressed: () {
                setState(() {
                  editProfile = !editProfile;
                });
              },
              label: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "Edit Profile",
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'MonM',
                      fontSize: 14,
                      color: whiteColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  editProfile = !editProfile;
                });
              },
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            ),
    );
  }

  Widget _otpSection() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            height: 6,
            width: 30,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: primaryColor,
            ),
          ),
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Stack(
              children: [
                Material(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.yellow.shade500.withOpacity(0.4),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/changepassword.png',
                    height: 70,
                    width: 70,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "To edit your profile you are obligated to verify yourself...So please enter the OTP sent to you on your mobile to continue process of profile edit.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'MonR',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Form(
            key: _formKey2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
              child: TextFormField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                controller: _otpController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // O
                decoration: InputDecoration(
                  counterText: "",
                  hintText: 'ex: 858989',
                  label: const Text("OTP"),
                  labelStyle: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 13,
                    color: primaryColor,
                  ),
                  suffixIcon: const Icon(
                    Icons.password_outlined,
                    color: primaryColor,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: primaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: primaryColor)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter OTP";
                  }
                  if (value.length < 6) {
                    return "Please enter valid OTP";
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text(
                  //     "Re-Send OTP",
                  //     style: TextStyle(
                  //       color: Colors.blue.shade700,
                  //       fontSize: 12,
                  //       fontFamily: 'MonS',
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Row(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            // backgroundColor: MaterialStateProperty.all(primaryColor),
                            ),
                        onPressed: () async {
                          Navigator.pop(context);
                          _editProfileOTP();
                          // String email = _emailController.text;
                          // if (_formKey.currentState!.validate()) {
                          //   showLoaderDialog(context, 50, "Verifying Email...");
                          //   await forgotDriverPassword(context, email);
                          // } else {
                          //   Fluttertoast.showToast(
                          //       msg: "Enter valid Email Address");
                          // }

                          // String _otp = _otpController.text;
                          // if (_formKey2.currentState!.validate()) {
                          //   Navigator.pop(context);
                          //   showLoaderDialog(context, 50, "Verifying OTP");
                          //   await otpVerification(context, _email, _otp);
                          // } else {
                          //   Fluttertoast.showToast(msg: "Enter Valid OTP");
                          // }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'MonS',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                        onPressed: () async {
                          String _otp = _otpController.text;

                          if (_formKey2.currentState!.validate()) {
                            _editProfilVerifyeOTP(_otp);
                          }
                          // _editProfiles
                          // String _email = _emailController.text;
                          // String _otp = _otpController.text;
                          // if (_formKey2.currentState!.validate()) {
                          //   Navigator.pop(context);
                          //   showLoaderDialog(context, 50, "Verifying OTP");
                          //   await otpVerification(context, _email, _otp);
                          // } else {
                          //   Fluttertoast.showToast(msg: "Enter Valid OTP");
                          // }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Verify OTP",
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 15,
                              fontFamily: 'MonS',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



/*

Center(
                child: Container(
                  height: 39,
                  width: 172,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Color(0xFF704A26).withOpacity(0.6),
                  ),
                  child: Center(
                    child: Text(
                      "Change Profile Pic",
                      style: TextStyle(
                        fontFamily: 'MonB',
                        fontSize: 12,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  "userID:- 3t7843ghjbvljbv",
                  style: TextStyle(
                    fontFamily: 'MonB',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Name",
                  style: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: 'TWebR',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: primaryColor),
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: primaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: const BorderSide(
                      //   color: Color(0xFF2661FA),
                      //   width: 1.6,
                      // ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontFamily: 'TWebR',
                      fontSize: 15,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'TWebR',
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                margin: const EdgeInsets.all(10),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Mobile Number",
                  style: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: 'TWebR',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: primaryColor),
                  maxLength: 10,
                  controller: _mobileController,
                  decoration: InputDecoration(
                    counterText: "",
                    prefixIcon: Icon(
                      Icons.call,
                      color: primaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: const BorderSide(
                      //   color: Color(0xFF2661FA),
                      //   width: 1.6,
                      // ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    hintText: 'User Mobile Number',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontFamily: 'TWebR',
                      fontSize: 15,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'TWebR',
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                margin: const EdgeInsets.all(10),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Email ID",
                  style: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 2,
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: 'TWebR',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: primaryColor),
                  controller: _emailIDController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: const BorderSide(
                      //   color: Color(0xFF2661FA),
                      //   width: 1.6,
                      // ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    hintText: 'User Email ID',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontFamily: 'TWebR',
                      fontSize: 15,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'TWebR',
                      fontSize: 16,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                margin: const EdgeInsets.all(10),
              ),
              SizedBox(height: 7),




 */

/*
Hero(
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
                      image: ExactAssetImage('assets/icons/man.png'),
                    ),
                  ),
                ),
              ),
            ),
 */
