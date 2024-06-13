import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/screens/bookride/cancel_ride_opt.dart';

import '../../constants/color_contants.dart';
import '../../widgets/tripsdetails.dart';
import '../driver_details/driver_details.dart';

class onGoinTrips extends StatefulWidget {
  onGoinTrips({Key? key}) : super(key: key);

  @override
  State<onGoinTrips> createState() => _onGoinTripsState();
}

class _onGoinTripsState extends State<onGoinTrips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: kindaBlack),
        title: Text(
          "ypuRi".tr,
          // "ongoing".tr,
          style: TextStyle(
            color: kindaBlack,
            fontSize: 15,
            fontFamily: 'MonM',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _getTrips()
              // child: FutureBuilder(
              //   future: getOnGoingTrips(context),
              //   builder: (context, AsyncSnapshot<List> snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Center(
              //         child: SizedBox(
              //           height: 30,
              //           width: 30,
              //           child: CircularProgressIndicator(
              //             backgroundColor: kindaBlack,
              //             color: primaryColor,
              //           ),
              //         ),
              //       );
              //     }

              //     if (snapshot.data!.isEmpty) {
              //       return Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             LottieBuilder.asset(
              //               'assets/animation/empty.json',
              //               height: 120,
              //               width: 120,
              //             ),
              //             Text(
              //               "noonride".tr,
              //               style: TextStyle(
              //                 color: kindaBlack,
              //                 fontSize: 15,
              //                 fontFamily: 'MonM',
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //     return ListView.builder(
              //       itemBuilder: (context, index) {
              //         var date = snapshot.data![index]['schedule_at']
              //             .toString()
              //             .split(" ");

              //         var date1 = date[0].toString();
              //         var time1 = date[1].toString();
              //         final tripID =
              //             snapshot.data![index]['booking_id'].toString();
              //         final paidFare =
              //             snapshot.data![index]['final_fare'].toString();
              //         final locationfromAddress =
              //             snapshot.data![index]['s_address'].toString();
              //         final locationtoAddress =
              //             snapshot.data![index]['d_address'].toString();
              //         final vehModel =
              //             snapshot.data![index]['servicetype'].toString();

              //         final driverName = snapshot.data![index]['provider']
              //                 ['first_name']
              //             .toString();
              //         final driverEmail =
              //             snapshot.data![index]['provider']['email'].toString();
              //         final driverMobile =
              //             snapshot.data![index]['provider']['mobile'].toString();
              //         final driverRate =
              //             snapshot.data![index]['provider']['rating'].toString();
              //         String driverID =
              //             snapshot.data![index]['provider']['id'].toString();
              //         final vehicleNumber = snapshot.data![index]
              //                 ['provider_service']['service_number']
              //             .toString();
              //         final vehicleName =
              //             snapshot.data![index]['servicename'].toString();
              //         final driveimage =
              //             'http://ondeindia.com/storage/app/public/' +
              //                 snapshot.data![index]['provider']['avatar']
              //                     .toString();
              //         final staLat =
              //             snapshot.data![index]['s_latitude'].toString();
              //         final staLong =
              //             snapshot.data![index]['s_longitude'].toString();
              //         final droLat =
              //             snapshot.data![index]['d_latitude'].toString();
              //         final droLong =
              //             snapshot.data![index]['d_longitude'].toString();
              //         final pay =
              //             snapshot.data![index]['payment_mode'].toString();
              //         final reID = snapshot.data![index]['id'].toString();
              //         return Padding(
              //           padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              //           child: InkWell(
              //             onTap: () {
              //               // Fluttertoast.showToast(msg: vehicleNumber.toString());
              // Navigator.pushReplacement(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => DriverDetails(
              //       bookID: tripID,
              //       stAdd: locationfromAddress,
              //       stLat: staLat,
              //       requeID: reID,
              //       stLong: staLong,
              //       drAdd: locationtoAddress,
              //       drLat: droLat,
              //       estFare: paidFare,
              //       drLong: droLong,
              //       driName: driverName,
              //       driEmail: driverEmail,
              //       driMobile: driverMobile,
              //       driRate: driverRate,
              //       driImage: driveimage,
              //       vehiNum: vehicleNumber,
              //       vehName: vehicleName,
              //       vehMod: vehModel,
              //       paymode: pay,
              //       driID: driverID,
              //       requestIDS: reID,
              //     ),
              //   ),
              // );
              //             },
              //             child: Column(
              //               children: [
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       date1,
              //                       style: const TextStyle(
              //                         fontFamily: 'MonR',
              //                         fontSize: 13,
              //                         color: Colors.black,
              //                       ),
              //                     ),
              //                     Spacer(),
              //                     Text(
              //                       time1,
              //                       style: const TextStyle(
              //                         fontFamily: 'MonR',
              //                         fontSize: 12,
              //                         color: Colors.black,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height: 11,
              //                 ),
              //                 Card(
              //                   elevation: 4,
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                   child: Container(
              //                     height: 151,
              //                     width: MediaQuery.of(context).size.width,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceEvenly,
              //                         children: [
              //                           Row(
              //                             children: [
              //                               Expanded(
              //                                 child: Row(
              //                                   children: [
              //                                     Card(
              //                                       shape: RoundedRectangleBorder(
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 40),
              //                                       ),
              //                                       child: Container(
              //                                         height: 70,
              //                                         width: 70,
              //                                         decoration: BoxDecoration(
              //                                           borderRadius:
              //                                               BorderRadius.circular(
              //                                                   40),
              //                                           image: DecorationImage(
              //                                             image: snapshot.data![
              //                                                                 index]
              //                                                             [
              //                                                             "provider"]
              //                                                         [
              //                                                         'avatar'] ==
              //                                                     null
              //                                                 ? NetworkImage(
              //                                                     "https://images.pexels.com/photos/1781932/pexels-photo-1781932.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              //                                                   )
              //                                                 : NetworkImage(
              //                                                     "http://ondeindia.com/storage/app/public/" +
              //                                                         snapshot.data![index]
              //                                                                 [
              //                                                                 "provider"]
              //                                                             [
              //                                                             'avatar'],
              //                                                   ),
              //                                             fit: BoxFit.fill,
              //                                           ),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                     SizedBox(
              //                                       width: 10,
              //                                     ),
              //                                     Expanded(
              //                                       child: Column(
              //                                         crossAxisAlignment:
              //                                             CrossAxisAlignment
              //                                                 .start,
              //                                         children: [
              //                                           Text(
              //                                             snapshot.data![index]
              //                                                     ["provider"]
              //                                                 ['first_name'],
              //                                             style: const TextStyle(
              //                                               fontFamily: 'MonS',
              //                                               fontSize: 15,
              //                                               color: Colors.black,
              //                                             ),
              //                                           ),
              //                                           SizedBox(
              //                                             height: 3,
              //                                           ),
              //                                           Text(
              //                                             snapshot.data![index]
              //                                                     ['servicetype']
              //                                                 .toString(),
              //                                             style: TextStyle(
              //                                               fontFamily: 'MonR',
              //                                               fontSize: 10,
              //                                               color: Colors
              //                                                   .grey.shade500,
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               Text(
              //                                 snapshot.data![index]['final_fare']
              //                                         .toString() +
              //                                     ' ₹',
              //                                 style: const TextStyle(
              //                                   fontFamily: 'MonS',
              //                                   fontSize: 15,
              //                                   color: secondaryColor,
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 width: 16,
              //                               )
              //                             ],
              //                           ),
              //                           Container(
              //                             // height: 40,
              //                             decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(10),
              //                                 color: secondaryColor),
              //                             width:
              //                                 MediaQuery.of(context).size.width /
              //                                     1.1,
              //                             child: Padding(
              //                               padding: const EdgeInsets.all(8.0),
              //                               child: Row(
              //                                 children: [
              //                                   SizedBox(width: 6),
              //                                   Expanded(
              //                                     child: Text(
              //                                         snapshot.data![index]
              //                                             ['s_address'],
              //                                         maxLines: 2,
              //                                         style: TextStyle(
              //                                           fontFamily: 'MonR',
              //                                           fontSize: 10,
              //                                           color: whiteColor,
              //                                         ),
              //                                         overflow:
              //                                             TextOverflow.ellipsis,
              //                                         textAlign: TextAlign.start),
              //                                   ),
              //                                   Icon(
              //                                     Icons.arrow_forward_sharp,
              //                                     color: whiteColor,
              //                                   ),
              //                                   Expanded(
              //                                     child: Text(
              //                                       snapshot.data![index]
              //                                           ['d_address'],
              //                                       maxLines: 2,
              //                                       style: TextStyle(
              //                                         fontFamily: 'MonR',
              //                                         fontSize: 10,
              //                                         color: whiteColor,
              //                                       ),
              //                                       overflow:
              //                                           TextOverflow.ellipsis,
              //                                       textAlign: TextAlign.end,
              //                                     ),
              //                                   ),
              //                                   SizedBox(width: 6)
              //                                 ],
              //                               ),
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: 10,
              //                 ),
              //                 Divider(
              //                   height: 1,
              //                   color: Colors.grey.shade700,
              //                 )
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //       itemCount: snapshot.data!.length,
              //     );
              //   },
              // ),
              )
        ],
      ),
    );
  }

  Widget _getTrips() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getAllTrips(context),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: kindaBlack,
                      color: primaryColor,
                    ),
                  ),
                );
              }

              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                        'assets/animation/empty.json',
                        height: 120,
                        width: 120,
                      ),
                      Text(
                        "nohis".tr,
                        style: TextStyle(
                          color: kindaBlack,
                          fontSize: 15,
                          fontFamily: 'MonM',
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  // debugPrint('Object: ${jsonEncode(snapshot.data![0])}');
                  var date = snapshot.data![index]['schedule_at']
                      .toString()
                      .split(" ");

                  var date1 = date[0].toString();
                  var time1 = date[1].toString();
                  final tripID =
                      "# " + snapshot.data![index]['booking_id'].toString();
                  final fare = snapshot.data![index]['final_fare'].toString();
                  final mapImage =
                      snapshot.data![index]['static_map'].toString();
                  final paidFare =
                      snapshot.data![index]['final_fare'].toString();
                  final locationfromAddress =
                      snapshot.data![index]['s_address'].toString();
                  final locationtoAddress =
                      snapshot.data![index]['d_address'].toString();
                  final startTime = snapshot.data![index]['time'].toString();
                  final reachedTime =
                      snapshot.data![index]['reached_time'].toString();
                  final driverImage =
                      snapshot.data![index]["provider"]['avatar'].toString();
                  final driverem =
                      snapshot.data![index]["provider"]['email'].toString();
                  final drivernum =
                      snapshot.data![index]["provider"]['mobile'].toString();
                  final driveriddd =
                      snapshot.data![index]["provider"]['id'].toString();
                  final driverName = snapshot.data![index]['provider']
                          ['first_name']
                      .toString();
                  final payMode = snapshot.data![index]['payment_mode'] == null
                      ? ""
                      : snapshot.data![index]['payment_mode'].toString();
                  final driverRating =
                      snapshot.data![index]['provider']['rating'].toString();
                  final vehicleNumber =
                      snapshot.data![index]['provider_services'] == null
                          ? ""
                          : snapshot.data![index]['provider_services']
                                      ['service_number'] ==
                                  null
                              ? ""
                              : snapshot.data![index]['provider_services']
                                      ['service_number']
                                  .toString();
                  final vehicleName =
                      snapshot.data![index]['service_type']['name'].toString();
                  final vehicleDe = snapshot.data![index]['service_type']
                          ['description']
                      .toString();
                  final cancelledBy =
                      snapshot.data![index]['cancelled_by'].toString();
                  final vehicleImg = snapshot.data![index]['service_type']
                          ['vehicle_image']
                      .toString();
                  final mainID = snapshot.data![index]['id'].toString();
                  final driverContact =
                      snapshot.data![index]['provider']['mobile'].toString();
                  // // final serviceNumber = snapshot.data![index]
                  // //         ['provider_services']['service_number']
                  // //     .toString();
                  final service_model_id =
                      snapshot.data![index]['provider_services'] == null
                          ? ""
                          : snapshot.data![index]['provider_services']
                                      ['service_model'] ==
                                  null
                              ? ""
                              : snapshot.data![index]['provider_services']
                                      ['service_model']
                                  .toString();

                  final tripModel = snapshot.data![index]['fare_type'] == "16"
                      ? "Outstation"
                      : snapshot.data![index]['fare_type'] == "15"
                          ? "City Taxi"
                          : snapshot.data![index]['fare_type'] == "17"
                              ? "Rental"
                              : "";
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: InkWell(
                      onTap: () {
                        // Fluttertoast.showToast(msg: vehicleNumber.toString());
                        snapshot.data![index]['status'] == "CANCELLED"
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TripDetails(
                                    map: mapImage.toString(),
                                    mode: payMode == null
                                        ? ""
                                        : payMode.toString(),
                                    tripID: tripID.toString(),
                                    fare: fare.toString(),
                                    paidFare: paidFare.toString(),
                                    locationFAddress:
                                        locationfromAddress.toString(),
                                    locationTAddress:
                                        locationtoAddress.toString(),
                                    startTime: startTime.toString(),
                                    reachedTime: reachedTime.toString(),
                                    driverImage: driverImage.toString(),
                                    driverName: driverName.toString(),
                                    driverContact: driverContact.toString(),
                                    vehicleName: vehicleName.toString(),
                                    vehicleDes: vehicleDe.toString(),
                                    date: date1.toString(),
                                    time: time1.toString(),
                                    driverRate: driverRating.toString(),
                                    vehicleNumber: vehicleNumber.toString(),
                                    vehicleImage: vehicleImg == null
                                        ? "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                                        : vehicleImg.toString(),
                                    // vehicleImage:
                                    //     "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                                    id: mainID,
                                    cancelledby: cancelledBy,
                                    tripType: tripModel,
                                    serviceType: service_model_id,
                                  ),
                                ),
                              )
                            : snapshot.data![index]['status'] == "COMPLETED"
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TripDetails(
                                        map: mapImage.toString(),
                                        mode: payMode == null
                                            ? ""
                                            : payMode.toString(),
                                        tripID: tripID.toString(),
                                        fare: fare.toString(),
                                        paidFare: paidFare.toString(),
                                        locationFAddress:
                                            locationfromAddress.toString(),
                                        locationTAddress:
                                            locationtoAddress.toString(),
                                        startTime: startTime.toString(),
                                        reachedTime: reachedTime.toString(),
                                        driverImage: driverImage.toString(),
                                        driverName: driverName.toString(),
                                        driverContact: driverContact.toString(),
                                        vehicleName: vehicleName.toString(),
                                        vehicleDes: vehicleDe.toString(),
                                        date: date1.toString(),
                                        time: time1.toString(),
                                        driverRate: driverRating.toString(),
                                        vehicleNumber: vehicleNumber.toString(),
                                        vehicleImage: vehicleImg == null
                                            ? "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                                            : vehicleImg.toString(),
                                        // vehicleImage:
                                        //     "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                                        id: mainID,
                                        cancelledby: cancelledBy,
                                        tripType: tripModel,
                                        serviceType: service_model_id,
                                      ),
                                    ),
                                  )
                                : snapshot.data![index]['status'] == "SEARCHING"
                                    ? EasyLoading.showToast(
                                        "Serching you a cabbie..")
                                    : snapshot.data![index]['status'] ==
                                            "SCHEDULED"
                                        ? print(snapshot.data![index])
                                        // ? EasyLoading.showToast(
                                        //     "Your Ride is scheduled")
                                        : Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  DriverDetails(
                                                bookID: snapshot.data![index]
                                                        ['booking_id']
                                                    .toString(),
                                                stAdd: locationfromAddress
                                                    .toString(),
                                                stLat: snapshot.data![index]
                                                        ['s_latitude']
                                                    .toString(),
                                                requeID: snapshot.data![index]
                                                        ['id']
                                                    .toString(),
                                                stLong: snapshot.data![index]
                                                        ['s_longitude']
                                                    .toString(),
                                                drAdd: locationtoAddress
                                                    .toString(),
                                                drLat: snapshot.data![index]
                                                        ['d_latitude']
                                                    .toString(),
                                                estFare: paidFare.toString(),
                                                drLong: snapshot.data![index]
                                                        ['d_longitude']
                                                    .toString(),
                                                driName: driverName.toString(),
                                                driEmail: driverem.toString(),
                                                driMobile: drivernum.toString(),
                                                driRate:
                                                    driverRating.toString(),
                                                driImage:
                                                    driverImage.toString(),
                                                vehiNum:
                                                    vehicleNumber.toString(),
                                                vehName: vehicleName.toString(),
                                                vehMod: vehicleName.toString(),
                                                paymode: snapshot.data![index]
                                                        ['payment_mode']
                                                    .toString(),
                                                driID: driveriddd.toString(),
                                                requestIDS: snapshot
                                                    .data![index]['id']
                                                    .toString(),
                                              ),
                                            ),
                                          );
                      },
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    date1,
                                    style: const TextStyle(
                                      fontFamily: 'MonR',
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    time1,
                                    style: const TextStyle(
                                      fontFamily: 'MonR',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 11,
                              ),
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height: snapshot.data![index]['status'] !=
                                              "SCHEDULED" &&
                                          snapshot.data![index]['status'] !=
                                              "SEARCHING"
                                      ? 200
                                      : 220,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: snapshot.data![index]
                                                    ['status'] !=
                                                "SCHEDULED"
                                            ? 40
                                            : 50,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          color: snapshot.data![index]
                                                      ['status'] ==
                                                  "CANCELLED"
                                              ? Colors.red
                                              : snapshot.data![index]
                                                          ['status'] ==
                                                      "ACCEPTED"
                                                  ? Colors.blue.shade700
                                                  : snapshot.data![index]
                                                              ['status'] ==
                                                          "SCHEDULED"
                                                      ? Colors.blue.shade700
                                                      : snapshot.data![index]
                                                                  ['status'] ==
                                                              "SEARCHING"
                                                          ? Colors.grey.shade700
                                                          : snapshot.data![
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  "COMPLETED"
                                                              ? Colors.green
                                                              : Colors.blue
                                                                  .shade700,
                                        ),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child:
                                                  Builder(builder: (context) {
                                                String apiDateTimeString =
                                                    snapshot.data![index]
                                                        ['schedule_at'];

                                                // String formattedDateTime =

                                                String formatDateTime(
                                                    String apiDateTimeString) {
                                                  DateTime dateTime =
                                                      DateTime.parse(
                                                          apiDateTimeString);
                                                  DateFormat dateFormat =
                                                      DateFormat(
                                                          'dd MMM, yyyy hh:mm a'); // Date format: 09 Mar, 2024 07:00 AM
                                                  String formattedDateTime =
                                                      dateFormat
                                                          .format(dateTime);
                                                  return formattedDateTime;
                                                }

                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot.data![index]
                                                          ['status'],
                                                      style: const TextStyle(
                                                        fontFamily: 'MonS',
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    snapshot.data![index]
                                                                ['status'] !=
                                                            "SCHEDULED"
                                                        ? SizedBox()
                                                        : SizedBox(height: 5),
                                                    snapshot.data![index]
                                                                ['status'] !=
                                                            "SCHEDULED"
                                                        ? SizedBox()
                                                        : Text(
                                                            formatDateTime(
                                                                apiDateTimeString),
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'MonR',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "# " +
                                                          snapshot.data![index]
                                                              ['booking_id'],
                                                      style: TextStyle(
                                                        fontFamily: 'MonS',
                                                        fontSize: 11,
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                      ),
                                                    ),
                                                  ),
                                                  snapshot.data![index]
                                                                  ['status'] !=
                                                              "SCHEDULED" &&
                                                          snapshot.data![index]
                                                                  ['status'] !=
                                                              "SEARCHING"
                                                      ? SizedBox()
                                                      : TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .red
                                                                        .withOpacity(
                                                                            0.3)),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            56.0), // Adjust the radius as needed
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Padding(
                                                                    padding: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets,
                                                                    child:
                                                                        CancelRideOptions(
                                                                      reqID: snapshot
                                                                          .data![
                                                                              index]
                                                                              [
                                                                              'id']
                                                                          .toString(),
                                                                    ),
                                                                  );
                                                                });
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'MonS',
                                                              fontSize: 12,
                                                              color: Colors.red,
                                                            ),
                                                          ))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Card(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                          ),
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              image:
                                                                  DecorationImage(
                                                                image: snapshot.data![index]["provider"]
                                                                            [
                                                                            'avatar'] ==
                                                                        null
                                                                    ? NetworkImage(
                                                                        "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                                                                    : snapshot.data![index]['provider'] ==
                                                                            null
                                                                        ? NetworkImage(
                                                                            "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                                                                        : NetworkImage(
                                                                            "http://ondeindia.com/storage/app/public/" +
                                                                                snapshot.data![index]["provider"]['avatar'],
                                                                          ),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                snapshot.data![
                                                                            index]
                                                                        [
                                                                        "provider"]
                                                                    [
                                                                    'first_name'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'MonS',
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                snapshot.data![
                                                                            index]
                                                                        [
                                                                        "service_type"]
                                                                    ['name'],
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'MonR',
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    snapshot.data![index]
                                                                ['final_fare']
                                                            .toString() +
                                                        ' ₹',
                                                    style: const TextStyle(
                                                      fontFamily: 'MonS',
                                                      fontSize: 15,
                                                      color: secondaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: secondaryColor),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              ['s_address'],
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontFamily: 'MonM',
                                                            fontSize: 10,
                                                            color: whiteColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_sharp,
                                                        color: whiteColor,
                                                        size: 12,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              ['d_address'],
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontFamily: 'MonM',
                                                            fontSize: 10,
                                                            color: whiteColor,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
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
                              Divider(
                                height: 1,
                                color: Colors.grey.shade700,
                              )
                            ],
                          ),
                          Visibility(
                            visible:
                                snapshot.data![index]['status'] == "CANCELLED"
                                    ? true
                                    : false,
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 88.0),
                                child: Image.asset(
                                  'assets/images/cancelled.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            },
          ),
        )
      ],
    );
  }
}
