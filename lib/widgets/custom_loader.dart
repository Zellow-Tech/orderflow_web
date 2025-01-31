// the custom splash loading animation
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoaders {
  dataLoaderAnimation(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Orderflow',
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'General',
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.35,
                child: const LinearProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
