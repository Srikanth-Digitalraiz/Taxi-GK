import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';

import '../../constants/color_contants.dart';

class DriverRating extends StatefulWidget {
  const DriverRating({Key? key}) : super(key: key);

  @override
  State<DriverRating> createState() => _DriverRatingState();
}

class _DriverRatingState extends State<DriverRating> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: kindaBlack),
        title: Text(
          "reviews".tr,
          style: TextStyle(
            color: kindaBlack,
            fontSize: 15,
            fontFamily: 'MonM',
          ),
        ),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                height: 60,
                width: 60,
                child: Lottie.asset('assets/animation/loading.json'),
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
                    "nodriverrate".tr,
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
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    String date = snapshot.data![index]['created_at'];
                    var arr = date.split(" ");
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.2),
                          //     spreadRadius: 1,
                          //     blurRadius: 2,
                          //     offset: Offset(0, 3), // changes position of shadow
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), //color of shadow
                              spreadRadius: 1, //spread radius
                              blurRadius: 2, // blur radius
                              offset:
                                  Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      snapshot.data![index]['provider_comment']
                                          .toString(),
                                      style: const TextStyle(
                                          color: kindaBlack,
                                          fontSize: 15,
                                          fontFamily: 'MonM',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    "# " +
                                        snapshot.data![index]['userrequest']
                                                ['booking_id']
                                            .toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontFamily: 'MonR',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              snapshot.data![index]['provider_rating'] == 1
                                  ? Row(
                                      children: const [
                                        Icon(
                                          Icons.star,
                                          color: gold,
                                        ),
                                        Icon(
                                          Icons.star_outline,
                                          color: Colors.red,
                                        ),
                                        Icon(
                                          Icons.star_outline,
                                          color: Colors.red,
                                        ),
                                        Icon(
                                          Icons.star_outline,
                                          color: Colors.red,
                                        ),
                                        Icon(
                                          Icons.star_outline,
                                          color: Colors.red,
                                        ),
                                      ],
                                    )
                                  : snapshot.data![index]['provider_rating'] ==
                                          2
                                      ? Row(
                                          children: const [
                                            Icon(
                                              Icons.star,
                                              color: gold,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: gold,
                                            ),
                                            Icon(
                                              Icons.star_outline,
                                              color: Colors.red,
                                            ),
                                            Icon(
                                              Icons.star_outline,
                                              color: Colors.red,
                                            ),
                                            Icon(
                                              Icons.star_outline,
                                              color: Colors.red,
                                            ),
                                          ],
                                        )
                                      : snapshot.data![index]
                                                  ['provider_rating'] ==
                                              3
                                          ? Row(
                                              children: const [
                                                Icon(
                                                  Icons.star,
                                                  color: gold,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: gold,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: gold,
                                                ),
                                                Icon(
                                                  Icons.star_outline,
                                                  color: Colors.red,
                                                ),
                                                Icon(
                                                  Icons.star_outline,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            )
                                          : snapshot.data![index]
                                                      ['provider_rating'] ==
                                                  4
                                              ? Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.star,
                                                      color: gold,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: gold,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: gold,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: gold,
                                                    ),
                                                    Icon(
                                                      Icons.star_outline,
                                                      color: Colors.red,
                                                    ),
                                                  ],
                                                )
                                              : snapshot.data![index]
                                                          ['provider_rating'] ==
                                                      5
                                                  ? Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.star,
                                                          color: gold,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: gold,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: gold,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: gold,
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color: gold,
                                                        ),
                                                      ],
                                                    )
                                                  : snapshot.data![index][
                                                              'provider_rating'] ==
                                                          0
                                                      ? Row(
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              color: Colors.red,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              color: Colors.red,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              color: Colors.red,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              color: Colors.red,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              color: Colors.red,
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        arr[0].toString(),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontFamily: 'MonR',
                                        ),
                                      ),
                                    ),
                                    Text(
                                      arr[1].toString(),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontFamily: 'MonR',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                ),
              )
            ],
          );
        },
        future: getReviews(context),
      ),
      // body: Center(
      //   child: Text("No Customer rating Available 😀"),
      // ),
    );
  }
}
