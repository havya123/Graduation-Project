import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graduation_project/app/store/app_store.dart';
import 'package:graduation_project/manage/firebase_service/firebase_service.dart';
import 'package:graduation_project/model/driver.dart';
import 'package:image_picker/image_picker.dart';

class UserRepo {
  Future<void> updateProfile(
      String name, String phone, String email, String address) async {
    var response = await FirebaseService.userRef
        .where('uid', isEqualTo: AppStore.to.uid)
        .get();
    await FirebaseService.userRef.doc(response.docs.first.id).update({
      'userName': name,
      'phoneNumber': phone,
      'email': email,
      'address': address,
    });
  }

  Future<String> uploadImage(String userId, XFile xFile) async {
    String fileName = xFile.path.split("/").last;
    String imagesLink = "";
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/parcel/$userId/parcelImage/$fileName');

      await ref.putFile(File(xFile.path));

      String downloadURL = await ref.getDownloadURL();
      imagesLink = downloadURL;
      await updateImage(userId, imagesLink);
      return downloadURL;
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<void> updateImage(String userId, String imageUrl) async {
    try {
      await FirebaseService.userRef
          .where('uid', isEqualTo: userId)
          .get()
          .then((value) async {
        await FirebaseService.userRef
            .doc(value.docs.first.id)
            .update({'avatar': imageUrl});
      });
    } catch (e) {
      print(e);
    }
  }

    Future<Driver?> getDriver(String uid) async {
    try {
      DatabaseReference databaseReference =
          FirebaseService.driverRef.child(uid);

      // Listen for the once event
      DatabaseEvent event = await databaseReference.once();

      // Access the snapshot property of the event
      DataSnapshot dataSnapshot = event.snapshot;

      // Check if dataSnapshot.value is a Map
      if (dataSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> userData =
            dataSnapshot.value as Map<dynamic, dynamic>;

        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        Map<String, dynamic> userDataStringKey =
            userData.map((key, value) => MapEntry(key.toString(), value));

        return Driver.fromMap(userDataStringKey);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

}
