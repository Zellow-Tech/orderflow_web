import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  String firebaseUid;
  String storeName;
  String ownerName;
  String emailId;
  String phoneNumber;
  String address;
  String bio;
  String profilePicture;
  bool isBanned;

  List<String> upiIds;
  List<dynamic> metadata;

  VendorModel(
      {required this.firebaseUid,
      required this.storeName,
      required this.ownerName,
      required this.emailId,
      required this.phoneNumber,
      required this.address,
      required this.bio,
      required this.isBanned,
      required this.profilePicture,
      required this.metadata,
      required this.upiIds});

  toMap() {
    return {
      'firebaseUid': firebaseUid,
      'storeName': storeName,
      'ownerName': ownerName,
      'emailId': emailId,
      'phoneNumber': phoneNumber,
      'address': address,
      'bio': bio,
      'profilePicture': profilePicture,
      'upiIds': upiIds,
      'metadata': metadata,
      'isBanned': isBanned,
    };
  }

  fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> snap = (snapshot.data() as Map<String, dynamic>);
    return VendorModel(
        isBanned: snap['isBanned'],
        firebaseUid: snap['firebaseUid'],
        storeName: snap['storeName'],
        ownerName: snap['ownerName'],
        emailId: snap['emailId'],
        phoneNumber: snap['phoneNumber'],
        address: snap['address'],
        bio: snap['bio'],
        profilePicture: snap['profilePicture'],
        metadata: snap['metadata'],
        upiIds: snap['upiIds']);
  }
}
