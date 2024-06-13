import 'package:flutter/material.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/dropdetails.dart';
import 'package:ondeindia/global/maineta.dart';
import 'package:ondeindia/global/rental_fare_plan.dart';

import '../../../global/distance.dart';
import '../../../global/fare_type.dart';
import '../../../global/pickup_location.dart';

rideConfirmSection(
    context,
    rideName,
    estimatedFare,
    eta,
    running,
    des,
    vehicleImage,
    waiting,
    serviceDes,
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    seater) {
  return Container(
    height: 550,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
        bottom: Radius.circular(10),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 4,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                          top: Radius.circular(20),
                        ),
                        color: secondaryColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                rideName,
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 14,
                                  fontFamily: 'MonS',
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                seater == null ? "" : "( " + seater + " )",
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 14,
                                  fontFamily: 'MonS',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(vehicleImage == null
                              ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Circle-icons-car.svg/1200px-Circle-icons-car.svg.png'
                              : 'http://ondeindia.com/storage/app/public/' +
                                  vehicleImage),
                          fit: BoxFit.fill,
                        ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color:
                        //         Colors.grey.withOpacity(0.2), //color of shadow
                        //     spreadRadius: 1, //spread radius
                        //     blurRadius: 1, // blur radius
                        //     offset: Offset(2, 0), // changes position of shadow
                        //     //first paramerter of offset is left-right
                        //     //second parameter is top to down
                        //   ),
                        //   BoxShadow(
                        //     color:
                        //         Colors.grey.withOpacity(0.2), //color of shadow
                        //     spreadRadius: 1, //spread radius
                        //     blurRadius: 1, // blur radius
                        //     offset: Offset(0, 2), // changes position of shadow
                        //     //first paramerter of offset is left-right
                        //     //second parameter is top to down
                        //   ),
                        //   //you can set more BoxShadow() here
                        // ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2), //color of shadow
                    //     spreadRadius: 1, //spread radius
                    //     blurRadius: 1, // blur radius
                    //     offset: Offset(2, 0), // changes position of shadow
                    //     //first paramerter of offset is left-right
                    //     //second parameter is top to down
                    //   ),
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2), //color of shadow
                    //     spreadRadius: 1, //spread radius
                    //     blurRadius: 1, // blur radius
                    //     offset: Offset(0, 2), // changes position of shadow
                    //     //first paramerter of offset is left-right
                    //     //second parameter is top to down
                    //   ),
                    //   //you can set more BoxShadow() here
                    // ],
                    color: whiteColor.withOpacity(0.9),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.green),
                            ),
                            Container(
                              height: 30,
                              width: 1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: kindaBlack.withOpacity(0.4)),
                            ),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                pickAdd,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 11,
                                  fontFamily: 'MonM',
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 2,
                                width: 1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.transparent),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                dropadd,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 11,
                                  fontFamily: 'MonM',
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    fareType == "17"
                        ? SizedBox()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primaryColor.withOpacity(0.2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.schedule_outlined,
                                      color: secondaryColor, size: 16),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Builder(builder: (context) {
                                        double tottalDis = distance + distance;
                                        return Text(
                                          fareType == "16"
                                              ? selectedOutName == "Round Trip"
                                                  ? tottalDis
                                                          .round()
                                                          .toString() +
                                                      " KM " +
                                                      " / "
                                                  : distance
                                                          .round()
                                                          .toString() +
                                                      " KM " +
                                                      " / "
                                              : distance.round().toString() +
                                                  " KM " +
                                                  " / ",
                                          maxLines: 1,
                                          style: const TextStyle(
                                            color: secondaryColor,
                                            fontSize: 10,
                                            fontFamily: 'MonM',
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }),
                                      Text(
                                        mainETA,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: secondaryColor,
                                          fontSize: 10,
                                          fontFamily: 'MonM',
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                    fareType == "17"
                        ? SizedBox()
                        : SizedBox(
                            width: 7,
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor.withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                fareType == "17"
                                    ? SizedBox()
                                    : Icon(Icons.payments_outlined,
                                        color: secondaryColor, size: 16),
                                fareType == "17"
                                    ? SizedBox()
                                    : SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Estimated Fare: ',
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: secondaryColor,
                                        fontSize: 12,
                                        fontFamily: 'MonM',
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "₹ " + estimatedFare + " /-",
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: secondaryColor,
                                        fontSize: 12,
                                        fontFamily: 'MonM',
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: primaryColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        one == "0"
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '$one',
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontFamily: 'MonM',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        one == "0" ? SizedBox() : SizedBox(height: 8),
                        two == "0"
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '$two',
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontFamily: 'MonM',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        two == "0" ? SizedBox() : SizedBox(height: 8),
                        three == "0"
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '$three',
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontFamily: 'MonM',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        three == "0" ? SizedBox() : SizedBox(height: 8),
                        four == "0"
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '$four',
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontFamily: 'MonM',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        four == "0" ? SizedBox() : SizedBox(height: 8),
                        five == "0"
                            ? SizedBox()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '$five',
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontFamily: 'MonM',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        // SizedBox(height: 5),

                        // Text(
                        //   '$eight',
                        //   maxLines: 4,
                        //   style: const TextStyle(
                        //     color: secondaryColor,
                        //     fontSize: 14,
                        //     fontFamily: 'MonM',
                        //   ),
                        //   textAlign: TextAlign.justify,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        // Text(
                        //   '$serviceDes',
                        //   maxLines: 4,
                        //   style: const TextStyle(
                        //     color: secondaryColor,
                        //     fontSize: 14,
                        //     fontFamily: 'MonM',
                        //   ),
                        //   textAlign: TextAlign.justify,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ],
                    ),
                  ),
                ),
                // dis == ""
                //     ? Container()
                //     : Container(
                //         width: MediaQuery.of(context).size.width,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: primaryColor.withOpacity(0.2),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(6.0),
                //           child: Text(
                //             '$dis',
                //             maxLines: 1,
                //             style: const TextStyle(
                //               color: secondaryColor,
                //               fontSize: 12,
                //               fontFamily: 'MonM',
                //             ),
                //             textAlign: TextAlign.center,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //         ),
                //       ),
                // SizedBox(
                //   height: 5,
                // ),
                // running == ""
                //     ? Container()
                //     : Container(
                //         width: MediaQuery.of(context).size.width,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: primaryColor.withOpacity(0.2),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(6.0),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 'Running Charges: ',
                //                 maxLines: 2,
                //                 style: const TextStyle(
                //                   color: secondaryColor,
                //                   fontSize: 12,
                //                   fontFamily: 'MonM',
                //                 ),
                //                 textAlign: TextAlign.center,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               Expanded(
                //                 child: Text(
                //                   '$running',
                //                   maxLines: 2,
                //                   style: const TextStyle(
                //                     color: secondaryColor,
                //                     fontSize: 13,
                //                     fontFamily: 'MonS',
                //                   ),
                //                   textAlign: TextAlign.start,
                //                   overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                five == "0"
                    ? SizedBox()
                    : SizedBox(
                        height: 8,
                      ),
                seven == "0"
                    ? SizedBox()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            '$seven',
                            maxLines: 4,
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                              fontFamily: 'MonM',
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                seven == "0"
                    ? SizedBox()
                    : SizedBox(
                        height: 8,
                      ),
                waiting == "0"
                    ? SizedBox()
                    : fareType == "17"
                        ? SizedBox()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor.withOpacity(0.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Waiting Charges: ',
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 12,
                                      fontFamily: 'MonM',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$waiting',
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: secondaryColor,
                                      fontSize: 13,
                                      fontFamily: 'MonS',
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                waiting == "0"
                    ? SizedBox()
                    : SizedBox(
                        height: 8,
                      ),
                six == "0"
                    ? SizedBox()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            '$six',
                            maxLines: 4,
                            style: const TextStyle(
                              color: secondaryColor,
                              fontSize: 12,
                              fontFamily: 'MonM',
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                six == "0"
                    ? SizedBox()
                    : SizedBox(
                        height: 5,
                      ),
                // serviceDes == ""
                //     ? Container()
                //     :
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 18.0, top: 12),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                          fontFamily: 'MonM',
                          fontSize: 15,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    ),
    // child: Stack(
    //   children: [
    // Align(
    //   alignment: Alignment.topCenter,
    //   child: Container(
    //     margin: EdgeInsets.only(top: 10),
    //     height: 5,
    //     width: 40,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.vertical(
    //           bottom: Radius.circular(20),
    //           top: Radius.circular(20),
    //         ),
    //         color: primaryColor),
    //   ),
    // ),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         children: [
    //           Expanded(
    //             child: ListView(
    //               // crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   height: 12,
    //                 ),
    // Text(
    //   rideName,
    //   style: const TextStyle(
    //     color:secondaryColor,
    //     fontSize: 16,
    //     fontFamily: 'MonS',
    //   ),
    // ),
    //                 Divider(),
    //                 SizedBox(
    //                   height: 7.5,
    //                 ),
    //                 Row(
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Text(
    //                           "Cab Type...",
    //                           style: const TextStyle(
    //                             color: kindaBlack,
    //                             fontSize: 12,
    //                             fontFamily: 'MonR',
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 15,
    //                         ),
    //                         Row(
    //                           children: [
    //                             Container(
    //                               height: 70,
    //                               width: 70,
    //                               decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(80),
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                       color: Colors.grey.withOpacity(
    //                                           0.2), //color of shadow
    //                                       spreadRadius: 1, //spread radius
    //                                       blurRadius: 2, // blur radius
    //                                       offset: Offset(0,
    //                                           2), // changes position of shadow
    //                                       //first paramerter of offset is left-right
    //                                       //second parameter is top to down
    //                                     ),
    //                                     //you can set more BoxShadow() here
    //                                   ],
    //                                   color: whiteColor,
    //                                   image: DecorationImage(
    //                                     image: NetworkImage(
    //                                         'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Circle-icons-car.svg/1200px-Circle-icons-car.svg.png'),
    //                                     fit: BoxFit.cover,
    //                                   )),
    //                             ),
    //                             SizedBox(
    //                               width: 15,
    //                             ),
    //                             Text(
    //                               "$rideName".toUpperCase(),
    //                               style: const TextStyle(
    //                                 color: kindaBlack,
    //                                 fontSize: 15,
    //                                 fontFamily: 'MonM',
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //                 SizedBox(
    //                   height: 7.5,
    //                 ),
    //                 Divider(),
    //                 Text(
    //                   "About $rideName".toUpperCase(),
    //                   style: const TextStyle(
    //                     color:secondaryColor,
    //                     fontFamily: 'MonR',
    //                     fontSize: 14,
    //                   ),
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //                 SizedBox(
    //                   height: 15,
    //                 ),
    //                 Text(
    //                   destination,
    //                   style: const TextStyle(
    //                     color:secondaryColor,
    //                     fontFamily: 'MonR',
    //                     fontSize: 12,
    //                   ),
    //                   textAlign: TextAlign.justify,
    //                 ),
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //     Align(
    //       alignment: Alignment.bottomCenter,
    //       child: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Container(
    //           height: 50,
    //           decoration: BoxDecoration(
    //               color:secondaryColor, borderRadius: BorderRadius.circular(5)),
    //           child: TextButton(
    //             onPressed: () async {
    //               // showModalBottomSheet<void>(
    //               //   isScrollControlled: true,
    //               //   backgroundColor: Colors.transparent,
    //               //   shape: RoundedRectangleBorder(
    //               //     borderRadius: BorderRadius.circular(20),
    //               //   ),
    //               //   context: context,
    //               //   builder: (BuildContext context) {
    //               //     return Padding(
    //               //       padding:
    //               //           MediaQuery.of(context).viewInsets,
    //               //       child: rideConfirmSection(context, "mini",
    //               //           "200", "Kukatpally", "Madhapur"),
    //               //     );
    //               //   },
    //               // );
    //             },
    //             child: Center(
    //               child: Text(
    //                 "Done",
    //                 style: TextStyle(
    //                   fontFamily: 'MonM',
    //                   fontSize: 15,
    //                   color: whiteColor,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
  );
}
