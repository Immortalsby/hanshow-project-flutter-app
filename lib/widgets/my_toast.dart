import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class MyToast {
  static show(text) {
    showToast(text,
        dismissOtherToast: true,
        duration: const Duration(milliseconds: 3500),
        position: ToastPosition.bottom,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 16.0, fontFamily: "Poppins", color: Colors.white));
  }
}
