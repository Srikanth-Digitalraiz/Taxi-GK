import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ondeindia/constants/apiconstants.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';

import '../../constants/color_contants.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: whiteColor,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(color: kindaBlack),
        title: Text(
          "notifications".tr,
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 15,
            color: kindaBlack,
          ),
        ),
      ),
      body: FutureBuilder(
          future: getNotifications(context),
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
                      "noti".tr,
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
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                  child: InkWell(
                    onTap: () {
                      String img =
                          notifyImageBaseUrl + snapshot.data![index]['image'];

                      String title = snapshot.data![index]['title'];
                      String notiText =
                          snapshot.data![index]['notification_text'];

                      showAlertDialog(context, img, title, notiText);
                    },
                    child: Container(
                      height: 90,
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
                            color:
                                Colors.grey.withOpacity(0.5), //color of shadow
                            spreadRadius: 1, //spread radius
                            blurRadius: 2, // blur radius
                            offset: Offset(0, 2), // changes position of shadow
                            //first paramerter of offset is left-right
                            //second parameter is top to down
                          ),
                          //you can set more BoxShadow() here
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.2), //color of shadow
                                  spreadRadius: 1, //spread radius
                                  blurRadius: 2, // blur radius
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                  //first paramerter of offset is left-right
                                  //second parameter is top to down
                                ),
                                //you can set more BoxShadow() here
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(
                                    snapshot.data![index]['image'] == null
                                        ? ""
                                        : notifyImageBaseUrl +
                                            snapshot.data![index]['image'],
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index]['title'].toString(),
                                  style: TextStyle(
                                    fontFamily: 'MonM',
                                    fontSize: 13,
                                    color: kindaBlack.withOpacity(0.8),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data![index]['notification_text']
                                      .toString(),
                                  style: TextStyle(
                                    fontFamily: 'MonR',
                                    fontSize: 12,
                                    color: kindaBlack.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
              itemCount: snapshot.data!.length,
            );
          }),
    );
  }

  showAlertDialog(BuildContext context, image, text, text2) {
    // set up the button
    // Widget okButton = TextButton(
    //   child: Text("OK"),
    //   onPressed: () {},
    // );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Image.network(image)),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'MonR',
              fontSize: 12,
              color: kindaBlack.withOpacity(0.6),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text2,
            style: TextStyle(
              fontFamily: 'MonR',
              fontSize: 12,
              color: kindaBlack.withOpacity(0.6),
            ),
          ),
        ],
      ),
    )
        // actions: [
        //   okButton,
        // ],
        );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
