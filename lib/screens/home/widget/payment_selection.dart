import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/global/wallet.dart';
import 'package:http/http.dart' as http;
import 'package:ondeindia/widgets/loder_dialg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/apiconstants.dart';
import '../../auth/loginscreen.dart';

class PaymentSelection extends StatefulWidget {
  PaymentSelection({Key? key}) : super(key: key);

  @override
  State<PaymentSelection> createState() => _PaymentSelectionState();
}

enum BestTutorSite { javatpoint, tutorialandexample }

class _PaymentSelectionState extends State<PaymentSelection> {
  BestTutorSite _site = paymentMode == "CASH"
      ? BestTutorSite.tutorialandexample
      : BestTutorSite.javatpoint;
  int mainWallet = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Select your payment Method",
                      style: TextStyle(
                        fontFamily: 'MonM',
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    walletBalanceAmount <= 0
                        ? Text(
                            walletBalanceAmount < 0
                                ? "*Please clear previous due of ₹ $walletBalanceAmount to select wallet again"
                                : walletBalanceAmount == 0
                                    ? "*Please add funds in your wallet to go cashless on your ride."
                                    : "",
                            style: TextStyle(
                              fontFamily: 'MonR',
                              fontSize: 11,
                              color: Colors.black.withOpacity(0.3),
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                        secondary: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: walletBalanceAmount < 0
                                ? Colors.red
                                : walletBalanceAmount == 0
                                    ? Colors.red.withOpacity(0.3)
                                    : secondaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.1), //color of shadow
                                spreadRadius: 1, //spread radius
                                blurRadius: 1, // blur radius
                                offset:
                                    Offset(1, 1), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              ),
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.1), //color of shadow
                                spreadRadius: 1, //spread radius
                                blurRadius: 1, // blur radius
                                offset: Offset(
                                    -1, -1), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              ),
                              //you can set more BoxShadow() here
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "₹  $walletBalanceAmount/-",
                              style: TextStyle(
                                fontFamily: 'MonB',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.wallet, color: Colors.green),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Wallet",
                              style: TextStyle(
                                fontFamily: 'MonM',
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        value: BestTutorSite.javatpoint,
                        groupValue: _site,
                        onChanged: (BestTutorSite? value) async {
                          if (walletBalanceAmount < 0) {
                            FToast.toast(context,
                                msg:
                                    "Please clear previous due of rupees ₹ ${walletBalanceAmount}  to select wallet again...");
                          } else if (walletBalanceAmount == 0) {
                            FToast.toast(context,
                                msg:
                                    "You dont have enough in your wallet to select wallet...");
                          } else {
                            setState(() {
                              _site = value!;
                              paymentMode = "WALLET";
                            });
                            Navigator.pop(context);
                            showLoaderDialog(
                                context, "Changing Payment Mode...", 5);
                          }
                        }),
                    RadioListTile(
                      title: Row(
                        children: [
                          Icon(Icons.money_outlined,
                              color: Colors.green.shade700),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontFamily: 'MonM',
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      value: BestTutorSite.tutorialandexample,
                      groupValue: _site,
                      onChanged: (BestTutorSite? value) {
                        setState(() {
                          _site = value!;
                          paymentMode = "CASH";
                        });
                        Navigator.pop(context);
                        showLoaderDialog(
                            context, "Changing Payment Mode...", 5);
                      },
                    ),
                  ],
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       paymentMode = mainWallet == 0 ? "WALLET" : "CASH";
              //     });
              //     FToast.toast(context, msg: "$paymentMode");
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(0),
              //       color: Colors.black,
              //     ),
              //     child: Center(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 12.0),
              //         child: Text(
              //           "Select Payment Option",
              //           style: TextStyle(
              //             fontFamily: 'MonS',
              //             fontSize: 17,
              //             color: whiteColor,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
