// import 'package:flutter/material.dart';

// import '../../constants/color_contants.dart';

// class SelctionPage extends StatefulWidget {
//   SelctionPage({Key? key}) : super(key: key);

//   @override
//   State<SelctionPage> createState() => _SelctionPageState();
// }

// class _SelctionPageState extends State<SelctionPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Container(
//               height: 150,
//               width: 150,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(90),
//                 color: Color(0xFFECB390).withOpacity(0.4),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Image.asset(
//                   'assets/images/newlogoss.png',
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(primaryColor),
//                 ),
//                 onPressed: () async {
//                   // String useremail = _emailController.text;
//                   // String password = _passwordController.text;

//                   // String? fcmtoken =
//                   //     await FirebaseMessaging.instance.getToken();

//                   // print(
//                   //     "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");

//                   // if (_formKey.currentState!.validate()) {
//                   //   showLoaderDialog(context);
//                   //   await userlogin(
//                   //       _deviceId.toString(),
//                   //       _deviceType.toString(),
//                   //       fcmtoken.toString(),
//                   //       useremail,
//                   //       password,
//                   //       context);
//                   // } else {
//                   //   ScaffoldMessenger.of(context).showSnackBar(
//                   //     SnackBar(
//                   //       content: Material(
//                   //         elevation: 3,
//                   //         shape: RoundedRectangleBorder(
//                   //             borderRadius: BorderRadius.circular(10)),
//                   //         child: Container(
//                   //           height: 60,
//                   //           decoration: BoxDecoration(
//                   //               color: Colors.red,
//                   //               borderRadius: BorderRadius.circular(10)),
//                   //           child: Center(
//                   //               child: Text(
//                   //             "Please Fill all the required details...",
//                   //             style: TextStyle(color: Colors.white),
//                   //           )),
//                   //         ),
//                   //       ),
//                   //       behavior: SnackBarBehavior.floating,
//                   //       backgroundColor: Colors.transparent,
//                   //       elevation: 0,
//                   //     ),
//                   //   );
//                   // }

//                   // print("--------------> " +
//                   //     fcmtoken.toString() +
//                   //     " <-----------------");
//                   // print("---------------->> " +
//                   //     _deviceId.toString() +
//                   //     " <<-------------");
//                   // print("---------------->>>> " +
//                   //     _deviceType.toString() +
//                   //     " <<<<-------------");

//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => UserSectionPage()));
//                 },
//                 child: SizedBox(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   child: const Center(
//                     child: Text(
//                       "Sign In with Email",
//                       style: TextStyle(
//                         color: whiteColor,
//                         fontSize: 15,
//                         fontFamily: 'MonS',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Color(0xFF1F4690)),
//                 ),
//                 onPressed: () async {},
//                 child: SizedBox(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width / 1.2,
//                   child: const Center(
                    // child: Text(
                    //   "Sign In with Google",
                    //   style: TextStyle(
                    //     color: whiteColor,
                    //     fontSize: 15,
                    //     fontFamily: 'MonS',
                    //   ),
                    // ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
