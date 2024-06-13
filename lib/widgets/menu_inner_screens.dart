import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';
import 'package:ondeindia/widgets/tripsdetails.dart';
import 'package:ondeindia/widgets/upcoming_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuInnerScreens extends StatefulWidget {
  final int id;
  final String title;
  MenuInnerScreens({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  State<MenuInnerScreens> createState() => _MenuInnerScreensState();
}

class _MenuInnerScreensState extends State<MenuInnerScreens> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 3,
          iconTheme: IconThemeData(color: kindaBlack),
          titleSpacing: 0,
          title: Text(
            "yourtrip".tr,
            style: const TextStyle(
              fontFamily: 'MonS',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          bottom: TabBar(
            labelColor: kindaBlack, //<-- selected text color
            unselectedLabelColor: kindaBlack.withOpacity(0.3),
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: secondaryColor, width: 5, style: BorderStyle.solid),
              ),
            ),
            labelStyle: TextStyle(
              color: kindaBlack,
              fontSize: 14,
              fontFamily: 'MonS',
            ),
            tabs: [
              Tab(
                text: "his".tr,
                // icon: Icon(
                //   Icons.history_outlined,
                // ),
              ),
              Tab(
                text: "upcoming".tr,
                // icon: Icon(Icons.upcoming_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //History
            Column(
              children: [
                Expanded(
                  child: _getTrips(),
                )
              ],
            ),

            //Upcoming Rides

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "No Upcoming Rides Available",
            //       style: const TextStyle(
            //         fontFamily: 'MonS',
            //         fontSize: 15,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ],
            // )
            _getUpComingTrips()
          ],
        ),
      ),
    );
  }

  Widget _getUpComingTrips() {
    return FutureBuilder(
      future: getUpcomingRides(context),
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
                  "nouprides".tr,
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
            final tripID =
                "# " + snapshot.data![index]['booking_id'].toString();
            final bookID = snapshot.data![index]['id'].toString();
            final fare = snapshot.data![index]['final_fare'].toString();
            final mapImage = snapshot.data![index]['static_map'].toString();
            final paidFare = snapshot.data![index]['final_fare'].toString();
            final locationfromAddress =
                snapshot.data![index]['s_address'].toString();
            final locationtoAddress =
                snapshot.data![index]['d_address'].toString();
            final startTime = snapshot.data![index]['time'].toString();
            final reachedTime =
                snapshot.data![index]['reached_time'].toString();
            final driverImage =
                snapshot.data![index]['driver_image'].toString();
            final driverName = snapshot.data![index]['provider'] == null
                ? ""
                : snapshot.data![index]['provider']['first_name'].toString();
            final payMode = snapshot.data![index]['payment_mode'] == null
                ? ""
                : snapshot.data![index]['payment_mode'].toString();
            final driverRating = snapshot.data![index]['provider'] == null
                ? ""
                : snapshot.data![index]['provider']['rating'].toString();
            final vehicleNumber =
                snapshot.data![index]['vehicle_no'].toString();
            final vehicleName = snapshot.data![index]['servicename'].toString();
            final vehicleDe = snapshot.data![index]['servicetype'].toString();
            final driverContact =
                snapshot.data![index]['contact_no'].toString();
            final scheduledAt =
                snapshot.data![index]['schedule_at'].toString().split(" ");

            // final reachedTime =
            //     snapshot.data![index]['reached_time'].toString();
            // final driverImage =
            //     snapshot.data![index]['driver_image'].toString();
            // final driverName = snapshot.data![index]['driver_name'].toString();
            // final vehicleNumber =
            //     snapshot.data![index]['vehicle_no'].toString();
            // final vehicleName =
            //     snapshot.data![index]['vehicle_name'].toString();
            // final driverContact =
            //     snapshot.data![index]['contact_no'].toString();
            return Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpComingDetail(
                        tripID: tripID.toString(),
                        fare: fare.toString(),
                        bookID: bookID.toString(),
                        locationFAddress: locationfromAddress.toString(),
                        locationTAddress: locationtoAddress.toString(),
                        scheduledDate: scheduledAt[0],
                        scheduledTime: scheduledAt[1],
                        map: mapImage,
                        driverContact: driverContact,
                        driverImage: driverImage,
                        driverName: driverName,
                        driverRate: driverRating,
                        vehicleDes: vehicleDe,
                        vehicleImage:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBNw73dFYVd8FZWCJlFJYLDmS9hTkfFs25RA&usqp=CAU",
                        vehicleName: vehicleName,
                        vehicleNumber: vehicleNumber,
                        // startTime: startTime.toString(),
                        // reachedTime: reachedTime.toString(),
                        // driverImage: driverImage.toString(),
                        // driverName: driverName.toString(),
                        // driverContact: driverContact.toString(),
                        // vehicleName: vehicleName.toString(),
                        // vehicleNumber: vehicleNumber.toString(),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 31,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            snapshot.data![index]['provider'] == null
                                ? ""
                                : vehicleName,
                            style: const TextStyle(
                              fontFamily: 'MonR',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          tripID,
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
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              snapshot.data![index]['provider'] == null
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://images.pexels.com/photos/3876332/pexels-photo-3876332.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                            ['provider']
                                                            ['first_name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'MonS',
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    vehicleDe,
                                                    style: TextStyle(
                                                      fontFamily: 'MonR',
                                                      fontSize: 10,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          fare + ' ₹',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.blueGrey
                                                .withOpacity(0.4),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                locationfromAddress,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'MonR',
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  // VerticalDivider(
                                  //   color: Colors.black,
                                  //   thickness: 3,
                                  //   indent: 20,
                                  //   endIndent: 0,
                                  //   width: 20,
                                  // / SizedBox(
                                  //   height: 3,
                                  // ),/ ),
                                  // Container(
                                  //   margin: EdgeInsets.only(left: 10),
                                  //   height: 15,
                                  //   width: 15,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     color: Colors.red.shade700,
                                  //   ),
                                  // ),

                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          Colors.red.shade700.withOpacity(0.3),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.blueGrey
                                                .withOpacity(0.4),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Text(
                                                locationtoAddress,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'MonR',
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Row(
                      children: [
                        Text(
                          scheduledAt[0].toString(),
                          style: const TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        Text(
                          scheduledAt[1].toString(),
                          style: const TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
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
              ),
            );
          },
          itemCount: snapshot.data!.length,
        );
      },
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
                  var date =
                      snapshot.data![index]['created_at'].toString().split(" ");

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetails(
                              map: mapImage.toString(),
                              mode: payMode == null ? "" : payMode.toString(),
                              tripID: tripID.toString(),
                              fare: fare.toString(),
                              paidFare: paidFare.toString(),
                              locationFAddress: locationfromAddress.toString(),
                              locationTAddress: locationtoAddress.toString(),
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
                              cancelledby: cancelledBy, tripType: tripModel,
                              serviceType: service_model_id,
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
                                  height: 151,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        image: DecorationImage(
                                                          image: snapshot.data![
                                                                              index]
                                                                          [
                                                                          "provider"]
                                                                      [
                                                                      'avatar'] ==
                                                                  null
                                                              ? NetworkImage(
                                                                  "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                                                              : snapshot.data![
                                                                              index]
                                                                          [
                                                                          'provider'] ==
                                                                      null
                                                                  ? NetworkImage(
                                                                      "https://images.pexels.com/photos/12861655/pexels-photo-12861655.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                                                                  : NetworkImage(
                                                                      "http://ondeindia.com/storage/app/public/" +
                                                                          snapshot.data![index]["provider"]
                                                                              [
                                                                              'avatar'],
                                                                    ),
                                                          fit: BoxFit.fill,
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
                                                          snapshot.data![index]
                                                                  ["provider"]
                                                              ['first_name'],
                                                          style:
                                                              const TextStyle(
                                                            fontFamily: 'MonS',
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text(
                                                          snapshot.data![index][
                                                                  "service_type"]
                                                              ['name'],
                                                          style: TextStyle(
                                                            fontFamily: 'MonR',
                                                            fontSize: 10,
                                                            color: Colors
                                                                .grey.shade500,
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
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: secondaryColor),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_sharp,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.end,
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
