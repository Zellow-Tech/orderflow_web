import 'package:flutter/material.dart';

class OFGDeviceType {
  static const double mobileMaxWidth = 600; // Max width for mobile devices
  static const double tabletMaxWidth = 1200; // Max width for tablets

  /// Determines if the device is a mobile and returns true or false.
  static bool isMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth <= mobileMaxWidth;
  }

  /// Determines if the device is a tablet and returns true or false.
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > mobileMaxWidth && screenWidth <= tabletMaxWidth;
  }

  /// Determines if the device is a web or desktop app and returns true or false.
  static bool isWebOrDesktop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > tabletMaxWidth;
  }

  /// Returns a string description of the device type (optional utility).
  static String getDeviceType(BuildContext context) {
    if (isMobile(context)) {
      return 'Mobile';
    } else if (isTablet(context)) {
      return 'Tablet';
    } else {
      return 'Web/Desktop';
    }
  }
}