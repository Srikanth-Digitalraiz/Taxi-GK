import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/map_styles.dart';

class TestMap extends StatefulWidget {
  TestMap({Key? key}) : super(key: key);

  @override
  State<TestMap> createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  static const _initalCamPos = CameraPosition(
      target: LatLng(
        37.773972,
        -122.431297,
      ),
      zoom: 11.8);
  late GoogleMapController _googleMapController;
  Marker? origin;
  Marker? destination;
  @override
  void dispose() {
    _googleMapController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Google Maps"),
        actions: [
          if (origin != null)
            TextButton(
              onPressed: () {
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: origin!.position,
                    zoom: 14.5,
                    tilt: 50,
                  ),
                );
                // _googleMapController.animateCamera(

                // );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontWeight: FontWeight.w500),
              ),
              child: Text("Origin"),
            ),
          if (destination != null)
            TextButton(
              onPressed: () {
                // _googleMapController.animateCamera(

                // );
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: destination!.position,
                    zoom: 14.5,
                    tilt: 50,
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontWeight: FontWeight.w500),
              ),
              child: Text("Destination"),
            ),
        ],
      ),
      body: GoogleMap(
        mapType: MapType.satellite,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initalCamPos,
        markers: {
          if (origin != null) origin!,
          if (destination != null) destination!
        },
        onLongPress: _addMarker,
        onMapCreated: (controller) {
          _googleMapController = controller;
          _googleMapController.setMapStyle(mapStyle);
        },
        //mapController!.setMapStyle(mapStyle);
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await _googleMapController
          //     .animateCamera();
          CameraUpdate.newCameraPosition(_initalCamPos);
        },
        child: Center(
          child: Icon(Icons.center_focus_strong),
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    if (origin == null || (origin != null && destination != null)) {
      setState(() {
        origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          position: pos,
        );
        destination = null;
      });
    } else {
      setState(() {
        destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta),
          position: pos,
        );
      });
    }
  }
}
