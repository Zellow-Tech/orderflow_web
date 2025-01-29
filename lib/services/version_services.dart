// import 'package:flutter/material.dart';
// import 'package:web_scraper/web_scraper.dart';

// const String currentVersion = '1.0.1';
// const String baseUrl = 'https://shimronalakkal.github.io/';
// const String endpoint = 'opentest/';

// class AppVersionService {
//   AppVersionService();

//   // checks for the latest version to see if the value matches
//   versionNumberCheck() async {
//     final webScraper = WebScraper(baseUrl);
//     try {
//       if (await webScraper.loadWebPage(endpoint)) {
//         List<Map<String, dynamic>> elements =
//             webScraper.getElement('a.version', ['']);
//         return elements[0]['title'].toString();
//       }
//     } catch (e) {
//       null;
//     }
//   }

//   // update mode checker to see if you have to prompt for a force update.
//   updateModeCheck() async {
//     final scraper = WebScraper(baseUrl);
//     try {
//       if (await scraper.loadWebPage(endpoint)) {
//         List<Map<String, dynamic>> elements =
//             scraper.getElement('a.updateMode', ['']);
//         return elements[0]['title'].toLowerCase();
//       }
//     } catch (e) {
//       null;
//     }
//   }

//   // update prompt provider
//   appUpdateCheck({required BuildContext context}) async {
//     var mode = await updateModeCheck();
//     var version = await versionNumberCheck();

//     if (version != currentVersion) {
//       // check mode to prompt
//       updateDialog(context, mode == 'force' ? true : false);
//     }
//   }

//   updateDialog(BuildContext context, bool force) {
//     return showDialog(
//       barrierDismissible: force,
//       barrierColor: Colors.grey,
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text(
//             'App Update',
//             style: TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22),
//           ),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//           actions: [
//             // the cancel button
//             force
//                 ? OutlinedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.grey),
//                     ))
//                 : const SizedBox(width: 0, height: 0),

//             // the update button
//             ElevatedButton.icon(
//               onPressed: () {
//                 // go to the play store page.
//               },
//               icon: const Icon(
//                 Icons.update_rounded,

//               ),
//               label: const Text(
//                 'Update',
//               ),
//             ),
//           ],
//           content: force
//               ? const Text(
//                   'Orderflow General requires you to update the app.\n Click the button below and start the update.')
//               : const Text(
//                   'Orderflow General has an optional update for the app. Click the button below to start the update.'),
//         );
//       },
//     );
//   }
// }

// class NotificationService {
//   NotificationService();

//   latestVendorNotification() async {
//     final scraper = WebScraper(baseUrl);
//     if (await scraper.loadWebPage(endpoint)) {
//       List<Map<String, dynamic>> elements =
//           scraper.getElement('a.vendorNotification', ['']);
//       return elements[0]['title'].toLowerCase();
//     }
//   }
// }
