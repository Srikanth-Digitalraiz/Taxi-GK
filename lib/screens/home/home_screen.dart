import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/fare_type.dart';
import 'package:ondeindia/screens/home/Outstation%20Flow/outstation_main.dart';
import 'package:ondeindia/screens/home/Rental%20Flow/rental.dart';
import 'package:ondeindia/screens/home/home.dart';
import 'package:ondeindia/widgets/menuscreen.dart';

import '../../widgets/loder_dialg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final zoomDrawerController = ZoomDrawerController();
  onpop() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.TOPSLIDE,
      title: "Are you sure?",
      desc: "You want to quit app!",
      btnCancelOnPress: () {
        // Navigator.pushReplacement(
        //     context,
        //     CupertinoPageRoute(
        //       builder: ((context) => HomeScreen()),
        //     ));
      },
      btnOkOnPress: () async {
        SystemNavigator.pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onpop();
      },
      child: Scaffold(
          backgroundColor: whiteColor,
          body: ZoomDrawer(
            controller: zoomDrawerController,
            style: DrawerStyle.Style1,
            menuScreen: MenuScreen(zoomDrawerController),
            mainScreen: fareTypeActive.any((element) => element["id"] == 15)
                ? Home(zoomDrawerController) // Case 1 & 2
                : fareTypeActive.any((element) => element["id"] == 16) &&
                        fareTypeActive.any((element) => element["id"] == 17)
                    ? RentalPage(
                        zoomDrawerController: zoomDrawerController) // Case 4
                    : fareTypeActive.any((element) => element["id"] == 16)
                        ? OutStationPage(
                            zoomDrawerController:
                                zoomDrawerController) // Case 3
                        : fareTypeActive.any((element) => element["id"] == 17)
                            ? RentalPage(
                                zoomDrawerController:
                                    zoomDrawerController) // Case 5
                            : fareTypeActive.any(
                                        (element) => element["id"] == 15) &&
                                    fareTypeActive
                                        .any((element) => element["id"] == 17)
                                ? Home(zoomDrawerController) // Case 6
                                : OutStationPage(
                                    zoomDrawerController:
                                        zoomDrawerController), // If none of the conditions match, go to `OutStationPage` as default
            borderRadius: 24.0,
            angle: 0,
            showShadow: true,
            backgroundColor: Colors.grey.shade500.withOpacity(0.3),
            slideWidth: MediaQuery.of(context).size.width * .75,
            openCurve: Curves.fastOutSlowIn,
            closeCurve: Curves.easeInSine,
          )),
    );
  }
}
