import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

lottieStru() {
  return Container(
    height: 180,
    width: 180,
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Lottie.asset('assets/animation/safedrive.json', fit: BoxFit.cover),
    ),
  );
}
