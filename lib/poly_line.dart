import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/current_location.dart';
import 'package:ondeindia/global/pickup_location.dart';

import 'global/google_key.dart';

class PolyLine extends StatefulWidget {
  PolyLine({Key? key}) : super(key: key);

  @override
  State<PolyLine> createState() => _PolyLineState();
}

class _PolyLineState extends State<PolyLine> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  //Mentioning your Cuttent Location and Destination location below will hlp you show Poly lines

  LatLng startLocation = LatLng(currentLat, currentLong);
  LatLng endLocation = LatLng(52.3637, 4.8821);

  // String googleAPiKey = "AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM";

  @override
  void initState() {
    markers.add(Marker(
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker

      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen), //Icon for Marker
      // icon: pickup
    ));

    markers.add(Marker(
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker

      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections();
    _eta(); //fetch direction polylines from Google API

    super.initState();
  }

  String eta = "";

//To get ETA for Start and End Location
  _eta() async {
    Dio dio = Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$currentLat,$currentLong&destinations=52.3637,4.8821&key=$gooAPIKey");
    print(response.data.toString());
    setState(() {
      eta = response.data['rows'][0]['elements'][0]['duration']['text']
          .toString();
    });
  }

  //TO get Shorted direction from start point to end point

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
    addPolyLine(polylineCoordinates);
  }

  //Adding poly line to our Location and destination

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: startLocation, //initial position
              zoom: 16.0, //initial zoom level
            ),
            markers: markers, //markers to show on map
            polylines: Set<Polyline>.of(polylines.values), //polylines
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: kindaBlack,
              ),
              child: Center(
                child: Text(
                  eta,
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
