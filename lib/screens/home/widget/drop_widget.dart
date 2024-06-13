import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/confirmride.dart';
import 'package:ondeindia/screens/home/widget/no_partners_poly.dart';
import 'package:ondeindia/screens/home/widget/searchdroplocation.dart';

import '../../../constants/color_contants.dart';
import '../../../global/distance.dart';
import '../../../global/dropdetails.dart';
import '../../../global/fare_type.dart';
import '../../../global/out/out.dart';
import '../../../global/outStatus.dart';
import '../../../global/pickup_location.dart';
import '../../../repositories/tripsrepo.dart';

DropLocationWidget(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), //color of shadow
            spreadRadius: 1, //spread radius
            blurRadius: 2, // blur radius
            offset: Offset(0, 2), // changes position of shadow
            //first paramerter of offset is left-right
            //second parameter is top to down
          ),
          //you can set more BoxShadow() here
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchDropLocation(),
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 14),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 14.0, vertical: 4),
                              //   child: Container(
                              //     height: 10,
                              //     width: 10,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       color: primaryColor,
                              //     ),
                              //   ),
                              // ),
                              Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                "dropLoc".tr,
                                style: TextStyle(
                                  fontFamily: 'MonM',
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                          // Icon(Icons.search, color: Colors.red)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Recents()
        ],
      ),
    ),
  );
}

class Recents extends StatefulWidget {
  Recents({Key? key}) : super(key: key);

  @override
  State<Recents> createState() => _RecentsState();
}

class _RecentsState extends State<Recents> {
  //Outstation Warning and Sugestion

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getDistance() async {
    double totalDistance = 0;

    totalDistance += calculateDistance(pickLat, pikLong, dropLat, dropLong);

    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    if (distance <= 50.0) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideConfirm(
              dropLocation: dropadd,
            ),
          ));
    } else if (!fareTypeActive.any((element) => element["id"] == 16)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MapSample()));
      // EasyLoading.showToast("No partners available for the selected location");
    } else {
      showModalBottomSheet(
          isDismissible: false,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: outstationWarning(),
            );
          });
    }
  }

  outstationWarning() {
    var dr = dropadd.toString().split(",");
    return Container(
      height: MediaQuery.of(context).size.height / 2.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: whiteColor),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 3,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.amber,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Address: ",
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'MonB',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        dropadd + "." + " is out of city limit ",
                        maxLines: 4,
                        style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19.0),
                      child: Text(
                        "You can continue to book an outstation ride insted",
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'MonM',
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(1, 1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(-1, -1), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                  ),
                  // child: Lottie.asset('assets/animation/warning.json',
                  //     fit: BoxFit.cover),
                  // child: Lottie.network(
                  //     "https://assets10.lottiefiles.com/packages/lf20_yd98d4m1.json"),
                  child: Icon(
                    Icons.error_outline_outlined,
                    color: Colors.amber,
                    size: 56,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 29,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () async {
                  setState(() {
                    fareType = "16";
                    outstatus = true;
                    out = true;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideConfirm(
                        dropLocation: dropadd,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: const Center(
                    child: Text(
                      "Book OutStation Ride",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'MonS',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: const Center(
                    child: Text(
                      "Change Drop Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'MonS',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: getRecentSearch(context),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 3,
                width: 150, child: SizedBox(),
                // child: LinearProgressIndicator(
                //   color: primaryColor,
                //   backgroundColor: primaryColor.withOpacity(0.2),
                // ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return SizedBox();
            }
            return Column(
              children: [
                ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 50,
                          child: InkWell(
                            onTap: () {
                              String _dropA =
                                  snapshot.data![index]['d_address'].toString();
                              double _dropLa =
                                  snapshot.data![index]['d_latitude'];
                              double _dropLo =
                                  snapshot.data![index]['d_longitude'];
                              setState(() {
                                dropadd = _dropA;
                                dropLat = _dropLa;
                                dropLong = _dropLo;
                                // pickLat = predictions[index].
                              });
                              getValidZones(context);
                              getDistance();
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => RideConfirm(
                              //         dropLocation: _dropA,
                              //       ),
                              //     ));
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Icon(Icons.history, size: 15),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Expanded(
                                        child: Text(
                                          snapshot.data![index]['d_address']
                                              .toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'MonR',
                                            fontSize: 12,
                                            color: Color(0xFf4B4B4B),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
          },
        ),
        FutureBuilder(
          future: getRecentSearchPick(context),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 3,
                width: 150, child: SizedBox(),
                // child: LinearProgressIndicator(
                //   color: primaryColor,
                //   backgroundColor: primaryColor.withOpacity(0.2),
                // ),
              );
            }
            if (snapshot.data!.isEmpty) {
              return SizedBox();
            }
            return Container(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // return Container();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            onTap: () {
                              String _dropA =
                                  snapshot.data![index]['s_address'].toString();
                              double _dropLa =
                                  snapshot.data![index]['s_latitude'];
                              double _dropLo =
                                  snapshot.data![index]['s_longitude'];
                              setState(() {
                                dropadd = _dropA;
                                dropLat = _dropLa;
                                dropLong = _dropLo;
                                // pickLat = predictions[index].
                              });
                              getValidZones(context);
                              getDistance();
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => RideConfirm(
                              //         dropLocation: _dropA,
                              //       ),
                              //     ));
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Icon(Icons.history, size: 15),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      Expanded(
                                        child: Text(
                                          snapshot.data![index]['s_address']
                                              .toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'MonR',
                                            fontSize: 12,
                                            color: Color(0xFf4B4B4B),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
