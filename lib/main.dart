import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ofg_web/firebase_options.dart';
import 'package:ofg_web/routes/app/app_endpoints.dart';
import 'package:ofg_web/routes/app/app_routes.dart';
import 'package:ofg_web/views/auth/login_screen.dart';

// import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // takes the data in from firebase_options.dart and moves accordingly
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // .then((FirebaseApp val) => Get.put(),);

  runApp(
    GetMaterialApp(
      title: 'OrderFlow General',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,

      // routes (just like above, but with more capabilities)
      getPages: OFGPages.pages,
      initialRoute: OFGEndpoints.login,

      // unknown error
      unknownRoute: GetPage(
        name: '/404',
        page: () => Scaffold(body: Center(child: Text('Page Not Found'))),
      ),
    ),
  );
}
