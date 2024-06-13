import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart';

class TestPlaces extends StatefulWidget {
  TestPlaces({Key? key}) : super(key: key);

  @override
  State<TestPlaces> createState() => _TestPlacesState();
}

class _TestPlacesState extends State<TestPlaces> {
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  @override
  void initState() {
    String apiKey = 'AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM';
    // String apiKey = DotEnv().env['AIzaSyD9NTrmr2LRElANk_6GKS_VzHzGEpluBDM']!;
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Search",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    autoCompleteSearch(value);
                  } else {
                    if (predictions.length > 0 && mounted) {
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(predictions[index].description!),
                      onTap: () {
                        debugPrint(predictions[index].placeId);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailsPage(
                        //       placeId: predictions[index].placeId,
                        //       googlePlace: googlePlace,
                        //     ),
                        //   ),
                        // );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Image.asset("assets/powered_by_google.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace!.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
