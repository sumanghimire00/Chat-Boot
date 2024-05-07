import 'package:flutter/material.dart';

class CommonFunction {
  static blanckSpace(double? height, double? width) {
    return SizedBox(
      height: height ?? 0,
      width: width ?? 0,
    );
  }
}
