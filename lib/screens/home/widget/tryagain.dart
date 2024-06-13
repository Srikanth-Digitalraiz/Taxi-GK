import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/color_contants.dart';
import '../../../widgets/loder_dialg.dart';
import '../../bookride/bookride.dart';

tryAgain(context, serviceID, serviceName) {
  return Container(
    height: MediaQuery.of(context).size.height / 1.3,
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_LlRvIg.json'),

        Text(
            "Sorry, We were unable to connect you with any of our drivers...please try again"),

        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 18.0, top: 12),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookRideSection(
                        serviceID: serviceID,
                        serviceName: serviceName,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    "Sign In",
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

        //BookRideSection
      ],
    ),
  );
}
