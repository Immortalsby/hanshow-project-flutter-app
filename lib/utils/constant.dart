import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Colors
const kBackgroundColor = Color(0xFFFEFEFE);
const kTitleTextColor = Color(0xFF303030);
const kBodyTextColor = Color(0xFF4B4B4B);
const kTextLightColor = Color(0xFF959595);
const kInfectedColor = Color(0xFFFF8748);
const kDeathColor = Color(0xFFFF4848);
const kRecovercolor = Color(0xFF36C12C);
const kPrimaryColor = Color(0xFF3382CC);
final kShadowColor = const Color(0xFFB7B7B7).withOpacity(.16);
final kActiveShadowColor = const Color(0xFF4056C6).withOpacity(.15);
const kFaceBookColor = Color(0xFF102397);
const kGoogleColor = Color(0xFFff4f38);
// Text Style
const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);

const kTitleTextstyle = TextStyle(
  fontSize: 18,
  color: kTitleTextColor,
  fontWeight: FontWeight.bold,
);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

String dateValidate(DateTime? time) {
  return time == null ? '' : DateFormat('yyyy-MM-dd').format(time);
}
