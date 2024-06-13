// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:ondeindia/constants/color_contants.dart';
// import 'package:ondeindia/global/current_location.dart';
// import 'package:ondeindia/global/pickup_location.dart';
// import 'package:simple_ripple_animation/simple_ripple_animation.dart';

// import '../../../../global/map_styles.dart';
// import '../../home_screen.dart';

// class PickPinAddress extends StatefulWidget {
//   @override
//   _PickPinAddressState createState() => _PickPinAddressState();
// }

// class _PickPinAddressState extends State<PickPinAddress> {
//   String googleApikey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   LatLng startLocation = LatLng(currentLat, currentLong);
//   String location = "Location Name:";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pick Up Location"),
//         backgroundColor: primaryColor,
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             //Map widget from google_maps_flutter package
//             zoomGesturesEnabled: true, //enable Zoom in, out on map
//             initialCameraPosition: CameraPosition(
//               //innital position in map
//               target: startLocation, //initial position
//               zoom: 17.0, //initial zoom level
//             ),
//             mapType: MapType.normal, //map type
//             onMapCreated: (controller) {
//               //method called when map is created
//               setState(() {
//                 mapController = controller;
//                 mapController!.setMapStyle(mapStyle);
//               });
//             },
//             onCameraMove: (CameraPosition cameraPositiona) {
//               cameraPosition = cameraPositiona; //when map is dragging
//             },
//             onCameraIdle: () async {
//               //when map drag stops
//               List<Placemark> placemarks = await placemarkFromCoordinates(
//                   cameraPosition!.target.latitude,
//                   cameraPosition!.target.longitude);
//               setState(() {
//                 mapController!.setMapStyle(mapStyle);
//                 //get place name from lat and lang
//                 location = placemarks.first.street.toString() +
//                     ", " +
//                     placemarks.first.name.toString() +
//                     "," +
//                     placemarks.first.subLocality.toString() +
//                     "," +
//                     placemarks.first.locality.toString() +
//                     "," +
//                     placemarks.first.postalCode.toString() +
//                     "," +
//                     placemarks.first.country.toString();
//               });
//               // Fluttertoast.showToast(
//               //     msg: cameraPosition!.target.latitude.toStringAsFixed(4) +
//               //         "    " +
//               //         cameraPosition!.target.longitude.toStringAsFixed(4) +
//               //         "    " +
//               //         placemarks.first.postalCode.toString());
//             },
//           ),
//           Center(
//             //picker image on google map
//             child: Image.asset(
//               "assets/images/startmark.png",
//               width: 20,
//             ),
//           ),
//           RippleAnimation(
//             delay: Duration(milliseconds: 2000),
//             repeat: true,
//             color: kindaBlack.withOpacity(0.5),
//             minRadius: 65,
//             ripplesCount: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                       padding: EdgeInsets.all(0),
//                       width: MediaQuery.of(context).size.width,
//                       child: ListTile(
//                         leading: Image.asset(
//                           "assets/images/startmark.png",
//                           width: 25,
//                         ),
//                         title: Text(
//                           location,
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         dense: true,
//                       )),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 12),
//             child: Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 height: 80,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     color: kindaBlack, borderRadius: BorderRadius.circular(5)),
//                 child: TextButton(
//                   onPressed: () async {
//                     setState(() {
//                       pickAdd = location;
//                       pickLat = cameraPosition!.target.latitude;
//                       pikLong = cameraPosition!.target.longitude;
//                     });
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => HomeScreen(),
//                       ),
//                     );
//                   },
//                   child: Center(
//                     child: Text(
//                       "Confirm PickUp Point",
//                       style: TextStyle(
//                         fontFamily: 'MonB',
//                         fontSize: 15,
//                         color: whiteColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
