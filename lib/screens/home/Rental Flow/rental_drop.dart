import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/screens/home/Ride%20Confirm/confirmride.dart';
import 'package:geocoding/geocoding.dart' as geoCode;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/apiconstants.dart';

class SearchRentalDropLocation extends StatefulWidget {
  SearchRentalDropLocation({Key? key}) : super(key: key);

  @override
  State<SearchRentalDropLocation> createState() =>
      _SearchRentalDropLocationState();
}

class _SearchRentalDropLocationState extends State<SearchRentalDropLocation> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    // String apiKey = Google_Maps_API;
    // String apiKey = DotEnv().env['AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM']!;
    // googlePlace = GooglePlace(apiKey);
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
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 3,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: kindaBlack),
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'searchdest'.tr,
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
            //         print(" Distance Meters------------> " +
            //             predictions[index].distanceMeters.toString() +
            //             "<------------Distance Meters");
            //         print(predictions[index]);
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
            // Navigator.pop(context);
            //         // Navigator.pushReplacement(
            //         //     context,
            //         //     MaterialPageRoute(
            //         //       builder: (context) => RideConfirm(
            //         //         dropLocation: predictions[index].description!,
            //         //       ),
            //         //     ));
            //         // Navigator.pop(context);
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
            ListView.separated(
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
                    Navigator.pop(context);

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
            // Container(
            //   margin: EdgeInsets.only(top: 10, bottom: 10),
            //   child: Image.asset("assets/icons/powered_by_google.png"),
            // ),
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