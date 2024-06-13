import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ondeindia/constants/color_contants.dart';
import 'package:ondeindia/screens/home/home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPage extends StatefulWidget {
  OTPPage({Key? key}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _mobileNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage(
                        'assets/images/newlogoss.png',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              _otpForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Phone Number \n Verification",
            style: TextStyle(
                fontFamily: 'MonS',
                fontSize: 30,
                color: primaryColor,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "OTP sent to number",
                style: TextStyle(
                  fontFamily: 'MonR',
                  fontSize: 15,
                  color: Color(0xFf4B4B4B),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                " 8976545654",
                style: const TextStyle(
                  fontFamily: 'MonR',
                  fontSize: 20,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: _changeNumberSheet(),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.edit,
                          color: primaryColor,
                        ),
                        const Text(
                          "Edit",
                          style: TextStyle(
                            fontFamily: 'MonR',
                            fontSize: 15,
                            color: Color(0xFf4B4B4B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: PinCodeTextField(
              appContext: context,
              pastedTextStyle: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.bold,
              ),
              length: 6,
              // obscureText: true,
              // obscuringCharacter: '*',
              // obscuringWidget: FlutterLogo(
              //   size: 24,
              // ),
              blinkWhenObscuring: false,
              animationType: AnimationType.slide,
              validator: (v) {
                if (v!.length < 3) {
                  return "I'm from validator";
                } else {
                  return null;
                }
              },
              pinTheme: PinTheme(
                activeColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              // errorAnimationController: errorController,
              // controller: textEditingController,
              keyboardType: TextInputType.number,
              boxShadows: const [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
              onCompleted: (v) {
                print("Completed");
              },
              // onTap: () {
              //   print("Pressed");
              // },
              onChanged: (value) {
                print(value);
                // setState(() {
                //   currentText = value;
                // });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 18.0, top: 25),
            child: Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(45)),
                  child: const Center(
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                          fontFamily: 'MonS',
                          fontSize: 25,
                          color: whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          InkWell(
            onTap: () {
              // setState(() {
              //   login = !login;
              // });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't recieve otp?",
                  style: TextStyle(
                    fontFamily: 'MonR',
                    fontSize: 15,
                    color: Color(0xFf4B4B4B),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  " Resend OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MonR',
                    fontSize: 20,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetForChangeNumber(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: MediaQuery.of(context).size.height / 1.9,
              child: _changeNumberSheet()),
        ),
      ),
    );
  }

  Widget _changeNumberSheet() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  height: 10,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Edit Mobile Number for \n Verification",
                style: const TextStyle(
                    fontFamily: 'MonS',
                    fontSize: 20,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Card(
                  // color: ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: _mobileNumberController,
                    autocorrect: true,
                    cursorColor: const Color(0xFF43D194),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: number,
                      labelStyle: const TextStyle(color: Color(0xFF43D194)),
                      prefixIcon: const Icon(
                        LineIcons.mobilePhone,
                        size: 20,
                        color: Color(0xFF43D194),
                      ),
                      hintStyle: const TextStyle(color: Color(0xFF43D194)),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    validator: (value) {
                      // ignore: unrelated_type_equality_checks
                      if (value != 10) {
                        return 'Please Enter valid number 😕';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancle",
                        style: TextStyle(
                          fontFamily: 'MonR',
                          fontSize: 15,
                          color: Color(0xFf4B4B4B),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => OTPPage(),
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Change Number",
                                  style: TextStyle(
                                      fontFamily: 'MonS',
                                      fontSize: 20,
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
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
  }
}
