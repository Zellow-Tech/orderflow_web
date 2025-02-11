import 'package:firebase_auth/firebase_auth.dart';

// firebase uid
fuid() {
  return FirebaseAuth.instance.currentUser!.uid;
}

class OFGFirebaseRoutes {
/* This class holds the important routes for storing the images,
and other files in the cloud, namely firebase
  */

  // firestore collections
  String rootCollection = 'Vendor';

  // firestore docs
  String profileDoc = 'Profile';
  String storeDoc = 'Store';

  String profileData = 'ProfileData';
  String fUid = fuid();

  String checkoutRoot = 'Checkouts';
  String checkoutDoc = 'Docs';
  // Item routes for vendor
  String vendorItemStorageRoute = "Vendor/Store/${fuid()}/";

  // vendor profile route
  String vendorProfileRoute = "Vendor/Profile/${fuid()}/";

  // bill registration route
  String checkOutRoute = "Checkouts/${fuid()}/Docs/";
}