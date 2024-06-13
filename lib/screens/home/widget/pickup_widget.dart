import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ondeindia/global/pickup_location.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/home/test/test.dart';
import 'package:ondeindia/screens/home/widget/search_pickup/searchpickup.dart';
import 'package:ondeindia/screens/home/widget/searchdroplocation.dart';

import '../../../constants/color_contants.dart';
import '../../../widgets/loder_dialg.dart';

class PickUp extends StatefulWidget {
  PickUp({Key? key}) : super(key: key);

  @override
  State<PickUp> createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  TextEditingController _favLocation = TextEditingController();
  @override
  void initState() {
    super.initState();
    _locations();
    // _getGeoLocationPosition();
    // GetAddressFromLatLong();
  }

  double lat = 0.0;
  double long = 0.0;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  String Address = 'search';

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    // lat = position.latitude;
    // long = position.longitude;
    Address =
        '${place.name}, ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    pickAdd =
        '${place.name}, ${place.street},  ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  void _locations() async {
    Position position = await _getGeoLocationPosition();
    // var location = '${position.latitude} ,  ${position.longitude}';
    pickLat = position.latitude;
    pikLong = position.longitude;
    // var _locationsLat = position.latitude;
    // var _locationsLong = position.longitude;
    GetAddressFromLatLong(position);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPickUp(),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
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
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), //color of shadow
                spreadRadius: 1, //spread radius
                blurRadius: 2, // blur radius
                offset: Offset(2, 0), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
              //you can set more BoxShadow() here
            ],
            borderRadius: BorderRadius.circular(70),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.green,
                  size: 18,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    pickAdd,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'MonM',
                      fontSize: 10,
                      color: kindaBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // SizedBox(width: 5),
                // InkWell(
                //     onTap: () {
                //       _displayTextInputDialog(context, pickAdd);
                //       // Navigator.push(
                //       //   context,
                //       //   MaterialPageRoute(
                //       //     builder: (context) => SearchPickUp(),
                //       //   ),
                //       // );
                //     },
                //     child: Icon(
                //       Icons.favorite_outline,
                //       color: Colors.green,
                //       size: 18,
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String _address) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            title: Text('Add Favourite...'),
            content: Container(
              height: MediaQuery.of(context).size.height / 4.0,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: primaryColor.withOpacity(0.4)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Address: ",
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'MonR',
                                    fontSize: 12,
                                    color: kindaBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    _address,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'MonM',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _favLocation,
                                decoration: InputDecoration(
                                    hintText: "Please name your Favorite..."),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          String _locationtype = _favLocation.text;
                          showLoaderDialog(
                              context, "Adding data to Database...", 15);
                          addFavLocation(context, _locationtype, _address,
                              pickLat.toString(), pikLong.toString());
                          Navigator.pop(context);
                        },
                        child: Text("Add Favroite."),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
