import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geoCode;
import 'package:google_place/google_place.dart';
import 'package:ondeindia/constants/apiconstants.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/distance.dart';
import 'package:ondeindia/global/fare_type.dart';
import 'package:ondeindia/global/out/out.dart';
import 'package:ondeindia/global/outStatus.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/confirmride.dart';
import 'package:ondeindia/screens/home/widget/no_partners_poly.dart';

import '../../../../global/dropdetails.dart';
import '../../../../global/google_key.dart';

class EditPickUp extends StatefulWidget {
  EditPickUp({Key? key}) : super(key: key);

  @override
  State<EditPickUp> createState() => _EditPickUpState();
}

class _EditPickUpState extends State<EditPickUp> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    String apiKey = Google_Maps_API;
    // String apiKey = DotEnv().env['AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM']!;
    googlePlace = GooglePlace(gooAPIKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 3,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: kindaBlack),
          title: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Update PickUp location...',
              // suffixIcon: IconButton(
              //   onPressed: () {
              //     Fluttertoast.showToast(msg: pickAdd);
              //   },
              //   icon: Icon(Icons.mic),
              // ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                autoCompleteSearch(value);
              } else {
                if (predictions.length > 0 && mounted) {
                  setState(() {
                    predictions = [];
                  });
                }
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: getFavLocation(context),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: kindaBlack,
                            color: primaryColor,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0),
                          child: InkWell(
                            onTap: () async {
                              // String _address =
                              //     snapshot.data![index]['address'];
                              // double lat = double.parse(
                              //     snapshot.data![index]['latitude']);
                              // double long = double.parse(
                              //     snapshot.data![index]['longitude']);
                              // setState(() {
                              //   pickAdd = _address;
                              //   pickLat = lat;
                              //   pikLong = long;
                              //   // pickLat = predictions[index].
                              // });
                              // Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: gold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Icon(
                                        snapshot.data![index]
                                                    ['location_type'] ==
                                                "Work"
                                            ? Icons.local_post_office
                                            : Icons.home,
                                        color: primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data![index]
                                                ['location_type'],
                                            style: const TextStyle(
                                              color: kindaBlack,
                                              fontSize: 13,
                                              fontFamily: 'MonB',
                                            ),
                                          ),
                                          Text(
                                            snapshot.data![index]['address'],
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: kindaBlack,
                                              fontSize: 10,
                                              fontFamily: 'MonM',
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
              Divider(),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(predictions[index].description!),
                    onTap: () async {
                      debugPrint(predictions[index].placeId);

                      List<geoCode.Location> locations = await geoCode
                          .locationFromAddress(predictions[index].description!);

                      print(locations[0].latitude);
                      print(locations[0].longitude);

                      setState(() {
                        pickAdd = predictions[index].description!;
                        pickLat = locations[0].latitude;
                        pikLong = locations[0].longitude;
                        // pickLat = predictions[index].
                      });

                      // Fluttertoast.showToast(
                      //     msg: locations[0]["Latitude"] as );

                      // Navigator.pop(context);

                      getDistance();

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => RideConfirm(
                      //       dropLocation: dropadd,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset("assets/icons/powered_by_google.png"),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 28.0),
              //   child: Text(
              //     "Search Something...",
              //     style: const TextStyle(
              //       color: kindaBlack,
              //       fontSize: 15,
              //       fontFamily: 'MonR',
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }

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

  void autoCompleteSearch(String value) async {
    var result = await googlePlace!.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
