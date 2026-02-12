import 'package:flutter/material.dart';

abstract class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration med = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 450);
  static const Curve primary = Curves.easeOut;
  static const Curve smooth = Curves.easeInOut;
}
