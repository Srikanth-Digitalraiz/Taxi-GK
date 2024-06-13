import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_place/google_place.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/distance.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/fare_type.dart';
import 'package:ondeindia/global/out/out.dart';
import 'package:ondeindia/global/outStatus.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/home/Ride%20Confirm/confirmride.dart';
import 'package:geocoding/geocoding.dart' as geoCode;
import 'package:ondeindia/screens/home/widget/no_partners_poly.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/apiconstants.dart';

class EditDropLocation extends StatefulWidget {
  EditDropLocation({Key? key}) : super(key: key);

  @override
  State<EditDropLocation> createState() => _EditDropLocationState();
}

class _EditDropLocationState extends State<EditDropLocation> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    String apiKey = Google_Maps_API;
    // String apiKey = DotEnv().env['AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM']!;
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  List locationssssD = [];

  Future getLocationsList(querrr) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userToken = _sharedData.getString('maintoken');
    var headers = {'Authorization': 'Bearer $userToken'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ondeindia.com/api/user/search'));
    request.fields.addAll({
      'id': '$pickAddIdd',
      'search': '$querrr',
      'type': '1',
      'location': '$pickAdd',
      'latitude': '$pickLat',
      'longitude': '$pikLong'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print(request.fields);

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        locationssssD = decodedMap['data'];
      });
      print(locationssssD);
    } else {
      print(response.reasonPhrase);
    }
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
              hintText: 'Update Destination location...',
              // suffixIcon: IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.mic),
              // ),
            ),
            onChanged: (value) {
              if (value.length >= 3) {
                getLocationsList(value);
              }
              // if (value.isNotEmpty) {
              //   autoCompleteSearch(value);
              // } else {
              //   if (predictions.length > 0 && mounted) {
              //     setState(() {
              //       predictions = [];
              //     });
              //   }
              // }
            },
          ),
        ),
        body: Column(
          children: [
            // FutureBuilder(
            //     future: getFavLocation(context),
            //     builder: (context, AsyncSnapshot<List> snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(
            //           child: SizedBox(
            //             height: 30,
            //             width: 30,
            //             child: CircularProgressIndicator(
            //               backgroundColor: kindaBlack,
            //               color: primaryColor,
            //             ),
            //           ),
            //         );
            //       }

            //       return ListView.builder(
            //         shrinkWrap: true,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemCount: snapshot.data!.length,
            //         itemBuilder: ((context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.only(
            //                 left: 8.0, right: 8.0, top: 8.0),
            //             child: InkWell(
            //               onTap: () {
            //                 // String _address =
            //                 //     snapshot.data![index]['address'];
            //                 // double lat = double.parse(
            //                 //     snapshot.data![index]['latitude']);
            //                 // double long = double.parse(
            //                 //     snapshot.data![index]['longitude']);
            //                 // setState(() {
            //                 //   dropadd = _address;
            //                 //   dropLat = lat;
            //                 //   dropLong = long;
            //                 //   // pickLat = predictions[index].
            //                 // });
            //                 // Fluttertoast.showToast(msg: lat.toString());
            //                 // getValidZones(context);
            //                 // Navigator.push(
            //                 //     context,
            //                 //     MaterialPageRoute(
            //                 //       builder: (context) => RideConfirm(
            //                 //         dropLocation: _address,
            //                 //       ),
            //                 //     ));
            //               },
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   color: gold.withOpacity(0.2),
            //                   borderRadius: BorderRadius.circular(6),
            //                 ),
            //                 child: Padding(
            //                   padding:
            //                       const EdgeInsets.symmetric(vertical: 8.0),
            //                   child: Row(
            //                     children: [
            //                       Padding(
            //                         padding:
            //                             const EdgeInsets.only(left: 12.0),
            //                         child: Icon(
            //                           snapshot.data![index]
            //                                       ['location_type'] ==
            //                                   "Work"
            //                               ? Icons.local_post_office
            //                               : Icons.home,
            //                           color: primaryColor,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 10,
            //                       ),
            //                       Expanded(
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           children: [
            //                             Text(
            //                               snapshot.data![index]
            //                                   ['location_type'],
            //                               style: const TextStyle(
            //                                 color: kindaBlack,
            //                                 fontSize: 13,
            //                                 fontFamily: 'MonB',
            //                               ),
            //                             ),
            //                             Text(
            //                               snapshot.data![index]['address'],
            //                               maxLines: 1,
            //                               style: const TextStyle(
            //                                 color: kindaBlack,
            //                                 fontSize: 10,
            //                                 fontFamily: 'MonM',
            //                               ),
            //                               overflow: TextOverflow.ellipsis,
            //                             )
            //                           ],
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           );
            //         }),
            //       );
            //     }),
            // Divider(),
            // SizedBox(
            //   height: 10,
            // ),

            ///==============================OLD CODE===================///
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: predictions.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       leading: CircleAvatar(
            //         child: Icon(
            //           Icons.pin_drop,
            //           color: Colors.white,
            //         ),
            //       ),
            //       title: Text(predictions[index].description!),
            //       onTap: () async {
            //         debugPrint(predictions[index].placeId);
            //         // print(" Distance Meters------------> " +
            //         //     predictions[index].distanceMeters.toString() +
            //         //     "<------------Distance Meters");
            //         // print(predictions[index]);
            //         // setState(() {
            //         //   pickAdd = predictions[index].description!;
            //         // });
            //         List<geoCode.Location> locations = await geoCode
            //             .locationFromAddress(predictions[index].description!);

            //         print(locations[0].latitude);
            //         print(locations[0].longitude);

            //         setState(() {
            //           dropadd = predictions[index].description!;
            //           dropLat = locations[0].latitude;
            //           dropLong = locations[0].longitude;
            //           // pickLat = predictions[index].
            //         });
            //         getValidZones(context);

            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => RideConfirm(
            //         dropLocation: predictions[index].description!,
            //       ),
            //     ));
            //         // Navigator.pop(context);
            //         // Navigator.push(
            //         //   context,
            //         //   MaterialPageRoute(
            //         //     builder: (context) => DetailsPage(
            //         //       placeId: predictions[index].placeId,
            //         //       googlePlace: googlePlace,
            //         //     ),X
            //         //   ),
            //         // );
            //       },
            //     );
            //   },
            // ),
            ///============================OLD CODE========================///
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: locationssssD.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.pin_drop,
                      color: Colors.red,
                    ),
                    // CircleAvatar(
                    //   child: Icon(
                    //     Icons.pin_drop,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    title: Text(locationssssD[index]['location']),
                    onTap: () async {
                      // debugPrint(predictions[index].placeId);

                      // List<geoCode.Location> locations = await geoCode
                      //     .locationFromAddress(predictions[index].description!);

                      // print(locations[0].latitude);
                      // print(locations[0].longitude);

                      // ignore: use_build_context_synchronously
                      // userUpdateLocation(
                      //     locationssss[index]['latitude'].toString(),
                      //     locationssss[index]['longitude'].toString(),
                      //     context);

                      setState(() {
                        //  dropadd = predictions[index].description!;
                        // dropLat = locations[0].latitude;
                        // dropLong = locations[0].longitude;
                        dropadd = locationssssD[index]['location'];
                        dropLat = locationssssD[index]['latitude'];
                        dropLong = locationssssD[index]['longitude'];
                        // pickAddIdd = locationssssD[index]['id'].toString();
                        // pickLat = predictions[index].
                      });

                      getValidZones(context);

                      getDistance();

                      // getDistance();

                      // Fluttertoast.showToast(
                      //     msg: locations[0]["Latitude"] as );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailsPage(
                      //       placeId: predictions[index].placeId,
                      //       googlePlace: googlePlace,
                      //     ),
                      //   ),
                      // );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
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
    // var lat = result.
    if (result != null && result.predictions != null && mounted) {
      // var lati = result.predictions.l
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}


/*

 Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideConfirm(
                        dropLocation: 'Kothapet, Fruit Market',
                      ),
                    ));

 */