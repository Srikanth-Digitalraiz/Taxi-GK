import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geoCode;
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
// import 'package:google_place/google_place.dart';
import 'package:ondeindia/constants/apiconstants.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/main.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/home/widget/search_pickup/pickup_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../global/admin_id.dart';
import '../../../../global/data/user_data.dart';
import '../../../../global/google_key.dart';
import '../../../../global/service_scr.dart';

class SearchPickUp extends StatefulWidget {
  SearchPickUp({Key? key}) : super(key: key);

  @override
  State<SearchPickUp> createState() => _SearchPickUpState();
}

class _SearchPickUpState extends State<SearchPickUp> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  TextEditingController loccc = TextEditingController();

  @override
  void initState() {
    String apiKey = Google_Maps_API;
    // String apiKey = DotEnv().env['AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM']!;
    googlePlace = GooglePlace(gooAPIKey);
    super.initState();
  }

  Future userUpdateLocation(String liveLat, String liveLong, context) async {
    print(packageversion);
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userToken = _sharedData.getString('maintoken');
    const String apiUrl = updateLocations;
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer ${userToken!}"},
      body: {
        "latitude": liveLat,
        "longitude": liveLong,
        'admin_id': adminId,
        'versionName': packageversion.toString(),
        "fcm_token": fcmTokenAuth
      },
    );

    print("==============================");
    debugPrint('$liveLat --  $liveLong -- $adminId -- $packageversion');
    print("Location Status " + response.statusCode.toString());

    print("==============================");

    if (response.statusCode == 200) {
      debugPrint(jsonDecode(response.body).toString());

      int mainVal = jsonDecode(response.body)['zone_id'];

      if (mainVal > 0) {
        setState(() {
          serviceAvai = true;
        });
      } else {
        setState(() {
          serviceAvai = false;
        });
      }
      Navigator.pop(context);
    } else {
      debugPrint(jsonDecode(response.body));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Material(
      //       elevation: 3,
      //       shape:
      //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       child: Container(
      //         height: 60,
      //         decoration: BoxDecoration(
      //             color: primaryColor, borderRadius: BorderRadius.circular(10)),
      //         child: const Center(
      //             child: Text(
      //           "System encountered Issue while processing your request.",
      //           textAlign: TextAlign.center,
      //         )),
      //       ),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //   ),
      // );
    }
  }

  List locationssss = [];

  Future getLocationsList(querrr) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    String? userToken = _sharedData.getString('maintoken');
    var headers = {'Authorization': 'Bearer $userToken'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://ondeindia.com/api/user/search'));
    request.fields.addAll({
      'id': '0',
      'search': '$querrr',
      'type': '0',
      'location': '',
      'latitude': '',
      'longitude': ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        locationssss = decodedMap['data'];
      });
      print(locationssss);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 3,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: kindaBlack),
        title: TextField(
          controller: loccc,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: 'pickLoc'.tr
                  // suffixIcon: IconButton(
                  //   onPressed: () {
                  //     Fluttertoast.showToast(msg: pickAdd);
                  //   },
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
      body: SingleChildScrollView(
        child: Column(
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
            //               onTap: () async {
            //                 String _address = snapshot.data![index]['address'];
            //                 double lat =
            //                     double.parse(snapshot.data![index]['latitude']);
            //                 double long = double.parse(
            //                     snapshot.data![index]['longitude']);
            //                 // Fluttertoast.showToast(msg: '$long');
            //                 setState(() {
            //                   pickAdd = _address;
            //                   pickLat = lat;
            //                   pikLong = long;
            //                   // pickLat = predictions[index].
            //                 });
            //                 Navigator.pop(context);
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
            //                         padding: const EdgeInsets.only(left: 12.0),
            //                         child: Icon(
            //                           snapshot.data![index]['location_type'] ==
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
            //============================OLD CODE============================//
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

            //         List<geoCode.Location> locations = await geoCode
            //             .locationFromAddress(predictions[index].description!);

            //         print(locations[0].latitude);
            //         print(locations[0].longitude);

            //         // ignore: use_build_context_synchronously
            //         userUpdateLocation(locations[0].latitude.toString(),
            //             locations[0].longitude.toString(), context);

            //         setState(() {
            //           pickAdd = predictions[index].description!;
            //           pickLat = locations[0].latitude;
            //           pikLong = locations[0].longitude;
            //           // pickLat = predictions[index].
            //         });

            //         // Fluttertoast.showToast(
            //         //     msg: locations[0]["Latitude"] as );

            //         // Navigator.push(
            //         //   context,
            //         //   MaterialPageRoute(
            //         //     builder: (context) => DetailsPage(
            //         //       placeId: predictions[index].placeId,
            //         //       googlePlace: googlePlace,
            //         //     ),
            //         //   ),
            //         // );
            //       },
            //     );
            //   },
            // ),
//============================OLD CODE============================//
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: locationssss.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.pin_drop,
                    color: Colors.green,
                  ),
                  // CircleAvatar(
                  //   child: Icon(
                  //     Icons.pin_drop,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  title: Text(locationssss[index]['location']),
                  onTap: () async {
                    // debugPrint(predictions[index].placeId);

                    // List<geoCode.Location> locations = await geoCode
                    //     .locationFromAddress(predictions[index].description!);

                    // print(locations[0].latitude);
                    // print(locations[0].longitude);

                    // ignore: use_build_context_synchronously
                    userUpdateLocation(
                        locationssss[index]['latitude'].toString(),
                        locationssss[index]['longitude'].toString(),
                        context);

                    setState(() {
                      pickAdd = locationssss[index]['location'];
                      pickLat = locationssss[index]['latitude'];
                      pikLong = locationssss[index]['longitude'];
                      pickAddIdd = locationssss[index]['id'].toString();
                      // pickLat = predictions[index].
                    });

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
            // SizedBox(
            //   height: 60,
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => PickPinAddress(),
            //       ),
            //     );
            //   },
            //   child: Container(
            //     height: 50,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: primaryColor.withOpacity(0.4),
            //         width: 3,
            //       ),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "Select PickUp on Map",
            //         style: const TextStyle(
            //           color: kindaBlack,
            //           fontSize: 13,
            //           fontFamily: 'MonB',
            //         ),
            //       ),
            //     ),
            //   ),
            // )
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
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 10,
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Image.asset("assets/icons/powered_by_google.png"),
        ),
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
