// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ofg_web/views/home.dart';
import 'package:ofg_web/views/vendor/vendor_home.dart';

class ResponsiveUI extends StatelessWidget {
  bool? login;
  ResponsiveUI({Key? key, this.login}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return login == true ? const VendorHome() : const Home();
    });
  }
}
