import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/screens/home/Outstation%20Flow/outstation_ride.dart';

import 'dart:math';

import '../../../global/distance.dart';
import '../../../global/google_key.dart';
import '../../../global/map_styles.dart';
import '../../../global/pickup_location.dart';

class OutStationRideConfirm extends StatefulWidget {
  OutStationRideConfirm({Key? key}) : super(key: key);

  @override
  State<OutStationRideConfirm> createState() => _OutStationRideConfirmState();
}

class _OutStationRideConfirmState extends State<OutStationRideConfirm> {
  int _selected = 0;
  int _vehicleSelected = 1;
  bool _smoke = true;
  bool _pets = false;
  bool _disabled = false;
  bool _airCondition = true;
  bool _extraLuggage = false;
  bool _child = true;
  int filterVal = 1;
  String cab = '';

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  // BitmapDescriptor? pickup = BitmapDescriptor;

  // BitmapDescriptor? drop;

  // void setCustomePickMarker() async {
  //   pickup = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), 'assets/images/pickupmarker.png');
  // }

  String googleAPiKey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  // LatLng startLocation = LatLng(27.6683619, 85.3101895);

  LatLng startLocation = LatLng(pickLat, pikLong);
  LatLng endLocation = LatLng(dropLat, dropLong);

  @override
  void initState() {
    // setCustomePickMarker();
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'PickUp Location ',
        snippet: pickAdd + "  ",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen), //Icon for Marker
      // icon: pickup
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Drop Location ',
        snippet: dropadd + "  ",
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      gooAPIKey,
      // PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(pickLat, pikLong),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    addPolyLine(polylineCoordinates);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  //Out Booking

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.4,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>[
                          new Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        ].toSet(),
                        //Map widget from google_maps_flutter package
                        zoomGesturesEnabled: true, //enable Zoom in, out on map
                        initialCameraPosition: CameraPosition(
                          //innital position in map
                          target: startLocation, //initial position
                          zoom: 12.0, //initial zoom level
                        ),
                        markers: markers, //markers to show on map
                        polylines:
                            Set<Polyline>.of(polylines.values), //polylines
                        mapType: MapType.normal, //map type
                        onMapCreated: (controller) {
                          //method called when map is created
                          setState(() {
                            mapController = controller;
                            mapController!.setMapStyle(mapStyle);
                          });
                        },
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                            child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                                child: Text(
                                    "Distance: " +
                                        distance.toStringAsFixed(2) +
                                        " KM",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold))),
                          ),
                        )))
                  ],
                ),
                OutStationRide(),
                // SingleChildScrollView(
                //   child: Column(
                //     children: [

                //       _vehicleDetails(),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          SafeArea(
            child: Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(top: 10, left: 10),
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
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                onPressed: () {
                  // widget.zoomDrawerController.toggle();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: 100,
          //     color: whiteColor,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Divider(),
          //         Row(
          //           children: [
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   showModalBottomSheet<void>(
          //                     isScrollControlled: true,
          //                     backgroundColor: Colors.transparent,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(20),
          //                     ),
          //                     context: context,
          //                     builder: (BuildContext context) {
          //                       return Padding(
          //                         padding: MediaQuery.of(context).viewInsets,
          //                         child: PaymentSelection(),
          //                       );
          //                     },
          //                   );
          //                 },
          //                 child: Container(
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Image.asset(
          //                         'assets/images/googlepay.png',
          //                         height: 20,
          //                         width: 30,
          //                       ),
          //                       SizedBox(
          //                         width: 5,
          //                       ),
          //                       Text(
          //                         "Google Pay",
          //                         style: TextStyle(
          //                           fontFamily: 'MonM',
          //                           fontSize: 12,
          //                           color: Colors.black,
          //                         ),
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Container(
          //               height: 15,
          //               width: 1,
          //               color: Colors.black.withOpacity(0.3),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Expanded(
          //               child: InkWell(
          //                 onTap: () {
          //                   // cuponCode
          //                   showModalBottomSheet<void>(
          //                     isScrollControlled: true,
          //                     backgroundColor: Colors.transparent,
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(20),
          //                     ),
          //                     context: context,
          //                     builder: (BuildContext context) {
          //                       return Padding(
          //                         padding: MediaQuery.of(context).viewInsets,
          //                         child: cuponCode(
          //                           context,
          //                         ),
          //                       );
          //                     },
          //                   );
          //                 },
          //                 child: Container(
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Image.asset('assets/icons/tag.png',
          //                           height: 20,
          //                           width: 30,
          //                           color: Colors.green.shade700),
          //                       SizedBox(
          //                         width: 5,
          //                       ),
          //                       Text(
          //                         "Coupon",
          //                         style: TextStyle(
          //                           fontFamily: 'MonM',
          //                           fontSize: 12,
          //                           color: Colors.black,
          //                         ),
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Container(
          //               height: 15,
          //               width: 1,
          //               color: Colors.black.withOpacity(0.3),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //             Expanded(
          //               child: Container(
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Icon(Icons.person),
          //                     SizedBox(
          //                       width: 5,
          //                     ),
          //                     Text(
          //                       "My Self",
          //                       style: TextStyle(
          //                         fontFamily: 'MonM',
          //                         fontSize: 12,
          //                         color: Colors.black,
          //                       ),
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //             SizedBox(
          //               width: 7,
          //             ),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Container(
          //           width: MediaQuery.of(context).size.width,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(0),
          //             color: Colors.black,
          //           ),
          //           child: InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => BookRideSection(),
          //                 ),
          //               );
          //             },
          //             child: Center(
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
          //                 child: Text(
          //                   "Select Ride",
          //                   style: TextStyle(
          //                     fontFamily: 'MonS',
          //                     fontSize: 17,
          //                     color: whiteColor,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
