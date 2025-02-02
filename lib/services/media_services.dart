import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ofg_web/utils/text_formatting.dart';

class MediaServices {
  String type;
  String uid;
  MediaServices({required this.type, required this.uid});

  final OFGTextFormatting _formatting = OFGTextFormatting();

  // method to pick image from gallery
  pickImageFromGallery() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
      if (image != null) {
        return File(image.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // take image using camera
  takePicturesUsingCamera(BuildContext context) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
      if (image != null) {
        return File(image.path);
      } else {
        return null;
      }
    } catch (e) {
      _formatting.errorTextHandling(
        e.toString(),
      );
    }
  }

  // Media upload to destination
  mediaUploadToRoute(
      {required String route,
      required List files,
      required BuildContext context}) async {
    // the list of uris to send to the backend
    List<String> urls = [];
    // loop over each image in files and then upload and get their download links
    for (File image in files) {
      //try
      try {
        // firebase image storage reference
        Reference ref = FirebaseStorage.instance
            .ref()
            .child(route + image.path.split('/').last.toString());

        // now put the file there since you've got thr reference
        await ref.putFile(image).whenComplete(
          () async {
            await ref.getDownloadURL().then(
              (value) {
                urls.add(value);
              },
            );
          },
        );
      } catch (e) {
        _formatting.errorTextHandling(
          e.toString(),
        );
      }
    }

    return urls;
  }

  // Media deletion function to delete uploaded media frmo firebase storage
  mediaDeletionFromStorage(
      {required BuildContext context, required String route}) async {
    try {
      await FirebaseStorage.instance.ref(route).listAll().then((value) {
        for (var element in value.items) {
          FirebaseStorage.instance.ref(element.fullPath).delete();
        }
      });
    } catch (e) {
      _formatting.errorTextHandling(
        e.toString(),
      );
    }
  }
}
