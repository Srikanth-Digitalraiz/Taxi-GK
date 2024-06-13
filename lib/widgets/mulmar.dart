import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MultipleMarkers extends StatefulWidget {
  @override
  _MultipleMarkersState createState() => _MultipleMarkersState();
}

class _MultipleMarkersState extends State<MultipleMarkers> {
  Uint8List? custMar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customMarker();
  }

  void customMarker() async {
    Uint8List bytes = (await NetworkAssetBundle(
                Uri.parse('https://i.postimg.cc/zfjMX1Hd/unnamed-1.png'))
            .load("https://i.postimg.cc/zfjMX1Hd/unnamed-1.png"))
        .buffer
        .asUint8List();

    setState(() {
      custMar = bytes;
    });
  }

  GoogleMapController? mapController; //contrller for Google map
  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation =
      const LatLng(27.7089427, 85.3086209); //location to show in map

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiple Markers in Google Map"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: showLocation, //initial position
          zoom: 15.0, //initial zoom level
        ),
        markers: getmarkers(), //markers to show on map
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        // icon: BitmapDescriptor.defaultMarker, //Icon for Marker

        icon: BitmapDescriptor.fromBytes(
          custMar!,
        ),
      ));

      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(27.7099116, 85.3132343), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Second ',
          snippet: 'My Custom Subtitle',
        ),
        // icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        icon: BitmapDescriptor.fromBytes(
          custMar!,
        ),
      ));

      markers.add(
        Marker(
          //add third marker
          markerId: MarkerId(showLocation.toString()),
          position: LatLng(27.7137735, 85.315626), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: 'Marker Title Third ',
            snippet: 'My Custom Subtitle',
          ),
          // icon: BitmapDescriptor.defaultMarker, //Icon for Marker
          icon: BitmapDescriptor.fromBytes(
            custMar!,
          ),
        ),
      );

      //add more markers here
    });

    return markers;
  }
}
