import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:ofg_web/firebase_options.dart';

import 'package:ofg_web/views/common/registration_new.dart';

// import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // takes the data in from firebase_options.dart and moves accordingly
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // .then((FirebaseApp val) => Get.put(),);

  runApp(
    MaterialApp(
      title: 'Orderflow General',
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(),
      //  StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.active) {
      //       // connoectec to stream
      //       if (snapshot.hasData) {
      //         return ResponsiveUI(login: true);
      //       }
      //     }

      //     return ResponsiveUI();
      //   },
      // ),
    ),
  );
}
