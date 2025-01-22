// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';

class QRPage extends StatelessWidget {
  String storeName;
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  QRPage({Key? key, required this.storeName}) : super(key: key);
  final FirebaseRoutes _route = FirebaseRoutes();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: cWidgetsInstance.customAppBar(context, false, true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              storeName,
              textAlign: TextAlign.center,
              style: GoogleFonts.heebo(
                  fontWeight: FontWeight.bold,
                  color: ColorPalette().secondaryTextColor,
                  fontSize: 25),
            ),

            Text(
              'Use this QR code to get more exposure for your store!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorPalette().tertiaryTextColor, fontSize: 16),
            ),

            // qrc
            Center(
              child: QrImageView(
                  gapless: false,
                  data:
                      '${_route.rootCollection}/${_route.profileDoc}/${_route.fUid}',
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: ColorPalette().secondaryTextColor,
                  ),
                  size: height * 0.3),
            ),

            Text(
              'This is a multi-purpose QR code for this particular store only.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorPalette().tertiaryTextColor, fontSize: 12),
            ),
            SizedBox(
              height: height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
