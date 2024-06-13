import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/map_styles.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/widgets/coupons_list.dart';

class MapSample extends StatefulWidget {
  MapSample({
    Key? key,
  }) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? mapController;
  final LatLng _start = LatLng(pickLat, pikLong);
  final LatLng _end = LatLng(dropLat, dropLong);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final Set<Polyline> _shadowPolylines = {};

  int loss = 0;

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _setPolylines();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loss = 1;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.setMapStyle(mapStyle);
  }

  void _setMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('start_marker'),
        position: _start,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Start'),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('end_marker'),
        position: _end,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: 'End'),
      ),
    );
  }

  void _setPolylines() {
    List<LatLng> elevatedPolylineCoordinates = _getElevatedPolylineCoordinates([
      _start,
      _end,
    ]);

    List<LatLng> shadowPolylineCoordinates = elevatedPolylineCoordinates
        .map((point) =>
            LatLng(point.latitude + 0.0002, point.longitude + 0.0002))
        .toList();

    _polylines.add(
      Polyline(
        polylineId: PolylineId('polyline_1'),
        points: elevatedPolylineCoordinates,
        width: 2,
        color: Colors.black,
      ),
    );

    _shadowPolylines.add(
      Polyline(
        polylineId: PolylineId('shadow_polyline_1'),
        points: shadowPolylineCoordinates,
        width: 2,
        color: Colors.black.withOpacity(0.3),
      ),
    );
  }

  List<LatLng> _getElevatedPolylineCoordinates(List<LatLng> points) {
    const double elevation =
        0.0900; // Adjust this value to increase or decrease elevation
    List<LatLng> elevatedPoints = [];
    for (int i = 0; i < points.length - 1; i++) {
      elevatedPoints.add(points[i]);
      LatLng midPoint = LatLng(
          (points[i].latitude + points[i + 1].latitude) / 2,
          (points[i].longitude + points[i + 1].longitude) / 2);
      elevatedPoints
          .add(LatLng(midPoint.latitude, midPoint.longitude + elevation));
    }
    elevatedPoints.add(points.last);
    return elevatedPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _start,
              zoom: 6.0,
            ),
            markers: _markers,
            polylines: {..._shadowPolylines, ..._polylines},
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 7, top: 10, right: 7.0),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.2), //color of shadow
                            spreadRadius: 1, //spread radius
                            blurRadius: 1, // blur radius
                            offset: Offset(2, 2), // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.2), //color of shadow
                            spreadRadius: 1, //spread radius
                            blurRadius: 1, // blur radius
                            offset:
                                Offset(-2, -2), // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          //you can set more BoxShadow() here
                        ],
                        borderRadius: BorderRadius.circular(90),
                        color: white,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 7, top: 10, right: 7.0, bottom: 10.0),
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(2, 2), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), //color of shadow
                        spreadRadius: 1, //spread radius
                        blurRadius: 1, // blur radius
                        offset: Offset(-2, -2), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      ),
                      //you can set more BoxShadow() here
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: loss == 1
                      ? Column(
                          children: [
                            Image.asset(
                              'assets/images/luggage.gif',
                              height: 150,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "$dropadd",
                              style: TextStyle(
                                color: black,
                                fontFamily: 'MonM',
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Is an outstation ride. No partners are available for the selected destination",
                              style: TextStyle(
                                color: black,
                                fontFamily: 'MonR',
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/taxi_anim.gif',
                              height: 150,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 2,
                              width: double.infinity,
                              child: LinearProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Searching.. Please wait!",
                              style: TextStyle(
                                color: black,
                                fontFamily: 'MonM',
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
