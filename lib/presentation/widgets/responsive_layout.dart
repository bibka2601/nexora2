import 'package:flutter/material.dart';

double responsiveHorizontalPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 420) return 16;
  if (width < 900) return 32;
  return 60;
}

EdgeInsets responsiveSectionInsets(
  BuildContext context, {
  required double vertical,
}) {
  final width = MediaQuery.sizeOf(context).width;
  final verticalScale = width < 600 ? 0.65 : width < 900 ? 0.8 : 1.0;
  return EdgeInsets.symmetric(
    horizontal: responsiveHorizontalPadding(context),
    vertical: vertical * verticalScale,
  );
}

double responsiveCardPadding(
  BuildContext context, {
  double desktop = 50,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 420) return 18;
  if (width < 600) return 24;
  if (width < 900) return 32;
  return desktop;
}

double responsiveHeadingSize(
  BuildContext context, {
  double desktop = 52,
}) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 360) return 28;
  if (width < 600) return 34;
  if (width < 900) return 42;
  return desktop;
}


