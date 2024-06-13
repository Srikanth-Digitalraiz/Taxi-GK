import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/current_location.dart';
import 'package:ondeindia/global/pickup_location.dart';

import '../../../global/map_styles.dart';

class PinAddress extends StatefulWidget {
  @override
  _PinAddressState createState() => _PinAddressState();
}

class _PinAddressState extends State<PinAddress> {
  String googleApikey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(currentLat, currentLong);
  String location = "Location Name:";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Longitude Latitude Picker in Google Map"),
          backgroundColor: primaryColor,
        ),
        body: Stack(children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 17.0, //initial zoom level
            ),
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
                mapController!.setMapStyle(mapStyle);
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona; //when map is dragging
            },
            onCameraIdle: () async {
              //when map drag stops
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude);
              setState(() {
                mapController!.setMapStyle(mapStyle);
                //get place name from lat and lang
                location = placemarks.first.street.toString() +
                    ", " +
                    placemarks.first.name.toString() +
                    "," +
                    placemarks.first.subLocality.toString() +
                    "," +
                    placemarks.first.locality.toString() +
                    "," +
                    placemarks.first.postalCode.toString() +
                    "," +
                    placemarks.first.country.toString();
              });
              Fluttertoast.showToast(
                  msg: cameraPosition!.target.latitude.toStringAsFixed(4) +
                      "    " +
                      cameraPosition!.target.longitude.toStringAsFixed(4) +
                      "    " +
                      placemarks.first.postalCode.toString());
            },
          ),
          Center(
            //picker image on google map
            child: Image.asset(
              "assets/images/picker.png",
              width: 80,
            ),
          ),
          Positioned(
              //widget to display location name
              bottom: 100,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/images/picker.png",
                          width: 25,
                        ),
                        title: Text(
                          location,
                          style: TextStyle(fontSize: 18),
                        ),
                        dense: true,
                      )),
                ),
              ))
        ]));
  }
}
