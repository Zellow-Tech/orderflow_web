import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ofg_web/utils/responsive.dart';
// import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
    
);

// Your web app's Firebase configuration
// const firebaseConfig = {
//   apiKey: "AIzaSyCFt1UgnyET1sUemsXPyUjST7MquBZCJzU",
//   authDomain: "orderflow-general.firebaseapp.com",
//   projectId: "orderflow-general",
//   storageBucket: "orderflow-general.appspot.com",
//   messagingSenderId: "572995758259",
//   appId: "1:572995758259:web:43304500273b29d0e628c6"
// };

  MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(
    MaterialApp(
      title: 'Orderflow General',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // connoectec to stream
            if (snapshot.hasData) {
              return ResponsiveUI(login: true);
            }
          }

          return ResponsiveUI();
        },
      ),
    ),
  );
}
