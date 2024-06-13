// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card_new/credit_card_brand.dart';
// import 'package:flutter_credit_card_new/flutter_credit_card.dart';

// import 'package:ondeindia/constants/color_contants.dart';

// class AddCard extends StatefulWidget {
//   AddCard({Key? key}) : super(key: key);

//   @override
//   State<AddCard> createState() => _AddCardState();
// }

// class _AddCardState extends State<AddCard> {
//   String cardNumber = '';
//   String expiryDate = '';
//   String cardHolderName = '';
//   String cvvCode = '';
//   bool isCvvFocused = false;
//   bool useGlassMorphism = false;
//   bool useBackgroundImage = false;
//   OutlineInputBorder? border;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     border = OutlineInputBorder(
//       borderSide: BorderSide(
//         color: Colors.grey.withOpacity(0.7),
//         width: 2.0,
//       ),
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: whiteColor,
//         elevation: 0,
//         titleSpacing: 0,
//         iconTheme: const IconThemeData(color: kindaBlack),
//         title: Text(
//           "Add Card",
//           style: TextStyle(
//             fontFamily: 'MonS',
//             fontSize: 13,
//             color: kindaBlack,
//           ),
//         ),
//       ),
//       backgroundColor: whiteColor,
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: <Widget>[
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CreditCardWidget(
//                   glassmorphismConfig:
//                       useGlassMorphism ? Glassmorphism.defaultConfig() : null,
//                   cardNumber: cardNumber,
//                   expiryDate: expiryDate,
//                   cardHolderName: cardHolderName,
//                   cvvCode: cvvCode,
//                   showBackView: isCvvFocused,
//                   obscureCardNumber: true,
//                   obscureCardCvv: true,
//                   isHolderNameVisible: true,
//                   cardBgColor: Colors.red,
//                   backgroundImage:
//                       useBackgroundImage ? 'assets/card_bg.png' : null,
//                   isSwipeGestureEnabled: true,
//                   onCreditCardWidgetChange:
//                       (CreditCardBrand creditCardBrand) {},
//                   customCardTypeIcons: <CustomCardTypeIcon>[
//                     CustomCardTypeIcon(
//                       cardType: CardType.mastercard,
//                       cardImage: Image.asset(
//                         'assets/icons/mastercard.png',
//                         height: 48,
//                         width: 48,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(height: 10),
//                       CreditCardForm(
//                         formKey: formKey,
//                         obscureCvv: true,
//                         obscureNumber: true,
//                         cardNumber: cardNumber,
//                         cvvCode: cvvCode,
//                         isHolderNameVisible: true,
//                         isCardNumberVisible: true,
//                         isExpiryDateVisible: true,
//                         cardHolderName: cardHolderName,
//                         expiryDate: expiryDate,
//                         themeColor: Colors.blue,
//                         cardNumberDecoration: InputDecoration(
//                           labelText: 'Number',
//                           hintText: 'XXXX XXXX XXXX XXXX',
//                           hintStyle: const TextStyle(color: kindaBlack),
//                           labelStyle: const TextStyle(color: kindaBlack),
//                           focusedBorder: border,
//                           enabledBorder: border,
//                         ),
//                         expiryDateDecoration: InputDecoration(
//                           hintStyle: const TextStyle(color: kindaBlack),
//                           labelStyle: const TextStyle(color: kindaBlack),
//                           focusedBorder: border,
//                           enabledBorder: border,
//                           labelText: 'Expired Date',
//                           hintText: 'XX/XX',
//                         ),
//                         cvvCodeDecoration: InputDecoration(
//                           hintStyle: const TextStyle(color: kindaBlack),
//                           labelStyle: const TextStyle(color: kindaBlack),
//                           focusedBorder: border,
//                           enabledBorder: border,
//                           labelText: 'CVV',
//                           hintText: 'XXX',
//                         ),
//                         cardHolderDecoration: InputDecoration(
//                           hintStyle: const TextStyle(color: kindaBlack),
//                           labelStyle: const TextStyle(color: kindaBlack),
//                           focusedBorder: border,
//                           enabledBorder: border,
//                           labelText: 'Card Holder',
//                         ),
//                         onCreditCardModelChange: onCreditCardModelChange,
//                         textStyle:
//                             const TextStyle(color: kindaBlack, fontSize: 12),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           backgroundColor: const Color(0xff1b447b),
//                         ),
//                         child: Container(
//                           margin: const EdgeInsets.all(12),
//                           child: const Text(
//                             'Validate',
//                             style: TextStyle(
//                               color: whiteColor,
//                               fontFamily: 'halter',
//                               fontSize: 14,
//                               package: 'flutter_credit_card',
//                             ),
//                           ),
//                         ),
//                         onPressed: () {
//                           if (formKey.currentState!.validate()) {
//                             print('valid!');
//                           } else {
//                             print('invalid!');
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void onCreditCardModelChange(CreditCardModel? creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel!.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }
// }
