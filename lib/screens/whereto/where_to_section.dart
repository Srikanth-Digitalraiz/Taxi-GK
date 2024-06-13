import 'package:flutter/material.dart';
import 'package:ondeindia/constants/color_contants.dart';

class WhereToSection extends StatefulWidget {
  WhereToSection({Key? key}) : super(key: key);

  @override
  State<WhereToSection> createState() => _WhereToSectionState();
}

class _WhereToSectionState extends State<WhereToSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        iconTheme: const IconThemeData(color: whiteColor),
        title: const Text(
          "Where To ?",
          style: TextStyle(
            fontFamily: 'MonS',
            fontSize: 13,
            color: whiteColor,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF43D194),
                Color(0xFF4ECBA3),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _searchField(),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        color: Color(0xFFE8F1F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 2,
        child: Container(
          height: 50,
          child: TextFormField(
            keyboardType: TextInputType.name,
            // controller: _filter,
            autocorrect: true,
            cursorColor: kindaBlack,
            decoration: const InputDecoration(
              hintText: 'Search..',
              labelStyle: TextStyle(color: kindaBlack),
              prefixIcon: Icon(
                Icons.search,
                color: primaryColor,
              ),
              suffixIcon: Icon(
                Icons.location_on,
                color: Color(0xFF348BF5),
              ),
              hintStyle: const TextStyle(color: kindaBlack),
              filled: true,
              fillColor: Color(0xFFE8F1F5),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(color: Color(0xFFE8F1F5), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide(color: Color(0xFFE8F1F5), width: 2),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Field should not be empty';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
