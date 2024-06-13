import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geoCode;
import 'package:google_place/google_place.dart';
import 'package:ondeindia/constants/apiconstants.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/home/widget/search_pickup/pickup_map.dart';

import '../../../global/google_key.dart';

class OutStationPickUp extends StatefulWidget {
  OutStationPickUp({Key? key}) : super(key: key);

  @override
  State<OutStationPickUp> createState() => _OutStationPickUpState();
}

class _OutStationPickUpState extends State<OutStationPickUp> {
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
              hintText: 'Search PickUp...',
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
              //                 // String _address =
              //                 //     snapshot.data![index]['address'];
              //                 // double lat = double.parse(
              //                 //     snapshot.data![index]['latitude']);
              //                 // double long = double.parse(
              //                 //     snapshot.data![index]['longitude']);
              //                 // setState(() {
              //                 //   pickAdd = _address;
              //                 //   pickLat = lat;
              //                 //   pikLong = long;
              //                 //   // pickLat = predictions[index].
              //                 // });
              //                 // Navigator.pop(context);
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
                      // debugPrint(predictions[index].placeId);

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

                      Navigator.pop(context);
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
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset("assets/icons/powered_by_google.png"),
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
        ));
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
