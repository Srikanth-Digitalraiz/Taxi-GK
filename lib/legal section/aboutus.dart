import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:ondeindia/repositories/tripsrepo.dart';

import '../constants/color_contants.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: kindaBlack),
        title: Text(
          "about".tr,
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 13,
            color: kindaBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getAboutUs(context),
                builder: (context, AsyncSnapshot snapshot) {
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
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(snapshot.data['image']),
                        SizedBox(
                          height: 20,
                        ),
                        Html(
                          data: snapshot.data['en_description'],
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
