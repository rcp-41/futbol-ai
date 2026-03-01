import 'package:flutter/material.dart';

/// FutbolAI text styles — reusable typography tokens
class TextStyles {
  TextStyles._();

  static const TextStyle h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static const TextStyle h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static const TextStyle h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
  static const TextStyle h4 = TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  static const TextStyle body1 = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5);
  static const TextStyle body2 = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle caption = TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3);
}
