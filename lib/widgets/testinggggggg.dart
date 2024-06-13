import 'package:flutter/material.dart';
import 'package:mobile_number_picker/mobile_number_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MobileNumberPicker mobileNumber = MobileNumberPicker();
  MobileNumber mobileNumberObject = MobileNumber();

  @override
  void dispose() {
    mobileNumber?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      mobileNumber.mobileNumber();
    });

    mobileNumber.mobileNumber();

    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => mobileNumber.mobileNumber());
    mobileNumber.getMobileNumberStream.listen((event) {
      print("called numbers ===>");
    });
    func();
  }

  func() async {
    mobileNumber.getMobileNumberStream.listen((MobileNumber? event) {
      if (event?.states == PhoneNumberStates.PhoneNumberSelected) {
        setState(() {
          mobileNumberObject = event!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mobile Number Plugin'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) => mobileNumber.mobileNumber());
                    await func();
                  },
                  child: Text("slkdfhalsfhs")),
              ElevatedButton(
                onPressed: () async {
                  await func();
                },
                child: Text(
                    'Mobile Number: ${mobileNumberObject?.phoneNumber}\n Country Code: ${mobileNumberObject?.countryCode}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
